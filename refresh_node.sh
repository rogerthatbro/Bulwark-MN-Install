#!/bin/bash
clear

bulwark-cli stop

sleep 10

rm -rf ~/.bulwark/blocks
rm -rf ~/.bulwark/database
rm -rf ~/.bulwark/chainstate
rm -rf ~/.bulwark/peers.dat

sed -i '/^addnode/d' ~/.bulwark/bulwark.conf
cat <<EOL >>  ~/.bulwark/bulwark.conf

addnode=136.243.60.144:52543
addnode=172.104.36.68:52543
addnode=195.181.214.183:52543
addnode=84.47.129.117:52543
addnode=[2001:0:5ef5:79fb:289b:1e44:3f21:2d61]:51954
addnode=[2001:0:9d38:6ab8:1c56:1363:a0b8:79fc]:55177
addnode=[2001:0:9d38:6ab8:c8e:2776:4deb:4d85]:61638
addnode=[2001:0:9d38:6ab8:f0:2b42:fda0:4564]:52543
addnode=[2001:0:9d38:6abd:18f6:fbff:2c24:b9f9]:63076
addnode=[2a01:4f8:13b:1110::2]:49934
EOL

bulwarkd -daemon
