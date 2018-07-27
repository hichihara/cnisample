#!/usr/bin/env bash

count=1
interfaces='{"name":"sample-interface'$count'"}'
ips='{"version":"4","address":"10.0.0.'$count'/32","interface":'$count'}'

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
