#!/bin/bash
# converts seconds to days-hours-minutes-seconds
# by nullscan

if [ $# != 1 ];then
	echo "usage: `basename $0` <time in secs>\n"
	exit 99
fi

`printf "$1\n" | egrep "[^0-9]" &>/dev/null`
if [ $? != 1 ];then
	printf "the arg passed to the script contains\n"
	printf "non-numerical characters, i'm exiting\n"
	exit 98
fi

days=`printf "scale=0;$1 / 86400\n" | bc -l`
hours=`printf "scale=0;($1 / 3600) - ($days * 24)\n"  | bc -l `
minutes=`printf "scale=0;($1 / 60) - ($days * 1440) - ($hours * 60)\n" | bc -l`
seconds=`printf "scale=0;$1 %% 60\n" | bc -l`

[ "0" = ${days} ] || ( echo -n "$days Day"; [ "1" = ${days} ] && echo -n ", " || echo -n "s, " )
[ "0" = ${hours} ] || ( echo -n "$hours Hour"; [ "1" = ${hours} ] && echo -n ", " || echo -n "s, " )
[ "0" = ${minutes} ] || ( echo -n "$minutes Minute"; [ "1" = ${minutes} ] && echo -n ", " || echo -n "s, " )
[ "0" = ${seconds} ] || ( echo -n "$seconds Second"; [ "1" = ${seconds} ] && echo -n ", " || echo -n "s" )
echo
