#!/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin

HOSTNAME=$1

get_id_list() {
    echo $(usbip list -r "$HOSTNAME" 2>/dev/null | \
        grep -oP '^[[:blank:]]+[[:digit:]]+-.*?:' | \
        awk -F' ' '{print $1}' | cut -d':' -f 1)
}

delete_old_port() {
    # don't assign id will remove all ports under HOSTNAME
    local id=$1

    old_ports=$(usbip port | grep -B2 "\-> usbip://${HOSTNAME}:3240/$id" | \
        grep '^Port' | cut -d' ' -f 2 | cut -d':' -f1)
    for port in $old_ports; do
        usbip detach -p "$port" 2>&1 > /dev/null
    done
}

clean_invalid_port() {
    ping -W 5 -c 1 "$HOSTNAME" 2>&1 > /dev/null && return
    delete_old_port
}

add_new_port() {
    local id_list=$1

    for id in $id_list; do
        delete_old_port $id
        usbip attach -r "$HOSTNAME" -b $id 2>/dev/null
    done
}

main() {
    while :; do
        local id_list=$(get_id_list)
        if [ -z "$id_list" ]; then
            clean_invalid_port
        else
            add_new_port $id_list
        fi

        sleep 2
    done
}

main

