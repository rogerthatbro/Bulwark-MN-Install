#!/bin/bash
clear

STRING1="Make sure you double check before hitting enter! Only one shot at these!"
STRING2="If you found this helpful, please donate to BWK Donation: "
STRING3="bCkL87UvfwqphwCdWgyShFYz54hgPVJAg3"
STRING4="Updating system and installing required packages."
STRING5="Switching to Aptitude"
STRING6="Some optional installs"
STRING7="Starting your masternode"
STRING8="Now, you need to finally start your masternode in the following order:"
STRING9="Go to your windows wallet and from the Control wallet debug console please enter"
STRING10="startmasternode alias false <mymnalias>"
STRING11="where <mymnalias> is the name of your masternode alias (without brackets)"
STRING12="once completed please return to VPS and press the space bar"
STRING13=""
STRING14="Please Wait a minimum of 15 minutes before proceeding, the node wallet must be synced"

echo $STRING1

read -e -p "Server IP Address : " ip
read -e -p "Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " key
read -e -p "Install Fail2ban? [Y/n] : " install_fail2ban
read -e -p "Install UFW and configure ports? [Y/n] : " UFW

clear
echo $STRING2
echo $STRING13
echo $STRING3
echo $STRING13
echo $STRING4
sleep 10

# update package and upgrade Ubuntu
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
sudo add-apt-repository ppa:bitcoin/bitcoin
sudo apt-get -y install build-essential libtool autotools-dev autoconf automake libssl-dev libboost-all-dev software-properties-common libdb4.8-dev libdb4.8++-dev libminiupnpc-dev libqt4-dev libprotobuf-dev protobuf-compiler libqrencode-dev git pkg-config libzmq3-dev wget nano htop
clear
echo $STRING5
sudo apt-get -y install aptitude

#Generating Random Passwords
password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
password2=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

echo $STRING6
if [[ ("$install_fail2ban" == "y" || "$install_fail2ban" == "Y" || "$install_fail2ban" == "") ]]; then
  cd ~
  sudo aptitude -y install fail2ban
  sudo service fail2ban restart
fi
if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
  sudo apt-get install ufw
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow ssh
  sudo ufw allow 52543/tcp
  sudo ufw enable -y
fi

#Install Bulwark Daemon
wget https://github.com/bulwark-crypto/Bulwark/releases/download/1.2.1.0/bulwark-1.2.1.0-x86_64-ubuntu17.10-gnu.gz
sudo tar -xzvf bulwark-1.2.1.0-x86_64-ubuntu17.10-gnu.gz
sudo rm bulwark-1.2.1.0-x86_64-ubuntu17.10-gnu.gz
sudo cp ~/bulwark-1.2.1/bin/bulwarkd /usr/bin
sudo cp ~/bulwark-1.2.1/bin/bulwark-cli /usr/bin
sudo cp ~/Bulwark-MN-Install/bulwark-1.2.1/bin/bulwarkd /usr/bin
sudo cp ~/Bulwark-MN-Install/bulwark-1.2.1/bin/bulwark-cli /usr/bin
bulwarkd -daemon
clear

#Setting up coin
clear
echo $STRING2
echo $STRING13
echo $STRING3
echo $STRING13
echo $STRING4
sleep 10

#Create bulwark.conf
echo '
rpcuser='$password'
rpcpassword='$password2'
rpcallowip=127.0.0.1
listen=1
server=1
daemon=1
logtimestamps=1
maxconnections=256
externalip='$ip'
bind='$ip':52543
masternodeaddr='$ip'
masternodeprivkey='$key'
masternode=1
addnode=45.76.211.75:52543
addnode=104.238.156.40:52543
addnode=209.250.228.76:52543
addnode=45.63.49.239:52543
addnode=45.32.178.119:52543
addnode=104.207.150.72:52543
addnode=80.209.238.34:52543
addnode=45.79.152.153:52543
addnode=45.77.252.23:52543
addnode=52.55.238.125:52543
addnode=207.148.20.225:52543
addnode=172.104.74.77:52543
addnode=212.24.111.220:52543
addnode=54.172.15.201:52543
addnode=207.246.119.12:52543
addnode=104.156.245.208:52543
' | sudo -E tee ~/.bulwark/bulwark.conf >/dev/null 2>&1
sudo chmod 0600 ~/.bulwark/bulwark.conf

#Starting coin
(
  crontab -l 2>/dev/null
  echo '@reboot sleep 30 && bulwarkd -daemon -shrinkdebugfile'
) | crontab
(
  crontab -l 2>/dev/null
  echo '@reboot sleep 60 && bulwark-cli startmasternode local false'
) | crontab
bulwarkd -daemon

clear
echo $STRING2
echo $STRING13
echo $STRING3
echo $STRING13
echo $STRING4
sleep 10
echo $STRING7
echo $STRING13
echo $STRING8
echo $STRING13
echo $STRING9
echo $STRING13
echo $STRING10
echo $STRING13
echo $STRING11
echo $STRING13
echo $STRING12
echo $STRING14
sleep 15m

read -p "Press any key to continue... " -n1 -s
bulwark-cli startmasternode local false
bulwark-cli masternode status
