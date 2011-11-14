#!/bin/bash
# cp on steroids
# WARNING!! No support for -t [DESTINATION] switch

IFS_BACKUP=$IFS
IFS=`echo -en "\n\b"`
FIFO="/var/tmp/`basename $0`.$$.$RANDOM"
RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
CYAN='\e[0;36m'
NC='\e[0m'
sp="/-\|"
sc=0
declare -a SWITCHES
declare -a TARGETS
SIZES=(b Kb Mb Gb Tb)
OPTS=""
DESTINATION=""
WIDTH=$(( `tput cols` - 11 ))

################  Functions ################
spin() {
	printf "%s\b" "${sp:sc++:1}"
	((sc==${#sp})) && sc=0
}

endspin() {
	printf "%s\n" "$@"
}

usage() {
	cp --help
	exit 1
}

cleanup() {
 	echo -n "Signal caught. Attempting to clean things up... "
	if [ -n "$o_pid" ]; then
		kill "$o_pid" &> /dev/null
		if [ "$?" = "0" ]; then
			echo "All good."
		else
			echo "Clean up the mess yourself."
		fi
	fi
	exit 0
}

# This is used to parse all the parameters passed to this script and seperate switches from sources and targets
par_parser() {
	local s=0
	local t=0
	for arg in "$@"; do
		if [ `expr match "$arg" '-.*'` -ge 2 ]; then
			SWITCHES[$s]=$arg
			(( s++ ))
		elif [ -e "$arg" -o -e "`dirname $arg`" ]; then
			TARGETS[$t]=$arg
			(( t++ ))
		else
			echo "$arg: Invalid argument or file/directory"
			exit 5
		fi
	done
	OPTS=`echo ${SWITCHES[@]}`
	if [ ${#TARGETS[@]} -lt 2 ]; then
		echo "Missing target or destination file/directory"
		exit 6
	else
		TC=$(( ${#TARGETS[@]} - 1 ))
		DESTINATION=${TARGETS[$TC]}
		unset TARGETS[$TC]
	fi
}

# More eye-candy. Calculate sizes in humar-readable format
# This is a very very dirty hack....
sanitize_size() {
	y=\$"$1"
	x=`eval "expr \"$y\""`
	local i=0
	orgsize=$x
	while [ `echo "scale=2; $orgsize > 1024.00" | bc -l` -eq 1 ]; do
		orgsize=`echo "scale=2; $orgsize / 1024.00" | bc -l`
		(( i++ ))
	done
	eval "$1=\"$orgsize ${SIZES[$i]}\""
}

################ Main ################
# put the signal handler in place
trap cleanup INT TERM 

par_parser "$@"

# Calculate size of data (in bytes) to be copied
mkfifo $FIFO || {
	echo "Failed to create pipe. I will go away now..." 1>&2
	exit 2
}
echo -n "Prepearing to copy... "
for fff in "${TARGETS[@]}"; do
	if [ -d $fff ]; then
		( du -sb $fff | awk '{print $1}' > $FIFO ) &
		o_pid=`ps -ef | grep "[d]u" | awk '{print $2}'`
		while [ 1 ]; do
			kill -0 ${o_pid} 2> /dev/null
			if [ "$?" = "0" ]; then
				spin
			else
				let "orig_size+=`cat $FIFO`"
				break
			fi  
		done
	else
		let "orig_size+=`stat -c %s $fff`"
	fi
done
org_eyecandy_size=$orig_size
sanitize_size org_eyecandy_size
endspin "(Total size: ${org_eyecandy_size})"
rm $FIFO
unset o_pid
unset org_eyecandy_size

dest_size=0
SOURCES=${TARGETS[@]}

# keep old directory size before copying to calculate progress
if [ -d $DESTINATION ]; then
	old_size=`du -sb $DESTINATION | awk '{print $1}'`
fi

cp $OPTS $SOURCES $DESTINATION &
o_pid=`ps -ef | grep -w "[c]p" | awk '{print $2}'`
sleep 1
while [ $orig_size -gt $dest_size ]; do
	if [ -d $DESTINATION ]; then
		dest_size=$(( `du -sb $DESTINATION | awk '{print $1}'` - $old_size ))
	elif [ -f $DESTINATION ]; then
		dest_size=`stat -c %s $DESTINATION`
	fi
	pct=$((( $WIDTH * $dest_size ) / $orig_size ))

	echo -en "\r${BLUE}[${NC} "
	for j in `seq 1 $pct`; do
		echo -ne "${GREEN}=${NC}"
	done
	echo -ne "${GREEN}>${NC}"
	for j in `seq $pct $(( $WIDTH - 1))`; do
		echo -ne "${CYAN}-${NC}"
	done
	echo -ne " ${BLUE}] ${GREEN}"
	echo -ne $((( 100 * $pct ) / $WIDTH ))
	echo -ne "%${NC}"
	sleep 1
done
unset o_pid
echo
IFS=$IFS_BACKUP
