#!/usr/bin/env python

import sys

for line in sys.stdin:
    line = line.strip()
    words = line.split()
    for word in words:
        # sys.stdout.write(f"{word}\t{1}")
        print(f"{word}\t{1}")