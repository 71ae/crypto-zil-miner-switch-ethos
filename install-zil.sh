#!/bin/bash

cat <<EOO

#################################################################
# Zilliqa (ZIL) Mining Switch for ethOS
# Project: https://github.com/71ae/crypto-zil-miner-switch-ethos
#################################################################

We're making use of some additional system libraries and the
PhoenixMiner, so we need to take care of some requirements.

We also need to configure your preferred mining pool and make
sure you mine into your own wallet.

If you are asked about these details, or the system password
of your mining rig, please provide those. They will be used
by this script only and saved onto your rig only, but never
be submitted to any third party.

In case of any errors please submit an issue at:
https://github.com/71ae/crypto-zil-miner-switch-ethos/issues/new

#################################################################

EOO

sleep 5

sudo apt-get-ubuntu update
sudo apt-get-ubuntu install libwww-perl liblwp-protocol-https-perl libjson-perl libjson-xs-perl

bash <(curl -s https://raw.githubusercontent.com/cynixx3/third-party-miner-installer-for-ethos/master/miner-manager) phoenixminer install

# to-do: download release
# configure

