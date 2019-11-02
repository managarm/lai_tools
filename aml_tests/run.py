#!/usr/bin/env python3

import collections
import enum
import os
import re
import signal
import subprocess
import sys
import tempfile

unclear_color = '\x1b[33m'
good_color = '\x1b[32m'
bad_color = '\x1b[31m'
reset_code = '\x1b[0m'

def print_colored(color_code, *args):
    print(color_code, end='')
    print(*args, end='')
    print(reset_code)

def print_unclear(*args):
    print_colored(unclear_color, *args)

def print_good(*args):
    print_colored(good_color, *args)

def print_bad(*args):
    print_colored(bad_color, *args)

if not sys.stdout.isatty():
    unclear_color = ''
    good_color = ''
    bad_color = ''
    reset_code = ''

class Action(enum.Enum):
    EXPECT = 1
    PIO_WRITE = 2
    PIO_READ = 3

class Sxpr:
    @staticmethod
    def parse(s):
        i = 0
        stack = [ ]
        res = [ ]
        while i < len(s):
            if s[i].isspace():
                i += 1
            elif s[i] == '(':
                i += 1
                fn = ''
                while s[i].isalpha() or s[i] == '_':
                    fn += s[i]
                    i += 1
                stack.append(Sxpr(fn))
            elif s[i] == ')':
                i += 1
                sxpr = stack.pop()
                if stack:
                    stack[-1].args.append(sxpr)
                else:
                    res.append(sxpr)
            elif s[i] == '"':
                i += 1
                x = ''
                while s[i] != '"':
                    x += s[i]
                    i += 1
                i += 1
                stack[-1].args.append(x)
            elif s[i].isdigit():
                x = 0
                base = 10
                if s[i] == '0' and not s[i + 1].isdigit():
                    if s[i + 1] == 'x':
                        base = 16
                        i += 2
                    elif s[i + 1] == 'b':
                        base = 2
                        i += 2
                while s[i].lower() in '0123456789abcdef'[:base]:
                    x = x * base + int(s[i].lower(), base)
                    i += 1
                stack[-1].args.append(x)
            else:
                raise RuntimeError("Unexpected character {} in s-expr ({})".format(s[i], s[i:]))
        assert not stack
        return res

    def __init__(self, fn):
        self.fn = fn
        self.args = []

    def __str__(self):
        arg_strs = []
        for arg in self.args:
            if isinstance(arg, str):
                arg_strs.append('"' + arg + '"')
            else:
                arg_strs.append(str(arg))
        return '(' + self.fn + (' ' + ' '.join(arg_strs) if arg_strs else '') + ')'

PioData = collections.namedtuple('PioData', 'bits port value')

def first_arg_equals(e, t):
    """
    Return true if the first args are equal in both
    """
    return e.args[0] == t.args[0]

def type_equals(e, t):
    """
    Will always return true, assuming the types of
    both are equal (which is checked in compare_object)
    """
    return True

def package_comparison(e, t):
    """
    Will just compare the objects inside of the package
    """
    if len(e.args) != len(t.args):
        return False
    for a1, a2 in zip(e.args, t.args):
        if not compare_object(a1, a2):
            return False
    return True

def buffer_comparison(e, t):
    """
    Will compare the elements inside the buffers
    """
    if len(e.args) != len(t.args):
        return False
    for a1, a2 in zip(e.args, t.args):
        if a1 != a2:
            return False
    return True

# Table to quickly lookup the comparison to run
COMPARISON_TABLE = {
    'uninitialized': type_equals,
    'integer': first_arg_equals,
    'string': first_arg_equals,
    'buffer': buffer_comparison,
    'string_index': type_equals,
    'buffer_index': type_equals,
    'package_index': type_equals,
    'package': package_comparison
}

def compare_object(e, t):
    """
    Will make sure both types match and will run
    the correct comparison for them
    """
    if e.fn not in COMPARISON_TABLE:
        raise RuntimeError("Unexpected s-expr {}".format(e.fn))
    return e.fn == t.fn and COMPARISON_TABLE[e.fn](e, t)

def parse_bits(s):
    m = re.fullmatch(r'(\d+)b', s)
    if not m:
        raise RuntimeError("Expected number of bits (8b, 16b, ...), got {}".format(s))
    return m.group(1)

def parse_int(s):
    return int(s, 0) # base = 0 makes Python handle the 0x prefix automatically.

