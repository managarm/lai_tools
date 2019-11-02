#!/usr/bin/env python3

import os
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
                    script = Sxpr.parse(line[len('expect:'):])
                    assert len(script) == 1
                    self.expected.append(script[0])
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
        self.process = subprocess.Popen(['./' + sys.argv[1], aml_path],
                stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                universal_newlines=True)

        while True:
            line = self.process.stdout.readline()
            if not line: # readline() returns "" on EOF.
                break

            assert line.endswith('\n')
            line = line[:-1]

            if line.startswith('amldebug: '):
                # TODO: Parse every trace line as a single Sxpr?
                self._handle_amldebug(line[len('amldebug: '):])
            else:
                print('    ' + line)

        # Wait until the process truely terminates (stdout might be closed before that).
        self.process.wait()

        return self._verify()

    def _handle_amldebug(self, line):
        trace = Sxpr.parse(line)
        assert len(trace) == 1

        e = self.expected[self.c]
        t = trace[0]
        print_unclear('  ? {}'.format(t))
        if not compare_object(e, t):
            print_bad(" -> Expected {} but trace shows {}".format(e, t))
            self.errors += 1
        else:
            print_good(" -> Verified against {}".format(e))
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
