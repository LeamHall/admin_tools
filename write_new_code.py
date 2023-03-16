#!/usr/bin/env python3

# name:     write_new_code.py
# version:  0.0.2
# date:     20221201
# author:   Leam Hall
#
# desc:     Write boilerplate info into new code.

## Usage:
#  write_new_code.py  -f some_cool_code.py

## TODO
# Add other languages.
# Verify comment characters for different languages.


import argparse
from datetime import date
from os import chmod, path

headers = {
    "name": "",
    "version": "0.0.1",
    "date": 0,
    "author": "",
    "desc": "",
}

languages = {
    ".py":      { "exe": "#!/usr/bin/env python", "comment": "#"},
    ".pl":      { "exe": "#!/usr/bin/env perl", "comment": "#"},
    ".go":      { "exe": "", "comment": "//" },
    ".c":       { "exe": "", "comment": "//"},
    ".java":    { "exe": "", "comment": "//"},
    ".sh":      { "exe": "#!/bin/bash", "comment": "#"},
}

header_order = ["name", "version", "date", "author", "desc"]
today = date.today()
comment = ""
date = today.strftime('%Y%m%d')

parser  = argparse.ArgumentParser()
parser.add_argument("-f", "--file", help = "file to create")
args    = parser.parse_args()

headers["name"] = args.file
headers["date"] = date

extension = path.splitext(args.file)[1]
if extension in languages.keys():
    exe_line = languages[extension]["exe"]
    comment = languages[extension]["comment"]

with open(args.file, 'w') as file:
    if len(exe_line):
        file.write("{}\n\n".format(exe_line))
    for item in header_order:
        file.write("{} {:8}:\t{}\n".format(comment, item, headers[item]))

chmod(args.file, 0o0750)
  

