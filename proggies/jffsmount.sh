#!/bin/bash

modprobe mtd
modprobe jffs2
modprobe mtdram
modprobe mtdchar
modprobe mtdblock
dd if=$1 of=/dev/mtd0

if [ ! -d /mnt/image ]; then
	mkdir /mnt/image/
fi
mount -t jffs2 /dev/mtdblock0 /mnt/image/
