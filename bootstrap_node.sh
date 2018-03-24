#!/usr/bin/env bash

# To keep this script up to date, replace the version number in lines 17, 31 and 32
# and replace the SHA256 checksum in line ?

WORKDIR=$(pwd)

clear
echo "This script will bootstrap your masternode."
read -p "Press Ctrl-C to abort or any other key to continue." -n1 -s
clear

if ! which bulwark-cli > /dev/null 2>&1; then
  echo "ERROR: It looks like Bulwark isn't installed. Please install it first."
  exit
fi

if ! bulwark-cli --version | grep "v1.2.3.0" > /dev/null 2>&1;  then
  echo "ERROR: Your version of Bulwark is outdated. Please update first".
  exit
fi

if ! [ -d ~/.bulwark ]; then
  echo "ERROR: Bulwark appdata folder not found."
  exit
fi

echo "Stopping bulwarkd..."
bulwark-cli stop
echo "Downloading bootstrap files..."
mkdir bootstraptemp && cd bootstraptemp
wget https://github.com/bulwark-crypto/Bulwark/releases/download/1.2.3/bulwark_1.2.3_bootstrap.tar.gz
echo "Checking file integrity..."
if ! sha256sum bulwark_1.2.3_bootstrap.tar.gz | grep 048bd1bdcbc44646112b5d2b3bd0b64f2d1e71ebdd728e6a6b17497cec6c6c6b; then
  echo "ERROR: Checksum failed, bootstrap file might be compromised!"
  exit
fi
echo "Extracting bootstrap files..."
tar xzvf bulwark_1.2.3_bootstrap.tar.gz
cd Bulwark
echo "Deleting old chaindata..."
rm -rf ~/.bulwark/blocks ~/.bulwark/budget.dat ~/.bulwark/chainstate ~/.bulwark/database ~/.bulwark/fee_estimates.dat ~/.bulwark/mncache.dat ~/.bulwark/peers.dat
echo "Installing bootstrap files..."
mv -f * ~/.bulwark/
echo "Restarting bulwarkd..."
bulwarkd -daemon
echo "bulwarkd started."
echo "Cleaning up..."
cd $WORKDIR
rm -rf bootstraptemp
read -p "Please wait 5 minutes for the client to sync, then press any key to continue." -n1 -s
clear
echo "Starting masternode..."
bulwark-cli startmasternode local false
echo "Bootstrap complete."
