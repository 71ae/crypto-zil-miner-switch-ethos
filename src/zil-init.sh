#!/bin/bash

export LC_ALL=C

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/ethos/bin:/opt/ethos/sbin"

ZILLOOP="zil-loop"

case "$-" in
  *i*)
      INTERACTIVE=1
      ;;
  *)
      INTERACTIVE=0
      ;;
esac

for pid in $(pgrep -f ${ZILLOOP}.sh); do
  if [ $pid != $$ ]; then
    if [ "$INTERACTIVE" == "1" ]; then
      echo "[$(date)]: ${ZILLOOP}.sh process is already running with PID $pid"
      screen -ls | grep "zil"
    fi
    exit 1
  fi
done


screen -wipe 2>&1 >/dev/null

screen -dmS zil -t zil ${HOME}/zil-miner-switch/${ZILLOOP}.sh

