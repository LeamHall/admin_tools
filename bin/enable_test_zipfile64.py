#!/usr/bin/env python

# name    :  enable_test_zipfile64.py
# version :  0.0.1
# date    :  20230725
# author  :  Leam Hall
# desc    :  Edits test_zipfile64.py to enable the test. 


import os
from shutil import copyfile
import sys

if len(sys.argv) != 2:
    print("I need one directory to work on.")
    sys.exit()

working_dir = sys.argv[1]
file = os.path.join(working_dir, "Lib", "test", "test_zipfile64.py")
found_resource = False

try:
    copyfile(file, file + '.orig')
    with open(file, 'r') as in_f:
        lines = in_f.readlines()
except Exception as e:
    print("Can't access ", file, "  ", e)
    sys.exit

new_lines = []

for line in lines:
    if line.startswith('support.requires'):
        found_resource = True
    elif found_resource and ')' in line:
        found_resource = False
    elif not found_resource:
        new_lines.append(line)
    
       
with open(file, 'w') as out_f: 
    for line in new_lines:
        out_f.write(line)

