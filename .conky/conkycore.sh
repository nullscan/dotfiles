#!/bin/sh
# conkycore.sh
# by Crinos512
# Usage:
#  ${execp ~/.conky/conkyparts/conkycore.sh}
#
Processor=`cat /proc/cpuinfo | grep "model name" | cut -c14-60 | head -n1`
Core1Temp=`sensors | grep "Core 0" | paste -s | cut -c15-18 | xargs ~/.conky/colorize.sh`"°C"
Core2Temp=`sensors | grep "Core 1" | paste -s | cut -c15-18 | xargs ~/.conky/colorize.sh`"°C"

echo "Core Systems \${color1}\${hr 1}\${color}"
echo "\${cpugraph cpu0 45,390 000033 4682B4}"
#echo "\${voffset -58}"
#echo " \${color2}$Processor\${color}"
#echo "  Core 0 (\${color2}\${cpu cpu1}%\${color})\${goto 150}..:: \${color2}\${freq_g cpu1}Ghz\${color} ::..\${goto 340}$Core1Temp\${color}"
#echo "  Core 1 (\${color2}\${cpu cpu2}%\${color})\${goto 150}..:: \${color2}\${freq_g cpu2}Ghz\${color} ::..\${goto 340}$Core2Temp\${color}"
#echo "\${goto 15}\${color3}\${cpubar}\${color}"

exit 0
