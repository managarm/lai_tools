#!/usr/bin/env python3

import os
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
                while s[i].isalpha():
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
            elif s[i] in '0123456789':
                x = 0
                while s[i] in '0123456789':
                    x = x * 10 + int(s[i])
                    i += 1
                stack[-1].args.append(x)
            else:
                raise RuntimeError("Unexpected character {} in s-expr".format(s[i]))
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

def verify(expected, trace):
    n = 0
    errors = 0
    for (e, t) in zip(expected, trace):
        if e.fn == 'string':
            if t.fn != 'string' or e.args[0] != t.args[0]:
                print_bad("  * Expected {} but trace shows {}".format(e, t))
                errors += 1
            else:
                print_good("  * Successfully verified {}".format(e))
        elif e.fn == 'integer':
            if t.fn != 'integer' or e.args[0] != t.args[0]:
                print_bad("  * Expected {} but trace shows {}".format(e, t))
                errors += 1
            else:
                print_good("  * Successfully verified {}".format(e))
        else:
            raise RuntimeError("Unexpected s-expr {}".format(e.fn));
        n += 1

    print_colored(bad_color if errors else good_color,
            "  = Verified {} items, {} errors".format(n, errors))

    if n < len(expected):
        print_bad("  = Less items in output than expected")
        return False
    elif n < len(trace):
        print_bad("  = More items in output than expected")
        return False
    elif errors:
        return False
    return True

testcase = os.path.basename(sys.argv[2])
print("Running LAI unit test {}".format(testcase))

# Extract the expected output from comments in the ASL file.
expected_script = ''
with open(sys.argv[2]) as f:
    for line in f:
        if not line.startswith('//!'):
            continue
        expected_script += line[len('//!'):]

expected = Sxpr.parse(expected_script)

# Compile the ASL to AML.
(fd, path) = tempfile.mkstemp(suffix='.aml')
os.close(fd)

# Note that we disable optimizations to that LAI sees the source ASL.
subprocess.check_call(['iasl', '-p', path, '-oa', sys.argv[2]],
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

# Run the LAI's interpreter on the AML and parse the trace.
laiexec = subprocess.Popen(['./' + sys.argv[1], path],
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        universal_newlines=True)

(stdout, _) = laiexec.communicate()

print_colored(bad_color if laiexec.returncode else good_color,
        "  = laiexec returned {}, verifying trace...".format(laiexec.returncode))

trace_script = ''
for line in stdout.strip().split('\n'):
    if line.startswith('amldebug: '):
        # TODO: Parse every trace line as a single Sxpr?
        trace_line = line[len('amldebug: '):]
        print_unclear('  ? ' + trace_line)
        trace_script += trace_line + '\n'
    else:
        print('    ' + line)

trace = Sxpr.parse(trace_script)

# Verify the output, return non-zero on error.
if not verify(expected, trace):
    sys.exit(1)

if laiexec.returncode:
    sys.exit(1)

