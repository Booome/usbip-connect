#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin

HOSTNAME=$1

process_id=$(ps -aux | grep 'usbip-connect.sh' | grep "$HOSTNAME" | grep -v 'grep' | awk -F' ' '{print $2}')
[ -z "$process_id" ] || kill $process_id

ports=$(usbip port | grep -B2 "\-> usbip://${HOSTNAME}:3240/" | \
    grep '^Port' | cut -d' ' -f 2 | cut -d':' -f1)
echo $ports
for port in $ports; do
    usbip detach -p "$port" 2>&1 > /dev/null
done

