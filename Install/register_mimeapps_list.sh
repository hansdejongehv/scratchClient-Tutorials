#!/bin/bash

MIMETYPE="application/x-$1"
PRIMEAPP="$1.desktop;"
SECONDAPP="$2.desktop;"
THIRDAPP="$3.desktop;"
MIMEAPPS_LIST_PATH=/home/pi/.config/mimeapps.list
MIMETYPE_ASSOCIATION_LINE="$PRIMEAPP$SECONDAPP$THIRDAPP"
tempfile=/tmp/mimeapps.list

if [ -f $MIMEAPPS_LIST_PATH ] 
then
	cat /home/pi/.config/mimeapps.list
	echo --------------------------------------------------
	
	sed -e "s%$MIMETYPE=.*%%" $MIMEAPPS_LIST_PATH |
	sed -e "s%\[Added Associations\]%[Added Associations]\n$MIMETYPE=$MIMETYPE_ASSOCIATION_LINE%" > $tempfile
	cat $tempfile
	mv $tempfile $MIMEAPPS_LIST_PATH 
	
	echo 2-----------------------------

else
	echo "[Added Associations]
$MIMETYPE=$MIMETYPE_ASSOCIATION_LINE" > $MIMEAPPS_LIST_PATH 

fi
