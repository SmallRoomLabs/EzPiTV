#!/bin/bash

#   ________           _______     _    _________   ____   ____  
#  |_   __  |         |_   __ \   (_)  |  _   _  | |_  _| |_  _| 
#    | |_ \_|  ____     | |__) |  __   |_/ | | \_|   \ \   / /   
#    |  _| _  [_   ]    |  ___/  [  |      | |        \ \ / /    
#   _| |__/ |  .' /_   _| |_      | |     _| |_        \ ' /     
#  |________| [_____] |_____|    [___]   |_____|        \_/      
#                                                                                                                       

#
# CONFIGS
#

sheetURL="https://docs.google.com/spreadsheets/d/e/2PACX-1vQH4TEPWR08CdRiYE0DR5_bDOl36gbaE3uS-zZtloM7fSMP_99vSr3z5vHnTN9nIRM2PKlAtDCrCOtR/pub?output=tsv"


##############################################################################
# NO CHANGES BELOW THIS POINT SHOULD BE NECESSARY
##############################################################################

# Turn off blinking cursor
echo 0 | sudo tee -a /sys/class/graphics/fbcon/cursor_blink

# Turn off sleep mode
echo 0 | sudo tee -a  /sys/class/graphics/fb0/blank

# Needed for phantomjs since we're not running this in the FB console
export QT_QPA_PLATFORM=offscreen

# Define the name of the PID (locking) file
PIDFILE=/tmp/EzPiTV.pid

# Where to put working files
PREFIX=/tmp/EzPiTV

# Test if there's already a running instance of this script. If so, then 
# just exit, we don't want multiple instances running
if [ -f $PIDFILE ]
then
  PID=$(cat $PIDFILE)
  ps -p $PID > /dev/null 2>&1
  if [ $? -eq 0 ]
  then
    echo "Process already running"
    exit 1
  else
    echo $$ > $PIDFILE
  fi
else
  echo $$ > $PIDFILE
fi


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
		phantomjs render.js "$url" $PREFIX-$filename.ppm
		ppmto565/ppmto565 $PREFIX-$filename.ppm > /dev/fb0
	fi
done < <(curl -s $sheetURL; echo)

# Remove the PID file to allow this script to be invoked again
rm $PIDFILE
