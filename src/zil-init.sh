#!/bin/bash

export LC_ALL=C

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/ethos/bin:/opt/ethos/sbin"

ZILLOOP="zil-loop"

LOG_FILE="/tmp/zil-switch.log"

# Clear Log
echo > $LOG_FILE

# Define Log Function
Log() {
  msg="$*"
  # print to the terminal if we have one
  test -t 1 && echo "$(date "+%Y-%m-%d %H:%M:%S %Z") [$$] ""$msg"
  # write to log file
  echo "$(date "+%Y-%m-%d %H:%M:%S %Z") [$$] ""$msg" >> $LOG_FILE
}

# Start
Log "Starting ZIL Switcher."

for pid in $(pgrep -f ${ZILLOOP}.sh); do
  if [ $pid != $$ ]; then
    Log "${ZILLOOP}.sh process is already running with PID $pid."
    test -t 1 && screen -ls | grep "zil"
    test -t 1 && Log "Watch the log with: tail -f $LOG_FILE (Ctrl-c to stop)."
    exit 1
  fi
done

screen -wipe 2>&1 >/dev/null

Log "Entering ZIL Loop Screen"
screen -dmS zil -t zil ${HOME}/zil-miner-switch/${ZILLOOP}.sh

