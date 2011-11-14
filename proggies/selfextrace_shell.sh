#!/bin/bash
#sed -e '1,/^exit$/d' "$1" | tar xzf -
sed -e '1,/^exit $returnCode/d' "$1" > mpe
exit
