# OpenVPN-KillSwitch
Setup OpenVPN (with gui) and killswitch configuration on Ubuntu desktop.
The purpose of this project is to setup secure and private access to the Internet from Ubuntu desktop.

This will describe the following processes:

- Install OpenVPN client and gui on Ubuntu desktop.
- Import and secure .ovpn profile file.
- Setup killswitch feature.

The methods described below are generic and valid for any kind of OpenVPN connection.   
It was tested with CyberGhost and NordVPN on Xubuntu 20.04 desktop (Xfce).

<br />

**Step 1 - Get your .ovpn configuration file from a VPN provider**

Get your .ovpn configuration file from VPN provider. Make sure you have correct credentials. You can see them through provider's web site when you are logged in.
Vpn credentials are not the same like your account login credentials! It's recommended to get tcp .ovpn file and not udp. In most cases, UDP works slow in Ubuntu. Cyberghost are TCP by default. In NordVPN, you can choose between tcp and udp .ovpn file.  
In order to prevent dns leaks, you need to add this line to .ovpn file (if it's not there already):
```
block-outside-dns
```

<br />

**Step 2 - Install OpenVPN. I used Xubuntu 20.04 desktop (Xfce)**
```
sudo apt-get install openvpn  
sudo apt-get install network-manager-openvpn  
sudo apt-get install network-manager-openvpn-gnome
```
- Right-click Network Manager in the System Tray, select Edit Connections  
![Alt text](/images/killswitch-tut-01.jpg?raw=true "Network Manager")
- Click on "Add" (Or a "Plus" button) and then "Import a saved VPN configuration"
![Alt text](/images/killswitch-tut-02.jpg?raw=true "Network Connections")
![Alt text](/images/killswitch-tut-03.jpg?raw=true "Import Connection")
- Choose your .ovpn file. Preferably TCP and not UDP. If your file came with other files (certificates), keep them all in the same folder.
- Most .ovpn TCP files come with port 443. You can check it in .ovpn file (line that starts with a word "remote" contains your VPN connection IP/Url and a port).
- In the vpn details window, make sure your vpn IP (gateway) is IP and not url/dyndns. If it's not provided as IP address, you can find it with "host" command:
```
host ar37.nordvpn.com
ar37.nordvpn.com has address 131.255.4.89
```
In most TCP vpns, port will be 443. Then fill your openvpn user/password.
- In the "advanced" tab, Make sure you tick "use TCP connection". At the end, press save.
![Alt text](/images/killswitch-tut-04.jpg?raw=true "Advanced")
![Alt text](/images/killswitch-tut-05.jpg?raw=true "TCP Connection")
- Go back to network manager and open your wired network properties -> General, and then tick "Automatically connect to vpn" and choose your vpn connection from the list. Press Save.    
![Alt text](/images/killswitch-tut-06.jpg?raw=true "Automatically connect to vpn")  
This will auto connect to vpn every time your local network is connected. Eg. after reboot. This is not the killswitch! If vpn drops, local connection works normally.

<br />

**Step 3 - Configure "killswitch", so only VPN traffic is allowed to reach Internet. If the VPN connection drops = No internet access.**

Make sure you have ufw (Uncomplicated Firewall) installed:
```
sudo apt-get install ufw
```
ufw is firewall, similar to iptables. Set of specific firewall rules will make sure "killswitch" is enforced.
Basically, you block all Internet access for your local connection (except access to VPN server(s) on port 443). And allow only VPN (tun0) connection to reach Internet.
Edit the script ["openvpn-killswitch-ufw.sh"](openvpn-killswitch-ufw.sh) according to your needs. The script is self explanatory and contains all neccesary comments.  
First time run it manually. Don't forget to "chmod"
```
chmod +x openvpn-killswitch-ufw.sh
./openvpn-killswitch-ufw.sh
```

Add entry to crontab so rules will be loaded on boot:
```
@reboot root /home/user/openvpn-killswitch-ufw.sh
```

<br />

*Useful ufw commands:*

Run this command to see the active ufw rules:
```
sudo ufw status verbose
```

Reset the ufw config (remove all rules):
```
sudo ufw --force reset
```

Service restart (will remove all rules):
```
sudo service ufw restart
```

<br />

*Useful tip:*  
Install this Firefox (and Chrome) addon to see your public IP (and flag) on browser toolbar:  
https://addons.mozilla.org/en-US/firefox/addon/public-ip-display/

<br />

*Useful links:*

Dns leak test - You must check it after you finish configuring your VPN connection:  
https://www.dnsleaktest.com  
https://dnsleak.com  

WebRTC leak test:  
https://browserleaks.com/webrtc  
https://www.expressvpn.com/webrtc-leak-test  


