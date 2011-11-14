#!/bin/bash
# conkynetwork.sh
# by Crinos512
# Usage:
#  ${execp ~/.conky/conkyparts/conkynetwork.sh}
#

#echo "Network: (Internal: \${color2}\${addrs eth0}\${color}, External: \${color2}\${exec wget -q -O - checkip.dyndns.org | sed -e 's/[^[:digit:]|.]//g'}\${color}) \${color1}\${hr 1}\${color}"
echo "Network (\${color2}\${addrs eth0}\${color}) \${color1}\${hr 1}\${color}"
echo "\${downspeedgraph eth0 45,190 330000 ff0000} \${alignr}\${upspeedgraph eth0 45,190 003300 00ff00}"
echo "\${voffset -44}   Down\${goto 110}\${color2}\${downspeedf eth0} k/s \${color}\${goto 210} Up:\${goto 310}\${color2}\${upspeedf eth0} k/s\${color}"
echo "   Total Down:\${goto 110}\${color2}\${totaldown eth0}\${color}\${goto 210} Total Up:\${goto 310}\${color2}\${totalup eth0}\${color}"
echo "   Monthly Down:\${goto 110}\${color2}\${exec vnstat -m -i eth0 | grep \"`date +"%b '%y"`\" | awk '{print \$3 \$4}'}\${color}\${goto 210} Monthly Up:\${goto 310}\${color2}\${exec vnstat -m -i eth0 | grep \"`date +"%b '%y"`\" | awk '{print \$6 \$7}'}\${color}"
echo ""
exit 0
