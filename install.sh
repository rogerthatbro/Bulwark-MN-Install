output() {
    printf "\E[0;33;40m"
    echo $1
    printf "\E[0m"
}

displayErr() {
    echo
    echo $1;
    echo
    exit 1;
}
clear
output "Make sure you double check before hitting enter! Only one shot at these!"
output ""
    read -e -p "Server IP Address : " ip
    read -e -p "Masternode Private Key (e.g. 7edfjLCUzGczZi3JQw8GHp434R9kNY33eFyMGeKRymkB56G4324h # THE KEY YOU GENERATED EARLIER) : " key
    read -e -p "Install Fail2ban? [Y/n] : " install_fail2ban
    read -e -p "Install UFW and configure ports? [Y/n] : " UFW

    clear
    output "If you found this helpful, please donate to BWK Donation: "
    output ""
    output "bCkL87UvfwqphwCdWgyShFYz54hgPVJAg3"
    output ""
    output "Updating system and installing required packages."
    output ""

# update package and upgrade Ubuntu
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y autoremove
    sudo apt-get install wget nano htop -y
    clear
    output "Switching to Aptitude"
    output ""
    sudo apt-get -y install aptitude

#Generating Random Passwords
    password=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    password2=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`

    output "Some optional installs"
    if [[ ("$install_fail2ban" == "y" || "$install_fail2ban" == "Y" || "$install_fail2ban" == "") ]]; then
    sudo aptitude -y install fail2ban
    fi
    if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
    sudo apt-get install ufw
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    sudo ufw allow 52543/tcp
    fi

#Install Bulwark Daemon
    wget https://github.com/bulwark-crypto/Bulwark/releases/download/bulwark-1.2.0.1-release/bulwark-1.2.0-x86_64-linux-gnu.tar.gz
    sudo tar -xzvf bulwark-1.2.0-x86_64-linux-gnu.tar.gz
    sudo rm bulwark-1.2.0-x86_64-linux-gnu.tar.gz
    sudo cp ~/bulwark-1.2.0/bin/bulwarkd /usr/bin
    sudo cp ~/bulwark-1.2.0/bin/bulwark-cli /usr/bin
    bulwarkd -daemon
    clear
#Setting up coin
    output "If you found this helpful, please donate to BWK Donation: "
    output ""
    output "bCkL87UvfwqphwCdWgyShFYz54hgPVJAg3"
    output ""
    output "Updating system and installing required packages."
    output ""

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
' | sudo -E tee ~/.bulwark/bulwark.conf >/dev/null 2>&1
    sudo chmod 0600 ~/.bulwark/bulwark.conf

#Starting coin
    (crontab -l 2>/dev/null; echo '@reboot sleep 60 && bulwarkd -daemon -shrinkdebugfile') | crontab
    bulwarkd -daemon

    output "Start your masternode"
    output ""
    output "Now, you need to finally start these things in this order"
    output ""
    output "Go to your windows wallet and from the Control wallet debug console please enter"
    output ""
    output "startmasternode alias false <mymnalias>"
    output ""
    output "where <mymnalias> is the name of your masternode alias (without brackets)"
    output ""
    output "once completed please return to VPS and press the space bar"
    output ""
    read -p "Press any key to continue... " -n1 -s
    bulwark-cli startmasternode local false
    bulwark-cli masternode status
