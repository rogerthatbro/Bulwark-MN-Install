#!/bin/bash
clear
# declare STRING variable
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

#print variable on a screen
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
    sudo apt-get install wget nano htop -y
    sudo apt-get install build-essential && sudo apt-get install libtool autotools-dev autoconf automake && sudo apt-get install libssl-dev && sudo apt-get install libboost-all-dev && sudo apt install software-properties-common && sudo add-apt-repository ppa:bitcoin/bitcoin && sudo apt update && sudo apt-get install libdb4.8-dev && sudo apt-get install libdb4.8++-dev && sudo apt-get install libminiupnpc-dev && sudo apt-get install libqt4-dev libprotobuf-dev protobuf-compiler && sudo apt-get install libqrencode-dev && sudo apt-get install -y git && sudo apt-get install pkg-config
    clear
echo $STRING5
    sudo apt-get -y install aptitude

#Generating Random Passwords
    password=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    password2=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`

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
    wget https://github.com/bulwark-crypto/Bulwark/releases/download/1.2.1.0/Bulwark121.tgz
    sudo tar -xzvf Bulwark121.tgz
    sudo rm Bulwark121.tgz
    sudo cp bulwarkd /usr/bin
    sudo cp bulwark-cli /usr/bin
    sudo cp ~/Bulwark-MN-Install/bulwark-1.2.0/bin/bulwarkd /usr/bin
    sudo cp ~/Bulwark-MN-Install/bulwark-1.2.0/bin/bulwark-cli /usr/bin
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
addnode=213.32.23.65:52543
addnode=199.247.7.119:52543
addnode=185.223.30.31:52543
addnode=80.209.229.92:52543
addnode=45.33.58.91:52543
addnode=46.101.131.50:52543
addnode=159.203.123.44:52543
addnode=209.250.232.68:42870
addnode=199.247.4.86:39654
addnode=109.101.221.204:57374
addnode=46.149.120.21:53380
addnode=86.149.228.161:54055
addnode=45.77.138.177:52543
addnode=207.148.1.60:52543
addnode=114.94.190.239:54954
addnode=45.63.49.239:38716
addnode=80.122.43.78:52543
addnode=45.32.221.80:52543
addnode=108.61.188.251:52543
addnode=73.73.160.113:51356
addnode=134.255.252.218:55912
addnode=104.238.157.205:52543
addnode=45.76.118.238:52543
addnode=47.88.220.108:52543
addnode=104.156.225.96:52543
' | sudo -E tee ~/.bulwark/bulwark.conf >/dev/null 2>&1
    sudo chmod 0600 ~/.bulwark/bulwark.conf

#Starting coin
    (crontab -l 2>/dev/null; echo '@reboot sleep 30 && bulwarkd -daemon -shrinkdebugfile') | crontab
    (crontab -l 2>/dev/null; echo '@reboot sleep 60 && bulwark-cli startmasternode local false') | crontab
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
    sleep 120
    
    read -p "Press any key to continue... " -n1 -s
    bulwark-cli startmasternode local false
    bulwark-cli masternode status
