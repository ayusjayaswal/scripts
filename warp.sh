#!/bin/sh
choice=$(echo -e "status\nconnect\ndisconnect\ninfo" | dmenu -i -c -p "WARP" -l 4)
case "$choice" in
    "status")
        notify-send "warp status" "$(warp-cli status)"
        ;;
    "connect")
        warp-cli connect
        notify-send "warp" "connected to cloudflare warp"
        ;;
    "disconnect")
        warp-cli disconnect
        notify-send "warp" "disconnected from cloudflare warp"
        ;;
    "info")
        response=$(curl -s https://www.cloudflare.com/cdn-cgi/trace)
        ip=$(echo "$response" | grep "^ip=" | cut -d= -f2)
        location=$(echo "$response" | grep "^loc=" | cut -d= -f2)
        data_center=$(echo "$response" | grep "^colo=" | cut -d= -f2)
        warp_status=$(echo "$response" | grep "^warp=" | cut -d= -f2)
        tls_version=$(echo "$response" | grep "^tls=" | cut -d= -f2)
        http_version=$(echo "$response" | grep "^http=" | cut -d= -f2)
        message="🌍 ip: $ip\n📍 location: $location\n🏢 data center: $data_center\n🔗 warp: $warp_status\n🔒 tls: $tls_version\n🌐 http: $http_version"
        notify-send "warp connection info" "$message"
        ;;
    *)
        notify-send "warp" "no valid option selected."
        ;;
esac
