#!/bin/bash

IMG=/tmp/fontimage
fontimage -o $IMG "$1" && feh $IMG && rm -f $IMG
