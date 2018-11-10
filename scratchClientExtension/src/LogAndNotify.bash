#!/bin/bash

function replace {
	msgline=`echo "$msgline" | sed -e "s/.*$1.*//"`

}

timestamp=`date "+%Y%m%d-%H%M%S"`
LogDir=/home/pi/.SCControlDir
LogComplete=$LogDir/CleanUpLogComplete-$timestamp.txt
LogRemain=$LogDir/CleanUpLogRemain-$timestamp.txt




while [ true ] 
do

	read msgline
	status=$?
	# test whether end of file reached
	if [ $status != 0 ]
	then
		exit
	fi

	echo "$msgline" >> $LogComplete

	#replace "There was an error connecting to Scratch 1.4"


	if [ "X$msgline" != X ] 
	then
		notify-send "$msgline"
		echo "$msgline" >> $LogRemain
	fi
done