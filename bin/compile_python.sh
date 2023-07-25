#!/bin/bash

# name:     compile_python.sh
# version:  0.0.1
# date:     20230722
# author:   Leam Hall
# desc:     Semi-automate CPython language builds.

# Example:
#   ?cd <parent dir of git repo>
#   compile_python.sh 
#

## CHANGELOG

PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

base_dir='/usr/local/src/forks/'
language='cpython'
full_dir="${base_dir}${language}"
date=`date +%Y%m%d`
minute=`date +%H%M`
timestamp="${date}_${minute}"
scriptname=`basename $0`
self=`whoami`

if [ ! -d "${full_dir}" ]
then
    echo "Can't find ${full_dir}"
    exit
fi

cd $full_dir

if [ ! -d '.git' ]
then
    echo "${full_dir} is not a git repo"
    exit
fi

# Soft link make_new_language.sh to install_language.sh and
#  run it as root to do the actual install.
if [ "$self" == 'root' -a "$scriptname" == 'install_python.sh' ]
then
    make install > ../logs/${language}_make_install_${timestamp}.log 2>&1 
    exit
fi

# Main build section
git pull > ../logs/${language}_git_pull_${timestamp}.log 2>&1 

# Change test_zipfile64.py to enable the full test.
enable_test_zipfile64.py $full_dir

make clean > ../logs/${language}_make_clean_${timestamp}.log 2>&1
make regen-configure > ../logs/${language}_regen-configure_${timestamp}.log 2>&1
./configure --with-pydebug > ../logs/${language}_configure_${timestamp}.log 2>&1
make -j > ../logs/${language}_make_j_${timestamp}.log 2>&1
make regen-global-objects > ../logs/${language}_make_regen_global_objects_${timestamp}.log 2>&1
./python -m test -uall -j0 > ../logs/${language}_python_m_test_${timestamp}.log 2>&1
make patchcheck > ../logs/${language}_make_patchcheck_${timestamp}.log 2>&1
