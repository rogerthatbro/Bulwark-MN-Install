#!/bin/bash

### THIS IS UNTESTED, PROCEED WITH CAUTION!

clear
echo "This script will update your masternode to version 1.2.2."
read -p "Press Ctrl-C to abort or any other key to continue... " -n1 -s
echo "Please enter your password to enter administrator mode:"
sudo true
echo "Shutting down masternode..."
bulwark-cli stop
echo "Installing Bulwark 1.2.2..."
mkdir ./bulwark-temp && cd ./bulwark-temp
wget https://github.com/bulwark-crypto/Bulwark/releases/download/1.2.2/bulwark-1.2.2.0-linux64.tar.gz
tar -xzvf bulwark-1.2.2.0-linux64.tar.gz
yes | sudo cp -rf ./bin/bulwarkd /usr/bin
yes | sudo cp -rf ./bin/bulwark-cli /usr/bin
cd ..
rm -rf ./bulwark-temp
echo "Restarting Bulwark daemon..."
bulwarkd -daemon
clear
echo "Starting masternode..."
bulwark-cli startmasternode local false
bulwark-cli masternode status
