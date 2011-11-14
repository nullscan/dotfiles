#!/bin/sh
# conkymemory.sh
# by Crinos512
# Usage:
#  \${execp ~/.conky/conkyparts/conkymemory.sh}
#

echo "\${goto 7}\${memgraph 35,392 000033 4682B4}"
echo "\${voffset -54}"
echo "RAM Usage: \${color2}\$memperc%\${color}\${goto 225}\${color2}\$mem\${color} of \${color2}\$memmax\${color}"
echo "    Processes Loaded: \${color2}\$processes\${color}\${goto 225}Cached: \${color2}\$cached\${color}"
echo "    Processes Running: \${color2}\$running_processes\${color}\${goto 225}Buffers: \${color2}\$buffers\${color}"
echo "    \${color3}\$membar\${color}"
echo "Swap Usage: \${color2}\$swapperc%\${color}\${goto 225}\${color2}\$swap\${color} of \${color2}\$swapmax\${color}"
echo "    \${color3}\$swapbar\${color}"
echo ""

exit 0
