#!/bin/bash

# name: 	update_void.sh
# version:	0.0.1
# date:		20211101
# author:	Leam Hall
# desc:		Package update and clean-up for Void system.

date=`date +%Y%m%d`
logfile="/var/log/xbps/update_${date}.log"

# Removes old kernels.
#vkpurge rm all > $logfile 2>&1

# Updates, and keeps a log.
xbps-install -Suvy >> $logfile 2>&1
if [ $? > 0 ]
then
  echo "ERROR: Package update failed (again)"
  exit 1
fi

# Lets the system quiesce.
sleep 10

# Removes old packages that are no longer needed.
xbps-remove -O >> $logfile 2>&1

# updates the CA certificates
update-ca-certificates >> $logfile 2>&1

# Updates the locate db.
updatedb >> $logfile 2>&1

# Forces a package reconfigure 
xbps-reconfigure -fa

