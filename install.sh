#!/bin/sh

cp -f usbip-connect@.service /etc/systemd/system/

mkdir -p /etc/usbip/
cp usbip-connect.sh /etc/usbip/
cp usbip-disconnect.sh /etc/usbip/

systemctl daemon-reload

