#!/bin/bash

# name:     make_new_language.sh
# alt:      install_language.sh
# version:  0.2.1
# date:     20201211
# author:   Leam Hall
# desc:     Semi-automate various language builds.

# Example:
#   cd <parent dir of git repo>
#   make_new_language.sh ruby
#
# If the build works, then as root:
#   cd <parent dir of git repo>
#   install_language.sh ruby
#

## CHANGELOG
# 20201211  Added Perl

PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

language=$@
if [ -d "$language" ]
then
  cd $language
else
  echo "Can't find $language."
  exit
fi

language_base=`echo $language | awk -F'-' '{print $1}'`
date=`date +%Y%m%d`
minute=`date +%H%M`
scriptname=`basename $0`
self=`whoami`

# Soft link make_new_language.sh to install_language.sh and
#  run it as root to do the actual install.
if [ "$self" == 'root' -a "$scriptname" == 'install_language.sh' ]
then
  make install > ../logs/${language}_make_install_${date}_${minute}.log 2>&1 

  if [ "$language" == "ruby" ]
  then
    gem update  > ../logs/${language}_gem_update_${date}_${minute}.log 2>&1
    gem cleanup > ../logs/${language}_gem_cleanup_${date}_${minute}.log 2>&1
  fi

  exit
fi

make clean > ../logs/${language}_make_clean_${date}_${minute}.log 2>&1

## Commented out for the nonce, what if a new branch is needed, or it's a fork?
#if [ -f ".git/config" ]
#then
#  git pull > ../logs/${language}_git_pull_${date}_${minute}.log 2>&1
#fi


if [ "$language_base" == "autoconf" ]
then
    ./configure > ../logs/${language}_configure_${date}_${minute}.log 2>&1
    make > ../logs/${language}_make_${date}_${minute}.log 2>&1
    make check > ../logs/${language}_make_check_${date}_${minute}.log 2>&1
    make installcheck > ../logs/${language}_make_installcheck_${date}_${minute}.log 2>&1
elif [ "$language_base" == "php" ]
then
    ./configure > ../logs/${language}_configure_${date}_${minute}.log 2>&1
    make > ../logs/${language}_make_${date}_${minute}.log 2>&1
    make test > ../logs/${language}_make_test_${date}_${minute}.log 2>&1
elif [ "$language_base" == "ruby" ]
then
    if [ ! -f "tool/config.sub" ]
    then
        autoconf > ../logs/${language}_autoconf_${date}_${minute}.log 2>&1
    fi
    ./configure > ../logs/${language}_configure_${date}_${minute}.log 2>&1
    make > ../logs/${language}_make_${date}_${minute}.log 2>&1
    make check > ../logs/${language}_make_check_${date}_${minute}.log 2>&1
    make update-gems > ../logs/${language}_make_update-gems_${date}_${minute}.log 2>&1
    make extract-gems > ../logs/${language}_make_extract-gems_${date}_${minute}.log 2>&1
elif [ "$language_base" == "perl" ]
then
  # need to combine this with php above.
    ./Configure -des -Dprefix=/usr/local > ../logs/${language}_configure_${date}_${minute}.log 2>&1
    make > ../logs/${language}_make_${date}_${minute}.log 2>&1
    make test > ../logs/${language}_make_test_${date}_${minute}.log 2>&1
elif [ "$language" == "cpython" ]
then
    make clean > ../logs/${language}_make_clean_${date}_${minute}.log 2>&1
    ./configure --with-pydebug > ../logs/${language}_configure_with_pydebug_${date}_${minute}.log 2>&1
    make -s > ../logs/${langauge}_make_s_${date}_${minute}.log 2>&1
    make regen-global-objects > ../logs/${langauge}_make_regen_global_objects_${date}_${minute}.log 2>&1
    ./python -m test > ../logs/${langauge}_python_m_test_${date}_${minute}.log 2>&1
    make patchcheck > ../logs/${langauge}_make_patchcheck_${date}_${minute}.log 2>&1
fi
