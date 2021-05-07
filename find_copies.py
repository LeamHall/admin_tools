#!/usr/bin/env python3

# name:       find_copies.py
# version:    0.0.1
# date:       20210506
# desc:       Tool to help clean up old versions of files.

from pathlib import Path
import re

def build_set_from_file(file):
  ''' 
  Given a file that has been verified to exist, make a set
  from the lines in the file.

  '''
  my_set = set()
  if Path(file).is_file():
    readfile = open(file, 'r')
    for line in readfile.readlines():
      line = line.strip()
      my_set.add(line)
  return my_set
   
def build_dir_set(my_list, exclude_dirs):
  my_set  = set()
  for item in my_list:
    path = Path(item)
    parent = str(path.parent)
    my_set.add(parent)
  my_new_set = set()
  for exclude_dir in exclude_dirs:
    for parent in my_set:
      if re.match(exclude_dir, parent):
        my_new_set.add(parent) 
  return my_set - my_new_set

master_data = dict()

exclude_files_file  = 'data/exclude_list.txt'
exclude_dirs_file   = 'data/excluded_dirs.list'
seed_file_file      = 'data/seed.list'
exclude_files       = build_set_from_file(exclude_files_file)
exclude_dirs        = build_set_from_file(exclude_dirs_file)
seed_files          = build_set_from_file(seed_file_file)
seed_dirs           = build_dir_set(seed_files, exclude_dirs)
print("There are {} files in the excluded set.".format(len(exclude_files)))
print("There are {} dirs in the exclude set.".format(len(exclude_dirs)))
print("There are {} dirs in the seed set.".format(len(seed_dirs)))
for item in sorted(seed_dirs):
  print(item)


