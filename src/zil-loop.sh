#!/bin/bash

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/ethos/bin:/opt/ethos/sbin"

LOG_FILE="/tmp/zil-switch.log"

# Define Log Function
Log() {
  msg="$*"
  # print to the terminal if we have one
  test -t 1 && echo "$(date "+%Y-%m-%d %H:%M:%S %Z") [$$] ""$msg"
  # write to log file
  echo "$(date "+%Y-%m-%d %H:%M:%S %Z") [$$] ""$msg" >> $LOG_FILE
}

# Start
Log "Starting ZIL Switcher Loop."

# Make sure EthOS Miner is allowed for now
Log "Allowing ethOS standard miner."
allow || Log "ERROR: allow"

# Loop forever
while :
do

# Ensure script is not running more than once
for pid in $(pgrep -f $(basename $0)); do
  status=$(ps ax | grep $pid | grep SCREEN)
  if [[ -z $status ]] && [[ $pid != $$ ]]; then
    Log "Process is already running with PID $pid."
    sleep 120
    exit 1
  fi
done

# Wait for Zilliqa ZIL PoW Time
Log "Wait for ZIL PoW Time"
perl ${HOME}/zil-miner-switch/zil-waitfor-pow.pl || \
  Log "WARN: zil-waitfor-pow returned non-zero exit code."

# Stopp EthOS Miner
Log "Stopping ethOS default miner"
disallow || Log "ERROR: disallow"
minestop || Log "ERROR: minestop"

# Wait a few seconds
sleep 15

# Read config
Log "Reading ZIL Switcher Config"
source ${HOME}/zil-miner-switch/mineropts.txt
source ${HOME}/zil-miner-switch/minerpool.txt

# Start PhoenixMiner for ZIL Mining for 5 Minutes
Log "Starting ZIL PhoenixMiner"
/opt/miners/phoenixminer/PhoenixMiner -pool ${POOL} -wal ${WALLET} -worker ${HOSTNAME} -proto 2 -gsi 15 -log 1 -logfile /run/miner.output -rmode 0 -timeout 5 ${OPTS} || \
  Log "WARN: ZIL PhoenixMiner returned non-zero exit code."
Log "ZIL PhoenixMiner ended."

# Wait a few seconds
sleep 5

# Restart EthOS Miner
Log "Allowing ethOS standard miner."
allow || Log "ERROR: allow"

# Repeat loop
done

