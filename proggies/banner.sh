#!/bin/bash

echo -e "GET http://$1/$RANDOM HTTP/1.0\n\n" | nc $1 80 | grep Server:
