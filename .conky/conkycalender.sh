#!/bin/bash
# conkycalender.sh
# by Crinos512
# Usage:
#  ${execp ~/.conky/conkyparts/conkycalender.sh}

DJS=`date +%_d`
Month=`date +'%B %Y'`

echo "$Month \${color1}\${hr 1}\${color}\${font saxMono,Tile:size=10}"
for i in {1..7}
do
    Text=`cal -h | sed '1d' | sed '/./!d' | sed 's/$/                     /' | sed -n '/^.\{21\}/p' | head -n $i | tail -n 1 | sed -n '/^.\{21\}/p' | sed 's/^/${alignc} /' | sed s/"Su Mo Tu We Th Fr Sa"/'\${color2}'"Su Mo Tu We Th Fr Sa"'\${color}'/ | sed /" $DJS "/s/" $DJS "/" "'${color2}'"$DJS"'${color}'" "/`
    if [ "$Text1" == "$Text" ]; then
		echo ""
		break
	else
		Text1=$Text
		echo "\${goto 125}$Text"
  	fi
done
echo "\${goto 170}\${font Digital Readout Thick Upright:size=30}\${time %H:%M}\${font}"

exit 0
