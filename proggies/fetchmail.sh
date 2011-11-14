#!/bin/bash

PID=$(pgrep offlineimap)
#it's frozen. Kill and re-sync
[[ -n "$PID" ]] && kill $PID
offlineimap -o -u quiet &>/dev/null &
exit 0
