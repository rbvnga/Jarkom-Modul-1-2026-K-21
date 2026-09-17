#!/bin/bash

# --- IP Forwarding & NAT ---
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# --- DNS Resolver ---
echo "nameserver 8.8.8.8" > /etc/resolv.conf

# --- Static IP untuk eth1, eth2, eth3 (jaga-jaga kalau /etc/network/interfaces ter-reset) ---
ip addr add 10.74.1.1/24 dev eth1 2>/dev/null
ip link set eth1 up

ip addr add 10.74.2.1/24 dev eth2 2>/dev/null
ip link set eth2 up

ip addr add 10.74.3.1/24 dev eth3 2>/dev/null
ip link set eth3 up

echo "Setup Router selesai."