#/bin/bash
sudo wpa_supplicant -i wlp1s0 -c /etc/wpa_supplicant/wpa_supplicant.conf -D nl80211 -B
sudo dhclient wlp1s0
