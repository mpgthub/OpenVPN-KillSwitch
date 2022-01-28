#!/bin/bash
#
# If you already have existing iptables rules, you might want to backup them first. You can do that with "iptables-save" command.

# Flush/remove all existing rules and set a default DROP policy
iptables --flush
iptables --delete-chain
iptables -t nat --flush
iptables -t nat --delete-chain
iptables -P OUTPUT DROP

# Allow loopback traffic
iptables -A INPUT -j ACCEPT -i lo
iptables -A OUTPUT -j ACCEPT -o lo

# Allow local network traffic (adjust ip accordingly to your configuration). My local network adapter is named "eth0"
iptables -A INPUT --src 192.168.109.0/24 -j ACCEPT -i eth0
iptables -A OUTPUT -d 192.168.109.0/24 -j ACCEPT -o eth0

# DNS - I chose not to allow any DNS related traffic for local network. You may want to enable those rules.
# iptables -A OUTPUT -p udp -m udp --dport 53 -j ACCEPT

# ALLOW OPENVPN SERVER(S) - You can see the IP and the port in the .ovpn file.
# Some sample lines:
iptables -A OUTPUT -j ACCEPT -d 37.9.51.151 -o eth0 -p tcp -m tcp --dport 443
iptables -A INPUT -j ACCEPT -s 37.9.51.151 -i eth0 -p tcp -m tcp --sport 443
iptables -A OUTPUT -j ACCEPT -d 45.137.179.0/24 -o eth0 -p tcp -m tcp --dport 443
iptables -A INPUT -j ACCEPT -s 45.137.179.0/24 -i eth0 -p tcp -m tcp --sport 443
# UDP samples with port 1194:
iptables -A OUTPUT -j ACCEPT -d 37.9.51.159 -o eth0 -p udp -m udp --dport 1194
iptables -A INPUT -j ACCEPT -s 37.9.51.159 -i eth0 -p udp -m udp --sport 1194

# Allow all traffic for OpenVPN connection (tun0)
iptables -A INPUT -j ACCEPT -i tun0
iptables -A OUTPUT -j ACCEPT -o tun0


