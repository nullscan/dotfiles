#!/bin/bash

cnt=0
low=16
maxcnt=3
declare -a j

MACDIR=`dirname $0`
ln=$(($RANDOM%`cat $MACDIR/.macs | wc -l`))
l=`tail -n +$ln < $MACDIR/.macs | head -n1`
j=`echo $l | awk '{print $1}'`
k=`echo $l | awk '{for ( i = 2; i <= NF; i++ ) printf ("%s ", $i)}' | sed 's/[ \t]*$//'`

ranmac()
{
	num=0
	while [ "$num" -lt "$low" ]; do
		num=$RANDOM
		let "num %= 256"
	done
	j=$j`printf ":%x" "$num"`
}

while [ "$cnt" -lt "$maxcnt" ]; do
	devran=$(head -1 /dev/urandom | od -N 1 | awk '{ print $2 }')
	RANDOM="$devran"
	ranmac
	let "cnt += 1"
done

echo -n $j | tr 'a-z' 'A-Z'
echo " ($k)"
