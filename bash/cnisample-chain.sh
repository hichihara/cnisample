#!/usr/bin/env bash

count=1

if [ -p /dev/stdin ]; then
    buf=$(cat -)
    previnterface=$(echo $buf | jq -r '.prevResult.interfaces[].name')
    previps=$(echo $buf | jq -r '.prevResult.ips[]')
    count=$((++count))
    interfaces='{"name":"'$previnterface'"},{"name":"sample-interface'$count'"}'
    ips=''$previps',{"version":"4","address":"10.0.0.'$count'/32","interface":'$count'}'
fi

if [ "$CNI_COMMAND" == "ADD" ]; then
    echo '{"cniVersion":"0.4.0","interfaces":['$interfaces'],"ips":['$ips'],"dns":{}}'
fi

if [ "$CNI_COMMAND" == "DEL" ]; then
    echo '{}'
fi

if [ "$CNI_COMMAND" == "VERSION" ]; then
    echo '{"cniVersion": "0.4.0", "supportedVersions": [ "0.1.0", "0.2.0", "0.3.0", "0.3.1", "0.4.0" ]}'
fi

if [ "$CNI_COMMAND" == "GET" ]; then
    echo '{"cniVersion":"0.4.0","interfaces":['$interfaces'],"ips":['$ips'],"dns":{}}'
fi
