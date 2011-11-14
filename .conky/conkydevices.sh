#!/bin/sh
# conkydevices.sh
# by Crinos512
# Usage:
#  ${execp ~/.conky/conkyparts/conkydevices.sh}
#
SDAType=`hddtemp /dev/sda | cut -c11-21`
SDATemp=`hddtemp /dev/sda -n | xargs ~/.conky/colorize.sh`".0°C"
SDBType=`hddtemp /dev/sdb | cut -c11-31`
SDBTemp=`hddtemp /dev/sdb -n | xargs ~/.conky/colorize.sh`".0°C"

echo "File Systems \${color1}\${hr 1}\${color}"
echo "  /dev/sda ( $SDAType )\${goto 340}$SDATemp"
echo "    \${color3}\${fs_bar 10 /}\${color}"
echo "\${voffset -13}       /\${goto 250}\${fs_free /} (\${fs_free_perc /}%) free of \${fs_size /}"
echo "    \${color3}\${fs_bar 10 /boot}\${color}"
echo "\${voffset -13}       /boot\${goto 250}\${fs_free /boot} (\${fs_free_perc /boot}%) free of \${fs_size /boot}"
echo "    \${color3}\${fs_bar 10 /home}\${color}"
echo "\${voffset -13}       /home\${goto 250}\${fs_free /home} (\${fs_free_perc /home}%) free of \${fs_size /home}"
echo ""
echo "  /dev/sdb ( $SDBType )\${goto 340}$SDBTemp"
echo "    \${color3}\${fs_bar 10 /junkyard}\${color}"
echo "\${voffset -13}       /junkyard\${goto 250}\${fs_free /junkyard} (\${fs_free_perc /junkyard}%) free of \${fs_size /junkyard}"
echo ""

exit 0
