#!/bin/bash
: 'begin script'
## set -x                                       # used for debugging purposes only
##
## @(#) gettime.sh           this script will convert seconds to day(s), hour(s),
##                           minute(s) and second(s).
## programmer: mekanik
## revision:   1.0.0         script development started
## date:       20050120
##
## this program has been originally written by [mekanik [mekanik2600<a>yahoo.de]
##
## my disclaimer:
##   first of all, i am _NOT_ responsible for anything bad that might happen
##   because of this program...it doesn't do anything bad on my system, but
##   it is not my fault if it does something bad on your system...
##

## set the ${_time} variable from the $1
## positional parameter passed to the script
_time=$1


## check to ensure that at least one arg
## was passed to the script, if not then
## exit
if   [ $# != 1 ];then
     printf  >&2 "usage: `basename $0` <time in secs>\n"
     
     exit 99
fi


## check to ensure that the argument passed
## to the script contains only numeric chars
## if not then exit
`printf "$_time\n" | egrep "[^0-9]" 1>/dev/null 2>&1`
if   [ $? != 1 ];then
     printf "the arg passed to the script contains\n"
     printf "non-numerical characters, i'm exiting\n"
     exit 98
fi

## perform the seconds to day(s), hour(s)
## minute(s) and second(s) calculations
   _days=`printf "scale=0;$_time / 86400\n" | bc -l`
   _hours=`printf "scale=0;($_time / 3600) - ($_days * 24)\n"  | bc -l `
   _minutes=`printf "scale=0;($_time / 60) - ($_days * 1440) - ($_hours * 60)\n" | bc -l`
   _seconds=`printf "scale=0;$_time %% 60\n" | bc -l`

## print out the data calculated from the
## above equations
printf "${_days:-0}-Day(s)/${_hours:-0}-Hour(s)/"
printf "${_minutes:-0}-Minute(s)/${_seconds:-0}-Second(s)\n"

: 'end script'
