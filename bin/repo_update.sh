#!/bin/sh

#repo_update.sh

if [ ! -d ~/tmp ]
then
  mkdir ~/tmp
fi

MY_GIT_DIR=`pwd`
for i in `find . -name '.git' -type d`
do
  REPO=`dirname $i`
  BASE_REPO=`basename ${REPO}`
  cd $REPO
  REPO_DIR=`pwd`
  URL=`grep url .git/config | awk '{ print $3 }'`
  echo "${REPO_DIR}  ${BASE_REPO}  ${URL}." >> ~/tmp/repo_update.$$ 2>&1
  git pull -q >> ~/tmp/repo_update.$$ 2>&1
  cd $MY_GIT_DIR
done

