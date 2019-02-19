#!/usr/bin/env bash

ns_name=$(basename $CNI_NETNS)
veth1="veth1"
veth2="veth2"

interfaces='{"name":"'$veth1'"}, {"name":"'$CNI_IFNAME'"}'
ips='{"version":"4","address":"172.16.29.2/24","interface":1}'

if [ "$CNI_COMMAND" == "ADD" ]; then
    ip link add name $veth1 type veth peer name $veth2
    ip link set $veth2 netns $ns_name
    ip addr add 172.16.29.1/32 dev $veth1
    ip link set $veth1 up
    ip -n $ns_name link set $veth2 name $CNI_IFNAME
    ip -n $ns_name addr add 172.16.29.2/24 dev $CNI_IFNAME
    ip -n $ns_name link set $CNI_IFNAME up
    ip r add 172.16.29.2 dev veth1
    ip -n $ns_name r add default via 172.16.29.1
    echo '{"cniVersion":"0.4.0","interfaces":['$interfaces'],"ips":['$ips'],"dns":{}}'
fi

if [ "$CNI_COMMAND" == "DEL" ]; then
    ip -n $ns_name r del default via 172.16.29.1
    ip r del 172.16.29.2 dev veth1
    sudo ip -n $ns_name link del $CNI_IFNAME
    echo '{}'
fi

if [ "$CNI_COMMAND" == "VERSION" ]; then
    echo '{"cniVersion": "0.4.0", "supportedVersions": [ "0.1.0", "0.2.0", "0.3.0", "0.3.1", "0.4.0" ]}'
fi

if [ "$CNI_COMMAND" == "CHECK" ]; then
    echo '{"cniVersion":"0.4.0","interfaces":['$interfaces'],"ips":['$ips'],"dns":{}}'
fi
