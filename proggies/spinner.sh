#!/bin/bash

sp="/-\|"
sc=0
i=0
spin() {
   printf "%s\b" "${sp:sc++:1}"
   ((sc==${#sp})) && sc=0
}
endspin() {
   printf "%s\n" "$@"
}
while [ $i -lt "5" ]; do
	spin 
	(( i = $i + 1 ))
	sleep 1
done
endspin done
