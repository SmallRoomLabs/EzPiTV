#!/bin/bash

export LC_ALL=C
cd /home/pi

file=/mnt/tmpfs/image.ppm
_dt=""
_mod=""

while true; do
  # If there's no file then try again a bit later
  if [ ! -f $file ]; then
    sleep 0.5
    continue
  fi

  # Get the modification time of the file for comparison
  mod=$(stat -c %Y $file)
  # Get the surrent hour and minutes for displaying the time
  dt=$(env TZ=CET date +%H:%M)

  # Have the file or time changed since last time?
  if [ "$dt" == "$_dt" ] && [ "$mod" == "$_mod" ]; then
    sleep 0.5
    continue
  fi

  # Yes, new info to display
  _mod=$mod
  _dt=$dt

  # Add the time to the image, convert to 556 and send to framebuffer
  convert -pointsize 60 -fill white \
          -stroke black -strokewidth 6 -draw "text 920,50 \"$dt\"" \
          -stroke none                 -draw "text 920,50 \"$dt\"" \
          $file - | ./ppmto565 > /dev/fb0
done
