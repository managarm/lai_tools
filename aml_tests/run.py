#!/usr/bin/env python3

import os
import subprocess
import sys
import tempfile

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
                print("Expected {} but trace shows {}".format(e, t))
                errors += 1
            else:
                print("Successfully verified {}".format(e))
        elif e.fn == 'integer':
            if t.fn != 'integer' or e.args[0] != t.args[0]:
                print("Expected {} but trace shows {}".format(e, t))
                errors += 1
            else:
                print("Successfully verified {}".format(e))
        else:
            raise RuntimeError("Unexpected s-expr {}".format(e.fn));
        n += 1

    print("Verified {} items, {} errors".format(n, errors))

    if n < len(expected):
        raise RuntimeError("Less items in output than expected")
    elif n < len(trace):
        raise RuntimeError("More items in output than expected")
    elif errors:
        return False
    return True

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
laiexec = subprocess.check_output(['./' + sys.argv[1], path],
        universal_newlines=True)
trace_script = ''
for line in laiexec.split('\n'):
    if not line.startswith('amldebug: '):
        continue
    trace_script += line[len('amldebug: '):] + '\n'

trace = Sxpr.parse(trace_script)

# Verify the output, return non-zero on error.
if not verify(expected, trace):
    sys.exit(1)

