#!/usr/bin/env python

import json, sys, re, csv

def process_dtimings(txt):
    filename = None
    stack = []
    for line in txt.split('\n'):
        if not line: continue
        if ' file=' in line:
            tot, filename = line.split(' file=', 1)
            yield (filename, tot, "total")
        elif filename is not None:
            s = line.lstrip(' ')
            time, cat = s.split('s ', 1)
            indent = len(line) - len(s)
            while len(stack) > 0 and stack[-1][0] >= indent:
                stack.pop()
            stack.append((indent, cat))
            cat = ".".join(c for _,c in stack)
            yield (filename, time, cat)

def process_trace(filename):
    trace = json.load(open(filename))
    for ev in trace:
        if ev['ph'] == 'C':
            pass # counters
        elif ev['ph'] == 'i' and ev['cat'] == 'config' and ev['name'] == 'config':
            pass # startup config
        elif ev['ph'] == 'X' and ev['cat'] == '':
            pass # dune internal
        elif ev['ph'] == 'X' and ev['cat'] == 'process':
            for filename, time, cat in process_dtimings(ev['args'].get('stdout', '')):
                yield (ev['name'], filename, time, cat)
            pass
        else:
            print(ev)
            raise Exception("uniplemented event type " + ev['ph'])


csv = csv.writer(sys.stdout)
csv.writerow(['tool','filename','time','category'])
for row in process_trace(sys.argv[1]):
    csv.writerow(row)
