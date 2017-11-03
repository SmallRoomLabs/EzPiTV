#!/bin/bash

#
# CONFIGS
#

sheetURL="https://docs.google.com/spreadsheets/d/e/2PACX-1vQH4TEPWR08CdRiYE0DR5_bDOl36gbaE3uS-zZtloM7fSMP_99vSr3z5vHnTN9nIRM2PKlAtDCrCOtR/pub?output=tsv"


#
# START OF CODE 
#

#
export QT_QPA_PLATFORM=offscreen

# Retreive the list of slides to show
skip=1
IFS='' ; while read line ; do
	if [[ "$skip" -eq 1 ]]; then
		skip=0
		continue
	fi
	echo "$line" | hexdump -C
	active=$(echo "$line" | cut -f1)
	url=$(echo "$line" | cut -f2)
	comment=$(echo "$line" | cut -f3)
	if [[ $active == "Y" || $active == "y" ]]; then
		echo Handling $comment
		filename=$(echo "$url" | md5sum | awk '{print $1}')
		echo Filename $filename
		phantomjs render.js "$url" /tmp/EzPiTV-$filename.png
		sudo fbi -noverbose -nocomments -vt 1 -device /dev/fb0 /tmp/EzPiTV-$filename.png
	fi
done < <(curl -s $sheetURL; echo)
