#!/bin/bash

# Configuration
WAN_IP="192.168.1.1"
PING_COUNT=4
USERNAME="xxx"
HOST="192.168.2.254"
PASSWORD="xxx"
LOG_FILE="/var/log/ping_failure.log"

# Remote commands
SCRIPT1="/usr/etc/rc.d/rc start"
SCRIPT2="/sbin/udhcpc -i ath0 -s /etc/udhcpc/udhcpc -p /var/run/udhcpc.ath0.pid"

# Function to execute a remote command via SSH
execute_ssh_command() {
    local command=$1
    sshpass -p "${PASSWORD}" ssh -o StrictHostKeyChecking=no "${USERNAME}@${HOST}" "${command}"
}

# Check connectivity by pinging the WAN IP
if ! ping -c "${PING_COUNT}" "${WAN_IP}" > /dev/null 2>&1; then
    echo "Ping to ${WAN_IP} failed. Executing recovery commands..."
    echo -e "Restarting DHCP... This may take a minute."

    # Step 1: Restart interface + DHCP
    execute_ssh_command "${SCRIPT1}"
    sleep 5
    execute_ssh_command "${SCRIPT2}"
    sleep 3

    # Step 2: Get new IP from ath0
    echo "Checking new IP from ath0..."
    NEW_IP=$(execute_ssh_command "ifconfig ath0 | sed -n 's/.*inet addr:\\([0-9\\.]*\\).*/\\1/p'")

    if [[ -n "${NEW_IP}" ]]; then
        echo "Acquired new IP: ${NEW_IP}"

        # Step 3: Apply dynamic firewall rule
        echo "Applying firewall drop rule..."
        execute_ssh_command "iptables -A FIREWALL -s 192.168.1.0/24 -d ${NEW_IP} -p icmp -j DROP"
        execute_ssh_command "iptables -A FIREWALL -s 192.168.1.0/24 -d ${NEW_IP} -j DROP"

        echo "Firewall rules applied to block incoming access from LAN."
    else
        echo "Failed to obtain IP from ath0."
    fi

    echo "$(date): Ping to ${WAN_IP} failed, IP=${NEW_IP}" >> "${LOG_FILE}"
else
    echo "Ping to ${WAN_IP} was successful."
fi
