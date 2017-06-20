#!/bin/bash

SINK=$(pactl list sinks short | grep RUNNING | awk '{print $1}')

[[ -z $SINK ]] && { echo "No current output source"; exit 1; }

case $1 in
	up)
		pactl set-sink-volume $SINK +5%
		;;
	down)
		pactl set-sink-volume $SINK -5%
		;;
	toggle)
		pactl set-sink-mute $SINK toggle
		;;
	*)
		echo "no valid command"
esac 
