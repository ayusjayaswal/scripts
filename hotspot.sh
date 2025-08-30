#!/bin/bash

# Defaults
DEFAULT_SSID="Mustang's ap"
DEFAULT_PASS="mustangpassword"

# Detect Wi-Fi interface (ignore p2p devices)
IFACE=$(nmcli -t -f DEVICE,TYPE device | grep ":wifi" | cut -d: -f1 | grep -v "p2p")

if [ -z "$IFACE" ]; then
    notify-send "Hotspot Error" "No Wi-Fi device found!"
    exit 1
fi

# Check if hotspot is already active
if nmcli -t -f NAME,TYPE,DEVICE connection show --active | grep -q "^Hotspot:"; then
    nmcli radio wifi off
    notify-send "Hotspot" "Turned OFF"
    exit 0
fi

# Ask SSID
SSID=$(echo "" | dmenu -p "Enter SSID (default: $DEFAULT_SSID):")
if [ -z "$SSID" ]; then
    SSID="$DEFAULT_SSID"
fi

# Ask Password
PASS=$(echo "" | dmenu -p "Enter password (default: $DEFAULT_PASS):")
if [ -z "$PASS" ]; then
    PASS="$DEFAULT_PASS"
fi

# Ensure Wi-Fi is on
nmcli radio wifi on

# Start hotspot
nmcli dev wifi hotspot ifname "$IFACE" ssid "$SSID" password "$PASS"

notify-send "Hotspot" "Started SSID: $SSID"
