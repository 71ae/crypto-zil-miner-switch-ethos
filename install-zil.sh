#!/bin/bash

cat <<EOO

#################################################################
# Zilliqa (ZIL) Mining Switch for ethOS
# Project: https://github.com/71ae/crypto-zil-miner-switch-ethos
#################################################################

We're making use of some additional system libraries and the
PhoenixMiner, so we need to take care of some requirements.

In case of any errors please submit an issue at:
https://github.com/71ae/crypto-zil-miner-switch-ethos/issues/new

#################################################################

EOO

sleep 5

# Install requirements

sudo apt-get-ubuntu -qq -y update
sudo apt-get-ubuntu -qq -y install libwww-perl liblwp-protocol-https-perl libjson-perl libjson-xs-perl

bash <(curl -s https://raw.githubusercontent.com/cynixx3/third-party-miner-installer-for-ethos/master/miner-manager) phoenixminer install

# Kill existing Switch Loop
pkill zil-loop.sh

# Download ZIL Mining Switch for ethOS
cd ~
git clone --depth 1 https://github.com/71ae/crypto-zil-miner-switch-ethos.git 
cd crypto-zil-miner-switch-ethos

# Copy files to target directory
cd ~
[ ! -d zil-miner-switch ] && mkdir zil-miner-switch
cp -p crypto-zil-miner-switch-ethos/* zil-miner-switch/
cp -p crypto-zil-miner-switch-ethos/src/* zil-miner-switch/
if [ ! -e zil-miner-switch/mineropts.txt ]; then
  cp -p crypto-zil-miner-switch-ethos/config/mineropts.txt zil-miner-switch/
fi
if [ ! -e zil-miner-switch/minerpool.txt ]; then
  cp -p crypto-zil-miner-switch-ethos/config/minerpool.txt zil-miner-switch/
fi

# Clean up
rm -rf crypto-zil-miner-switch-ethos
sudo apt-get-ubuntu -qq clean

cat <<EOO

#################################################################

Now please edit the pool and wallet configuration!
Execute:
nano zil-miner-switch/minerpool.txt

After you've done this, you can start this toolsuite with:
bash zil-miner-switch/zil-init.sh

To make sure the ZIL Mining Switcher also starts when you power on your rig,
you also can add the following line into custom.sh (execute nano custom.sh)
before the "exit" line:
bash -c zil-miner-switch/zil-init.sh

We're ready to go...

#################################################################

EOO

# to-do: download release instead
# configure

