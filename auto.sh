#!/bin/bash

wanIp="192.168.1.1"
COUNT=4

# Ping the IP address
ping -c $COUNT $wanIp > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo "Ping to $wanIp failed. Executing the command..."
	USERNAME=ubnt
	#ip address
	HOST="192.168.2.254"
	#the password without quote
	PASS=supardi
	SCRIPT1="/usr/etc/rc.d/rc start"
	SCRIPT2="/sbin/udhcpc -i ath0 -s /etc/udhcpc/udhcpc -p /var/run/udhcpc.ath0.pid"

	echo -e "restarting... it may take a minute"
sshpass -p ${PASS} ssh  ${USERNAME}@${HOST} "${SCRIPT1}"
	sleep 5
sshpass -p ${PASS} ssh  ${USERNAME}@${HOST} "${SCRIPT2}" 
	echo -e "adding route....."
   echo "$(date): Ping to $wanIp failed" >> /var/log/ping_failure.log
else
    echo "Ping to $wanIp was successful."
fi
