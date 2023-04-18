#!/usr/bin/env python

# name    :	parse_py_configure.py
# version :	0.0.1
# date    :	20230418
# author  :	Leam Hall
# desc    :	Parses the results of Python build ./configure


import argparse
import os.path
import sys


def build_lists(data):
    """
    filename => lists of endings and "no" values
    Returns a list of all phrases after a '... ' line, and all
      values that end in "no", that are not preceded by "bug" or "broken"
    """
    endings = {}
    headers = []
    no      = []
    for line in data:
        line = line.strip()
        if "... " in line:
            prefix, suffix = line.split("... ")
            suffix = suffix.strip()
            endings[suffix] = 1
            if suffix == 'no':
                item = prefix.replace("checking for ", "")
                item = item.strip()
                if item.endswith(("bug", "usability", "presence")) or item.startswith(("broken")):
                    continue
                if item.endswith('.h'):
                    headers.append(item)
                else:
                    no.append(item)
                

    no.sort()
    return list(endings.keys()), headers, no

if __name__ == "__main__":

    parser  = argparse.ArgumentParser()
    parser.add_argument(
        "-f", "--file", 
        help        = "File to parse", 
        required    = True)
    parser.add_argument(
        "--headers",
        help    = "Print the missing headers",
        action  = "store_true",
        default = False)

    args    = parser.parse_args()

    if os.path.exists(args.file):
        try:
            with open(args.file, 'r') as f:
                data = f.readlines()
        except Exception as e:
            print(e)
            sys.exit(1)

    endings, headers, no = build_lists(data)
    if args.headers:
        for item in headers:
            print(item)
    else:
        for item in no:
            print(item)
