#!/bin/bash

clear
echo "This script will refresh your masternode."
read -p "Press Ctrl-C to abort or any other key to continue. " -n1 -s
clear

if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root."
  exit 1
fi

USER=`ps u $(pgrep bulwarkd) | grep bulwarkd | cut -d " " -f 1`
USERHOME=`eval echo "~$USER"`

if [ -e /etc/systemd/system/bulwarkd.service ]; then
  systemctl stop bulwarkd
else
  su -c "bulwark-cli stop" $BWKUSER
fi

sleep 10

rm -rf $USERHOME/.bulwark/blocks
rm -rf $USERHOME/.bulwark/database
rm -rf $USERHOME/.bulwark/chainstate
rm -rf $USERHOME/.bulwark/peers.dat

cp $USERHOME/.bulwark/bulwark.conf $USERHOME/.bulwark/bulwark.conf.backup
sed -i '/^addnode/d' $USERHOME/.bulwark/bulwark.conf

if [ -e /etc/systemd/system/bulwarkd.service ]; then
  sudo systemctl start bulwarkd
else
  su -c "bulwarkd -daemon" $USER
fi

echo "" && echo "Masternode refresh completed." && echo ""
