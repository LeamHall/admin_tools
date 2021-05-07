#!/usr/bin/env python3

# name:       find_copies.py
# version:    0.0.1
# date:       20210506
# desc:       Tool to help clean up old versions of files.

from pathlib import Path

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
  
def build_dir_set(dirs):
  '''
  Given a list of full file paths, make a set of the parent directory
    names as strings.
  '''
  dir_set = set()
  for item in dirs:
    path    = Path(item)
    parent  = str(path.parent)  
    dir_set.add(parent)
  return dir_set

def build_clean_set(full_set, exclude_list, match = 'full'):
  '''
  Given a set (or list), and a set/list of items to be excluded,
    return a set of the original set/list minus the excluded items.
  Optionally, match the exclusion on the entire string, or the 
    beginning. If there's a use for it, then endswith, too.
  '''

  exclude_set = set()
  for exclude in exclude_list:
    for item in full_set:
      if ( ( match == 'starts' and item.startswith(exclude) ) or
          ( match == 'full' and item == exclude ) ):
        exclude_set.add(item) 
  return full_set - exclude_set



if __name__ == '__main__':

  master_data = dict()

  # Need to verify if these files exist. 
  exclude_files_file  = 'data/exclude_files.list'
  exclude_dirs_file   = 'data/excluded_dirs.list'
  seed_file_file      = 'data/seed.list'

  exclude_files       = build_set_from_file(exclude_files_file)
  exclude_dirs        = build_set_from_file(exclude_dirs_file)
  seed_files          = build_set_from_file(seed_file_file)
  seed_dirs           = build_dir_set(seed_files)
  search_dirs         = build_clean_set(seed_dirs, exclude_dirs, 'starts')

  print("There are {} files in the exclude set.".format(len(exclude_files)))
  print("There are {} dirs in the exclude set.".format(len(exclude_dirs)))
  print("There are {} dirs in the seed set.".format(len(seed_dirs)))
  for item in sorted(search_dirs):
    print(item)


