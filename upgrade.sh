#!/bin/bash

wget https://github.com/bulwark-crypto/Bulwark/releases/download/bulwark-1.2.0.3/bulwark-1.2.0.3-x86_64-ubuntu16.04-gnu.tar.gz
bulwark-cli stop
tar -xvf bulwark-1.2.0.3-x86_64-ubuntu16.04-gnu.tar.gz
sudo mv bulwark-1.2.0/bin/bulwark{d,-cli} /usr/bin
sudo mv /root/.bulwark /root/.bulwark.bak
mkdir /root/.bulwark
sudo cp /root/.bulwark.bak/wallet.dat /root.bulwark
sudo cp /root/.bulwark.bak/bulwark.conf /root/.bulwark
sudo chown -R /root/.bulwark
bulwarkd -daemon
