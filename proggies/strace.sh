#!/bin/bash

if test -z "$1"; then
	echo "Give PID of process to attach"
	exit 1
fi

strace -p "$1" -o /tmp/strace.log &

if [ "$?" -ne "0" ]; then
	echo "Failed to attach to process"
	exit 2
fi

PID=`pidof strace`

while [ -d /proc/$PID ]; do
	FSIZE=`/bin/ls -la /tmp/strace.log | awk '{print $5}'`
	if [ "$FSIZE" -gt "10485760" ]; then
		echo "" > /tmp/strace.log
		if [ "$?" -ne "0" ]; then
			echo "Failed to clear log file"
		fi
	fi
	sleep 2
done
