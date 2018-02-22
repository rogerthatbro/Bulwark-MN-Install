## Funding your Masternode

* First, we will do the initial collateral TX and send exactly 5000 BWK to one of our addresses. To keep things sorted in case we setup more masternodes we will label the addresses we use. 

  - Open your BWK wallet and switch to the "Receive" tab.

  - Click into the label field and create a label, I will use MN1

  - Now click on "Request payment"

  - The generated address will now be labelled as MN1 If you want to setup more masternodes just repeat the steps so you end up with several addresses for the total number of nodes you wish to setup. Example: For 10 nodes you will need 10 addresses, label them all.

  - Once all addresses are created send 5000 BWK each to them. Ensure that you send exactly 5000 BWK and do it in a single transaction. You can double check where the coins are coming from by checking it via coin control usually, that's not an issue.

* As soon as all 5k transactions are done, we will wait for 15 confirmations. You can check this in your wallet or use the explorer. It should take around 30 minutes if all transaction have 15 confirmations

## Installation & Setting up your Server

Generate your Masternode Private Key
```bash
masternode genkey

Write this down or copy it somewhere safe.
```
View your Output

```bash
masternode outputs

Write this down or copy it somewhere safe. 
```

SSH (Putty Suggested) to your VPS, login to root, and clone the Github repository:

```bash
git clone https://github.com/bulwark-crypto/Bulwark-MN-Install
```
Navigate to the install folder:

```bash
cd Bulwark-MN-Install
```

Install & configure your desired master node with options. The command you use depends on your version of Ubuntu. 

For Ubuntu 14.04:

```bash
bash install_ubuntu_14.04.sh 
```

For Ubuntu 16.04:

```bash
bash install_ubuntu_16.04.sh 
```

For Ubuntu 17.10:

```bash
bash install_ubuntu_17.10.sh
```

When the script asks, input your VPS IP Address and Private Key (You can copy your private key and paste into the VPS if connected with Putty by right clicking)

Once done, the VPS will ask you to go start your masternode in the local wallet

In appdata/roaming/Bulwark, open up masternode.conf

Insert as a new line the following:

```bash
masternodename ipaddress:52543 privatekey output
```

Open up the local wallet, unlock with your encryption password, and open up the Debug Console

```bash
startmasternode alias false <masternodename>
```
If done correctly, it will indicate that the masternode has been started correctly. 

Go back to your VPS and hit the spacebar. It will say that it needs to sync. You're all done!

Now you just need to wait for the VPS to sync up the blockchain and await your first masternode payment.

## Refreshing Node

To refresh your node please run this from root ~

```
rm -rf Bulwark-MN-Install && git clone https://github.com/bulwark-crypto/Bulwark-MN-Install && cd Bulwark-MN-Install && bash refresh_node.sh
```

No other attention is required.
