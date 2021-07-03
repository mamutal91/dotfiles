#!/usr/bin/env bash

iconpath="/usr/share/icons/Papirus-Dark/32x32/devices"
icon="${iconpath}/camera.svg"

dir="$HOME/Images/Screenshots/"
if [[ ! -d $dir   ]]; then
  mkdir -p $dir
fi

date=$(date +"%m-%d-%Y-%H%M")

if [[ ${1} == "window" ]]; then
  img="$dir/window-$date.png"
  maim -s $img
  xclip -selection clipboard -t image/png -i $img
  notify-send -i $icon "Screenshot" "Cropped capture."
else
  img="$dir/full-$date.png"
  maim $img
  xclip -selection clipboard -t image/png -i $img
  notify-send -i $icon "Screenshot" "Fullscreen capture."
fi
