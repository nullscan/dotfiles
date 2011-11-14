#!/bin/bash
# wallpaper
#eval `cat ~/.fehbg` &
nitrogen --restore &
# conky configs
sleep 1 && conky &
sleep 1 && conky -c /home/jpoly/.conkyrc3 &
# album cover in conky for now playing mp3 via mpd
nohup python /home/jpoly/.conky/mpd_infos.py &
# tint2 bar
sleep 1 && tint2 -c /home/jpoly/.config/tint2/tint2rc2 &
# composite manager, fast settings
xcompmgr -c -f -n &
# numlock on at login
numlockx &
# make mouse pointer dissapear after 5sec idle
unclutter -idle 5 -root &
# mouse sensitivity
xset m 5/2 3 &
# get extra keybord keys to work
xmodmap ~/.Xmodmap &
xbindkeys &
# start synergy server
synergys &
# screen locking
gnome-screensaver &
