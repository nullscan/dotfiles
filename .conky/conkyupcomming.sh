#!/bin/bash

if [ `when --past=0 --wrap=71 m | tail -n +3 | wc -l` -eq 0 ]; then
	COMMING="Nothing for the next 30 days"
else
	COMMING=`when --past=0 --wrap=75 m | tail -n +3`
fi

echo "Upcomming \${color1}\${hr 1}\${color}"
echo "\${font MonteCarlo:size=11}\${color2}$COMMING\${color}\${font}"
echo ""

exit 0

