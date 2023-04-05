#!/bin/sh

#repo_status.sh

MY_GIT_DIR=`pwd`
for i in `find . -name '.git' -type d`
do
  REPO=`dirname $i`
  cd $REPO
  echo "Working on ${REPO}."
  git status
  cd $MY_GIT_DIR
done

