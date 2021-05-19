#!/bin/bash

# This file runs when a DM logs you into a graphical session.
function __volume {
    echo " $(amixer get Master | grep -o '\[[0-9]\+%\]' | sed 's/[^0-9]*//g;1q')%"
}

function __battery {
    echo " $(cat /sys/class/power_supply/BAT0/capacity)%"
}

function __date {
    echo " $(date +%F\ \ %T\ %Z)"
}

function __wifi {
    nmcli dev wifi | grep -E '^[*]' | awk -v q=' ' '{ print $3q$9}'
}
function __now_playing {
    if [ ! "$(now_playing)" -eq "" ]; then
        echo "$(now_playing) |"
    fi
}

nitrogen --set-auto ~/.local/share/dwm/atom.jpg &
dunst -config ~/.config/dunst/dunstrc &
xrdb ~/.Xresources &

# Statusbar
while true; do
    xsetroot -name "$(__now_playing) $(__wifi) | $(__volume) | $(__battery) | $(__date)"
    sleep 10s
done &
