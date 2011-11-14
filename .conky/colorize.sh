#!/bin/sh
# colorize.sh
# by Crinos512
# Usage:
#  ${execpi 6 sensors | grep Core0 | paste -s | cut -c15-18 | xargs ~/.conky/colorize.sh} ... $color
#
# Note: Assign color7, color8, and color9 to COOL, WARM, and HOT respectively
#   your .conkyrc

COOL=40
WARM=50

if [[ $1 < $COOL ]]
then echo "\${color7}"$1    # COOL
elif [[ $1 > $WARM ]]
then echo "\${color9}"$1    # HOT
else echo "\${color8}"$1       # WARM
fi

exit 0
