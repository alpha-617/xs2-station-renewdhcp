#!/bin/bash

# Configuration
WAN_IP="192.168.1.1"
PING_COUNT=4
USERNAME="ubnt"
HOST="192.168.2.254"
PASSWORD="" # Plain text password; consider using more secure methods for sensitive data.
SCRIPT1="/usr/etc/rc.d/rc start"
SCRIPT2="/sbin/udhcpc -i ath0 -s /etc/udhcpc/udhcpc -p /var/run/udhcpc.ath0.pid"
LOG_FILE="/var/log/ping_failure.log"

# Function to execute a remote command via SSH
execute_ssh_command() {
    local command=$1
    sshpass -p "${PASSWORD}" ssh "${USERNAME}@${HOST}" "${command}"
}

# Check connectivity by pinging the WAN IP
if ! ping -c "${PING_COUNT}" "${WAN_IP}" > /dev/null 2>&1; then
    echo "Ping to ${WAN_IP} failed. Executing recovery commands..."
    echo -e "Restarting... This may take a minute."

    # Execute remote commands
    execute_ssh_command "${SCRIPT1}"
    sleep 5
    execute_ssh_command "${SCRIPT2}"

    echo -e "Adding route..."
    echo "$(date): Ping to ${WAN_IP} failed" >> "${LOG_FILE}"
else
    echo "Ping to ${WAN_IP} was successful."
fi
