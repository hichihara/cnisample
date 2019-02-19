#!/usr/bin/env bash

if [ -p /dev/stdin ]; then
    buf=$(cat -)
    ip=$(echo $buf | jq -r '.prevResult.ips[].address')
fi

interfaces='{"name":"veth1"},{"name":"eth0"}'
ips='{"version":"4","interface":1,"address":"172.16.29.2/24"}'

if [ "$CNI_COMMAND" == "ADD" ]; then
    iptables -t nat -N test
    iptables -t nat -A test -d $ip -j ACCEPT
    iptables -t nat -A test ! -d 224.0.0.0/4 -j MASQUERADE
    iptables -t nat -I POSTROUTING -s $ip -j test
    echo '{"cniVersion":"0.4.0","interfaces":['$interfaces'],"ips":['$ips'],"dns":{}}'
fi

if [ "$CNI_COMMAND" == "DEL" ]; then
    iptables -t nat -D POSTROUTING -s $ip -j test
    iptables -t nat -D test ! -d 224.0.0.0/4 -j MASQUERADE
    iptables -t nat -D test -d $ip -j ACCEPT
    iptables -t nat -X test
    echo '{}'
fi

if [ "$CNI_COMMAND" == "VERSION" ]; then
    echo '{"cniVersion": "0.4.0", "supportedVersions": [ "0.1.0", "0.2.0", "0.3.0", "0.3.1", "0.4.0" ]}'
fi

if [ "$CNI_COMMAND" == "CHECK" ]; then
    echo '{"cniVersion":"0.4.0","interfaces":['$interfaces'],"ips":['$ips'],"dns":{}}'
fi
