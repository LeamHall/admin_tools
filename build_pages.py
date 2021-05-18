#!/usr/bin/env python3

# name:     build_pages.py
# version:  0.0.1
# date:     20210515
# author:   Leam Hall
# desc:     Build web pages from components.

## Notes

# Assumes a directory structure
#
#   base_pages/
#     index
#     privacy_policy
#
#   docs/
#     library_data
#
#   parts/
#     html_header
#     css
#     footer
#     page_close

# Builds pages like
#
#   docs/index.html
#   docs/privacy_policy.html
#   docs/library_data/guide.html

###  Main

import os
import sys

# Github pages can use 'docs/' as a document root.
# This lets us keep the parts and base pages in the repo, but not seen.
docs_dir  = 'docs/'
if not os.path.isdir(docs_dir):
  os.makedirs(docs_dir)

# Where the different web page parts are kept.
parts_dir = 'parts'
if not os.path.isdir(parts_dir):
  sys.exit("Could not find {}.".format(parts_dir))

parts     = dict()
for part in [ 'html_header', 'css', 'page_header', 'footer', 'page_close' ]:
  with open(parts_dir + '/' + part) as f:
    parts[part] = f.read()


def write_file(filename, output_dir = ''):
  with open('base_pages/' + output_dir + filename) as i:
    input_page = i.read()
  with open( docs_dir + output_dir + filename + '.html', 'w') as output_page:
    output_page.write(parts['html_header'])
    output_page.write(parts['css'])
    output_page.write(parts['page_header'])
    output_page.write(input_page)
    output_page.write(parts['footer'])
    output_page.write(parts['page_close'])
    

named_dirs = dict()

for root,dirs,files in os.walk('base_pages/'):
  short_root = root[len('base_pages/'):]
  for name in files:
    print(name)
    if name.endswith('.swp'):
      continue
    if len(short_root) == 0: 
      write_file(name)
    else:
      if not os.path.isdir(docs_dir + short_root):
        os.makedirs(docs_dir + short_root)
      short_root += '/'
      write_file(name, short_root)

