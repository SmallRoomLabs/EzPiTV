#!/bin/bash

export LC_ALL=C
cd /home/pi

file=/mnt/tmpfs/image.ppm
_dt=""
_mod=""

while true; do
	dt=$(env TZ=CET date +%H:%M)
	mod=$(stat -c %Y $file)

	if [ "$dt" == "$_dt" ] && [ "$mod" == "$_mod" ]; then
		sleep 0.5
		continue
	fi

	_mod=$mod
	_dt=$dt

	convert -pointsize 60 -fill white \
        	-stroke black -strokewidth 6 -draw "text 920,50 \"$dt\"" \
        	-stroke none                 -draw "text 920,50 \"$dt\"" \
		$file - | ./ppmto565 > /dev/fb0
done
