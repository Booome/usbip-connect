#!/bin/sh

systemctl -q stop usbip-connect.service
systemctl -q disable usbip-connect.service
rm -f /etc/systemd/system/usbip-connect.service

rm -f /etc/usbip/usbip-connect.sh
rm -f /etc/usbip/usbip-disconnect.sh

