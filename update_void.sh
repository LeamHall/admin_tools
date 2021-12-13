#!/bin/bash

# name: 	update_void.sh
# version:	0.0.1
# date:		20211101
# author:	Leam Hall
# desc:		Package update and clean-up for Void system.

# Removes old kernels.
vkpurge rm all

# Updates, and keeps a log.
xbps-install -Suvy > /var/tmp/xbps-install_Suvy_`date +%Y%m%d`.log 2>&1

# Lets the system quiesce.
sleep 10

# Removes old packages that are no longer needed.
xbps-remove -O

# updates the CA certificates
update-ca-certificates

# Updates the locate db.
updatedb


