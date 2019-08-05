#!/bin/bash

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/ethos/bin:/opt/ethos/sbin"

# Make sure EthOS Miner is allowed for now
allow

# Loop forever
while :
do

# Ensure script is not running more than once
for pid in $(pgrep -f $(basename $0)); do
  status=$(ps ax | grep $pid | grep SCREEN)
  if [[ -z $status ]] && [[ $pid != $$ ]]; then
    echo "[$(date)]: Process is already running with PID $pid"
    exit 1
  fi
done

# Wait for Zilliqa ZIL PoW Time
perl ${HOME}/zil-miner-switch/zil-waitfor-pow.pl

# Stopp EthOS Miner
disallow
minestop

# Wait a few seconds
sleep 15

# Read config
source ${HOME}/zil-miner-switch/mineropts.txt
source ${HOME}/zil-miner-switch/minerpool.txt

# Start PhoenixMiner for ZIL Mining for 5 Minutes
/opt/miners/phoenixminer/PhoenixMiner -pool ${POOL} -wal ${WALLET} -worker ${HOSTNAME} -proto 2 -gsi 15 -log 1 -logfile /run/miner.output -rmode 0 -timeout 5 ${OPTS}

# Wait a few seconds
sleep 5

# Restart EthOS Miner
allow

# Repeat loop
done

