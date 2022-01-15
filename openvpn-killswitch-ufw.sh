#!/bin/bash

# Reset the existing ufw config
ufw --force reset

# Default policies
ufw default deny incoming
ufw default deny outgoing

# Openvpn interface (adjust interface accordingly to your configuration). In most cases your OpenVPN inteface will be tun0
ufw allow in on tun0
ufw allow out on tun0

# Local Network (adjust ip accordingly to your configuration)
ufw allow in on eth0 from 192.168.109.0/24
ufw allow out on eth0 to 192.168.109.0/24

# ALLOW OPENVPN SERVER(S) - You can see the IP and the port in the .ovpn file.
# Some sample lines:
ufw allow out on eth0 to 37.9.51.151 port 443
ufw allow out on eth0 to 45.137.179.0/24 port 443

# Openvpn (adjust port accordingly to your configuration)
# You can enhance your security by not enabling this incoming traffic rule. I chose to enable it.
ufw allow in on eth0 from any port 443

# DNS - I chose not to allow any DNS related traffic for local network. You may want to enable those rules.
# ufw allow in from any to any port 53
# ufw allow out from any to any port 53

# Enable the firewall
ufw --force enable  



