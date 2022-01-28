#!/bin/bash
USERNAME=ubnt
#ip address
HOST=""
#the password without quote
PASS=      
SCRIPT1="/usr/etc/rc.d/rc start"
SCRIPT2="/sbin/udhcpc -i ath0 -s /etc/udhcpc/udhcpc -p /var/run/udhcpc.ath0.pid"

echo -e "restarting... it may take a minute"
sshpass -p ${PASS} ssh  ${USERNAME}@${HOST} "${SCRIPT1}"
sleep 5
sshpass -p ${PASS} ssh  ${USERNAME}@${HOST} "${SCRIPT2}" 
echo -e "adding route....."
