#!/bin/bash

export LC_ALL=C

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/ethos/bin:/opt/ethos/sbin"

screen -wipe 2>&1 >/dev/null

screen -dmS zil -t zil ${HOME}/zil-miner-switch/zil-loop.sh

