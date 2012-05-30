#!/bin/bash
 
BG='#000000'  # dzen backgrounad
FG='#DDEEDD'  # dzen foreground
W=512     # width of the dzen bar
GW=63      # width of the gauge
GFG='#3666A4'  # color of the gauge
GH=8       # height of the gauge
GBG='#616161'  # color of gauge background
FN='-*-terminus-medium-*-*-*-12-*-*-*-*-*-*-*' # font
TIME_INT=2         # time intervall in seconds
DATEFORMAT='%a, %d.%m.%Y, %H:%M'
PREBAR='^i(/home/poly/.xmonad/battery.xbm)' # caption (also icons are possible)
 
#Functions
#Convert seconds to Hour, minute, second format
function sanitize {
	HOURS=`echo "$1 / 3600" | bc`
	HOURS_No=`expr 3600 \* $HOURS`
	SECONDS=`expr $1 - $HOURS_No`
	MINUTES=`echo "$SECONDS / 60" | bc`
	MINUTES_No=`expr 60 \* $MINUTES`
	SECONDS=`expr $SECONDS - $MINUTES_No`
	if [ $MINUTES -le 9 ]; then
		MINUTES="0$MINUTES"
	fi
	echo -n "about $HOURS:$MINUTES left"

# Uncomment the code below if you preffer full lexical battery status
#if [ $HOURS -gt 0 ]; then
#		echo -n "$HOURS Hours, $MINUTES Minutes and $SECONDS Seconds left"
#	else
#		if [ $MINUTES -gt 0 ]; then
#			echo -n "$MINUTES Minutes and $SECONDS Seconds left"
#		else
#			echo -n "$SECONDS Seconds left"
#		fi
#	fi
}

function batt_calc {
#Battery charge information
	CURRENT_NOW_R=`cat /sys/class/power_supply/C1C0/current_now`
	CURRENT_NOW=`expr $CURRENT_NOW_R / 1000`
	FULL_CHARGE_R=`cat /sys/class/power_supply/C1C0/charge_full`
	FULL_CHARGE=`expr $FULL_CHARGE_R / 1000`
	CHARGE_NOW_R=`cat /sys/class/power_supply/C1C0/charge_now`
	CHARGE_NOW=`expr $CHARGE_NOW_R / 1000`

#charging or discharging
	STATUS=`cat /sys/class/power_supply/C1C0/status`
	if [ $STATUS = "Charging" ]; then
		MPE=`expr $FULL_CHARGE - $CHARGE_NOW`
	elif [ $STATUS = "Discharging" ]; then
		MPE=$CHARGE_NOW
	fi

	MPE1=`expr $MPE \* 3600`
	SECONDS=`expr $MPE1 / $CURRENT_NOW`
	sanitize $SECONDS
}


while true; do
# look up battery's data
	BAT_FULL=`cat /sys/class/power_supply/C1C0/charge_full`
	STATUS=`cat /sys/class/power_supply/C1C0/status`
	RCAP=`cat /sys/class/power_supply/C1C0/charge_now`

# calculate remaining power
	RPERCT=`expr $RCAP \* 100`
	RPERC=`expr $RPERCT / $BAT_FULL`
	if [ $RPERC -gt 100 ]; then
		RPERC=100
	fi

	DATE=`date +"$DATEFORMAT"`
	echo -n "^p(_LEFT)$DATE "

# change colors depending on battery charge perc.
	if [ $RPERC -gt 75 ]; then
		GFG='#33FF33'
	elif [ $RPERC -gt 50 ]; then
		GFG='#003399'
	elif [ $RPERC -gt 25 ]; then
		GFG='#FFFF00'
	else
		GFG='#FF0033'
	fi

# draw batery bar and text description
	echo -n "$PREBAR "
	eval echo $RPERC | dzen2-gdbar -h $GH -w $GW -fg $GFG -bg $GBG -nonl -s o -ss 1 -sw 4
	if [ $STATUS = "Charging" ]; then
		echo -n " (Charging, "
		batt_calc
		echo ")"
	elif [ $STATUS = "Discharging" ]; then
		echo -n " (On Battery, "
		batt_calc
		echo ")"
	else
		echo " (On AC)"
	fi
	sleep $TIME_INT
done | dzen2 -ta r -x 512 -w $W -h 14 -fg $FG -fn $FN -bg $BG
#netwox 169 | tail -n2 | head -n1 | awk '{print $2}'
