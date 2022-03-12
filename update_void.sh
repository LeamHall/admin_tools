#!/bin/bash

# name: 	  update_void.sh
# version:	0.0.2
# date:		  20220130
# author:	  Leam Hall
# desc:		  Package update and clean-up for Void system.

# CHANGELOG:
#   20220130  Added, and fixed, the test for xbps-install failure.


date=`date +%Y%m%d`
logfile="/var/log/xbps/update_${date}.log"

# Removes old kernels.
#vkpurge rm all > $logfile 2>&1

# Updates, and keeps a log. Whines on failure.
xbps-install -Suvy >> $logfile 2>&1
if [ "$?" -ne 0 ]
then
  echo "ERROR: Package update failed"
  exit 1
fi

# Lets the system quiesce.
sleep 5

# Removes old packages that are no longer needed.
xbps-remove -O >> $logfile 2>&1

# updates the CA certificates
update-ca-certificates >> $logfile 2>&1

# Updates the locate db.
updatedb >> $logfile 2>&1

# Forces a package reconfigure 
xbps-reconfigure -fa >> $logfile 2>&1

# Check log for issues
echo "Checking log"
egrep -i "^warning|^error|^fail" $logfile
echo "Done"
