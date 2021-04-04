#!/bin/sh

# This is only useful for RHEL/CentOS based systems.
touch /forcefsck

# Need to make this more generic.
find /home/leam/.cache -type f -exec rm {} \;
find /home/ansible/.cache -type f -exec rm {} \;

# Need to make this a config file item.
rsync -av /home/  /opt/backup/home

# Externals need a config option.
if [ ! -d /opt/external/home ]
then
  mount /opt/external
fi

if [ -d /opt/external/home ]
then
  rsync -av /home/  /opt/external/home
fi


