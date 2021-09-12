#!/usr/bin/env python3

# name:     mark_weak_words.py
# version:  0.0.1
# date:     20210519
# author:   Leam Hall
# desc:     Prefix potential weak words, for each searching.

### Notes
#   Assumes, in the directory being run from, that there is a file
#     named 'data/weak_words.txt'. Probably need to make that an argument.


import argparse

def is_weak(word, weaks):
  for w in weaks:
    if word.lower().startswith(w):
      return True
  return False

prefix        = 'ZZZ'
weaks         = []
marked_phrase = []

parser  = argparse.ArgumentParser("Prefix potential weak words, for searching.")
parser.add_argument('-f', '--file', help = 'the file to parse')
args    = parser.parse_args()

with open(args.file, 'r') as _input:
  phrase = _input.read()

with open('data/weak_words.txt') as weak_file:
  for line in weak_file.readlines():
    line = line.strip()
    if len(line) == 0 or line.startswith('#'):
      continue
    weaks.append(line)

for word in phrase.split(' '):
  if is_weak(word, weaks):
    word = prefix + word
  marked_phrase.append(word)

with open(args.file + '.marked', 'w') as _output:
  _output.write(' '.join(marked_phrase))

