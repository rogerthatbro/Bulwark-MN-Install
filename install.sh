#!/bin/bash
clear

# Set these to change the version of Bulwark to install
TARBALLURL="https://github.com/bulwark-crypto/Bulwark/releases/download/1.2.3/bulwark-1.2.3.0-linux64.tar.gz"
TARBALLNAME="bulwark-1.2.3.0-linux64.tar.gz"
BWKVERSION="1.2.3.0"

STRING1="Make sure you double check before hitting enter! Only one shot at these!"
STRING2="If you found this helpful, please donate to BWK Donation: "
STRING3="bCkL87UvfwqphwCdWgyShFYz54hgPVJAg3"
STRING4="Updating system and installing required packages."
STRING5="Switching to Aptitude"
STRING6="Some optional installs"
STRING7="Starting your masternode"
STRING8="Now, you need to finally start your masternode in the following order:"
STRING9="Go to your desktop wallet and from the Control wallet debug console please enter"
STRING10="startmasternode alias false <mymnalias>"
STRING11="where <mymnalias> is the name of your masternode alias (without brackets)"
STRING12="once completed please return to this VPS and press the space bar"
STRING13=""
STRING14="The Masternode is in the process of being fully started and is now syncing."
STRING15="The Masternode can take several hours to fully start, please wait for it to finish!"

echo $STRING1

cat  << EOF

                           *** Disclaimer ***

You are now presented with the choice between two installation options:

   The default, simple installation option and an advanced installation option.

The advanced installation option will install and run the masternode under a non-privileged user.

Do not choose for the advanced installation option if you are not comfortable with the command
line interface on Linux.

EOF

read -e -p "Use the Advanced Installation? [N/y] : " advanced

if [[ ("$advanced" == "y" || "$advanced" == "Y") ]]; then

read -e -p "Username for unprivileged User (Press enter for the default bulwark user) : " USER
USER=${USER:-bulwark}

adduser $USER --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password

else

USER=root

fi

USERHOME=`eval echo "~$USER"`

clear

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

#Generating Random Passwords
rpcuser=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)
rpcpassword=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

# update package and upgrade Ubuntu
apt-get -y update
apt-get -y upgrade
apt-get -y autoremove
apt-get -y install wget htop
apt-get -y install build-essential && apt-get -y install libtool autotools-dev autoconf automake && apt-get -y install libssl-dev && apt-get -y install libboost-all-dev && apt install software-properties-common && add-apt-repository ppa:bitcoin/bitcoin && apt update && apt-get -y install libdb4.8-dev && apt-get -y install libdb4.8++-dev && apt-get -y install libminiupnpc-dev && apt-get -y install libqt4-dev libprotobuf-dev protobuf-compiler && apt-get -y install libqrencode-dev && apt-get -y install git && apt-get -y install pkg-config apt-get -y install libzmq3-dev

clear

echo $STRING5
apt-get -y install aptitude

echo $STRING6
if [[ ("$install_fail2ban" == "y" || "$install_fail2ban" == "Y" || "$install_fail2ban" == "") ]]; then
  cd ~
  aptitude -y install fail2ban
  service fail2ban restart
fi
if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
  apt-get -y install ufw
  ufw default deny incoming
  ufw default allow outgoing
  ufw allow ssh
  ufw allow 52543/tcp
  yes | ufw enable
fi

#Install Bulwark Daemon
wget $TARBALLURL
tar -xzvf $TARBALLNAME && mv bin bulwark-$BWKVERSION
rm $TARBALLNAME
cp ./bulwark-$BWKVERSION/bulwarkd /usr/local/bin
cp ./bulwark-$BWKVERSION/bulwark-cli /usr/local/bin
cp ./bulwark-$BWKVERSION/bulwark-tx /usr/local/bin

clear

#Setting up coin
echo $STRING2
echo $STRING13
echo $STRING3
echo $STRING13
echo $STRING4
sleep 10

#Create bulwark.conf
mkdir $USERHOME/.bulwark
echo '
rpcuser='$rpcuser'
rpcpassword='$rpcpassword'
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
addnode=bwk1.masterhash.us:52543
addnode=bwk2.masterhash.us:52543
addnode=bwk3.masterhash.us:52543
addnode=bwk4.masterhash.us:52543
addnode=bwk5.masterhash.us:52543
addnode=bwk6.masterhash.us:52543
addnode=bwk7.masterhash.us:52543
addnode=bwk8.masterhash.us:52543
addnode=bwk9.masterhash.us:52543
addnode=bwk10.masterhash.us:52543
' | tee $USERHOME/.bulwark/bulwark.conf >/dev/null 2>&1
chmod 0600 $USERHOME/.bulwark/bulwark.conf
chown $USER:$USER $USERHOME/.bulwark/bulwark.conf

sleep 10

su -c "/usr/local/bin/bulwarkd -daemon" $USER

#Starting coin
(
  su -c "crontab -l 2>/dev/null
  echo '@reboot sleep 30 && /usr/local/bin/bulwarkd -daemon -shrinkdebugfile'" $USER
) | su -c "crontab" $USER
(
  su -c "crontab -l 2>/dev/null
  echo '@reboot sleep 60 && bulwark-cli startmasternode local false'" $USER
) | su -c "crontab" $USER


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
echo $STRING13
sleep 10

read -p "Press any key to continue... " -n1 -s

clear

echo $STRING13
echo "Don't logout to this VPS connection and copy the below instructions to your notepad"
echo $STRING13
echo "To verify the sync status, use the following command: "
sleep 3
echo $STRING13
echo "grep masternode-sync ~/.bulwark/debug.log"
echo $STRING13
sleep 3
echo " The sync is completed when the output of the above command includes the following : "
echo $STRING13
sleep 3
echo " cs_vNodes  masternode-sync.cpp"
echo $STRING13
echo $STRING13
sleep 3
echo "Please take notice that the sync process can take more than 8 hours to complete!"
echo $STRING13
echo $STRING13
sleep 3
echo $STRING13
echo "Only after the sync has been completed, the following can be executed :"
echo $STRING13
echo $STRING8
echo $STRING9
echo $STRING13
echo $STRING10
echo $STRING11
echo $STRING12
echo $STRING13
echo "/usr/local/bin/bulwark-cli startmasternode local false"
echo $STRING13
echo $STRING13
sleep 30
echo "To attest the masternode status: "
echo $STRING13
echo "/usr/local/bin/bulwark-cli masternode status"
echo $STRING13
echo "End of instructions"
echo $STRING13