class Verifier:
    def __init__(self, path):
        self.path = path
        self.expected = []
        self.process = None
        self.c = 0 # Current index into self.expected.
        self.errors = 0 # Number of errors.

        # Extract the expected output from comments in the ASL file.
        expected_script = ''
        with open(self.path) as f:
            for line in f:
                line = line.lstrip()
                if not line.startswith('//!'):
                    continue
                line = line[len('//!'):].lstrip()

                if line.startswith('expect:'):
                    exprs = Sxpr.parse(line[len('expect:'):])
                    assert len(exprs) == 1
                    self.expected.append((Action.EXPECT, exprs[0]))
                elif line.startswith('io-write:'):
                    tokens = line[len('io-write:'):].strip().split(' ')
                    assert tokens[0] == 'pio'
                    assert len(tokens) == 5
                    assert tokens[3] == '='
                    bits = parse_bits(tokens[1])
                    port = parse_int(tokens[2])
                    value = parse_int(tokens[4])
                    self.expected.append((Action.PIO_WRITE, PioData(bits, port, value)))
                elif line.startswith('io-read:'):
                    tokens = line[len('io-read:'):].strip().split(' ')
                    assert tokens[0] == 'pio'
                    assert len(tokens) == 5
                    assert tokens[3] == '='
                    bits = parse_bits(tokens[1])
                    port = parse_int(tokens[2])
                    value = parse_int(tokens[4])
                    self.expected.append((Action.PIO_READ, PioData(bits, port, value)))
                else:
                    raise RuntimeError("Unexpected //! line '{}'".format(line))

    def run(self):
        # Compile the ASL to AML.
        (fd, aml_path) = tempfile.mkstemp(suffix='.aml')
        os.close(fd)

        # Note that we disable optimizations to that LAI sees the source ASL.
        subprocess.check_call(['iasl', '-p', aml_path, '-oa', self.path],
                stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

        # Run the LAI's interpreter on the AML and parse the trace.
        self.process = subprocess.Popen(['./' + sys.argv[1], '--io', aml_path],
                stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                universal_newlines=True)

        while True:
            line = self.process.stdout.readline()
            if not line: # readline() returns "" on EOF.
                break

            assert line.endswith('\n')
            line = line[:-1]

            if line.startswith('amldebug:'):
                self._handle_amldebug(line[len('amldebug:'):])
            elif line.startswith('io-write: '):
                self._handle_io_write(line[len('io-write:'):])
            elif line.startswith('io-read:'):
                self._handle_io_read(line[len('io-read:'):])
            else:
                print('    ' + line)

        # Wait until the process truely terminates (stdout might be closed before that).
        self.process.wait()

        return self._verify()

    def _handle_amldebug(self, line):
        exprs = Sxpr.parse(line)
        assert len(exprs) == 1
        sx = exprs[0]
        print_unclear('  ? amldebug: {}'.format(sx))

        if self.c >= len(self.expected):
            print_bad(" -> Expected termination")
            self.c += 1
            return

        (action, e) = self.expected[self.c]
        if action != Action.EXPECT:
            print_bad(" -> Expected {}".format(action))
            self.errors += 1
            return

        if not compare_object(e, sx):
            print_bad(" -> Expected {} but trace shows {}".format(e, sx))
            self.errors += 1
        else:
            print_good(" -> Verified against {}".format(e))
        self.c += 1

    def _handle_io_write(self, line):
        tokens = line.strip().split(' ')
        assert tokens[0] == 'pio'
        assert len(tokens) == 5
        assert tokens[3] == '='
        print_unclear('  ? io-write: pio {} {} = {}'.format(tokens[1], tokens[2], tokens[4]))

        if self.c >= len(self.expected):
            print_bad(" -> Expected termination")
            self.c += 1
            return

        (action, e) = self.expected[self.c]
        if action != Action.PIO_WRITE:
            print_bad(" -> Expected {}".format(action))
            self.errors += 1
            return

        fail = False
        if parse_bits(tokens[1]) != e.bits:
            print_bad(" -> Expected {}b".format(e.bits))
            fail = True
        if parse_int(tokens[2]) != e.port:
            print_bad(" -> Expected port 0x{:x}".format(e.port))
            fail = True
        if parse_int(tokens[4]) != e.value:
            print_bad(" -> Expected value 0x{:x}".format(e.value))
            fail = True

        if not fail:
            print_good(" -> Verified")
        else:
            self.errors += 1
        self.c += 1

    def _handle_io_read(self, line):
        tokens = line.strip().split(' ')
        assert tokens[0] == 'pio'
        assert len(tokens) == 5
        assert tokens[3] == '='
        assert tokens[4] == '?'
        print_unclear('  ? io-read: pio {} {} = ?'.format(tokens[1], tokens[2]))

        if self.c >= len(self.expected):
            print_bad(" -> Expected termination")
            self.c += 1
            return

        (action, e) = self.expected[self.c]
        if action != Action.PIO_READ:
            print_bad(" -> Expected {}".format(action))
            self.errors += 1
            return

        fail = False
        if parse_bits(tokens[1]) != e.bits:
            print_bad(" -> Expected {}b".format(e.bits))
            fail = True
        if parse_int(tokens[2]) != e.port:
            print_bad(" -> Expected port 0x{:x}".format(e.port))
            fail = True

        if not fail:
            print_good(" -> Verified, returns 0x{:x}".format(e.value))
            self.process.stdin.write(str(e.value) + '\n')
        else:
            self.process.stdin.write(str(0xFFFFFFFF) + '\n')
            self.errors += 1
        self.process.stdin.flush()
        self.c += 1

    def _verify(self):
        message = 'success'
        if self.process.returncode < 0:
            # Some signals have multiple names. Prefer a certain one.
            common_signames = {
                signal.SIGABRT: 'SIGABRT'
            }

            signo = -self.process.returncode
            message = common_signames.get(signo, signal.Signals(signo).name)
        elif self.process.returncode:
            message = 'failure ({})'.format(self.process.returncode)

        print_colored(bad_color if self.process.returncode else good_color,
                " -> laiexec returned {}, verifying trace...".format(message))

        print_colored(bad_color if self.errors else good_color,
                " -> Verified {}/{} items, {} errors".format(self.c,
                        len(self.expected), self.errors))

        if self.c < len(self.expected):
            print_bad(" -> Less items in output than expected")
            return False
        elif self.c > len(self.expected):
            print_bad(" -> More items in output than expected")
            return False
        elif self.errors:
            return False
        elif self.process.returncode:
            return False
        return True

testcase = os.path.basename(sys.argv[2])
print("Running AML unit test {}".format(testcase))

ver = Verifier(sys.argv[2])

# Verify the output, return non-zero on error.
if not ver.run():
    sys.exit(1)
