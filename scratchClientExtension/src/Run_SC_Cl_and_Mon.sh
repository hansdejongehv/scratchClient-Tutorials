#!/bin/bash

#############
# 
# usage: Start_SC_Cl_and_Mon.sh configfile [showRPipage]
#	 configfile:  config file for scratchClient
#	 showRPipage: optional. Y or N (default). Whether or not to show the page 
#		      that contains the link how to make the scratchClient extension
#		      blocks visible in Scratch 2.
#
# This script starts scratchClient and a browser to show the scratchClient
# monitor. It will use the config file passed as parameter
#
# It will monitor whether scratchClient gets really started within 4 seconds
# and if not, start it again.
# When it runs it will start the browser to look at the monitor page.
#
# Author: Hans de Jong
# Date:   2018-02-04
#
##############


scratchClient_configfile=$1
showRPipage=$2
scratchClient=~/scratchClient/src/scratchClient.py

if [ X$scratchClient_configfile == X ] ;
then
	echo "$0 was started without parameters. "
	echo "usage: $0 configfile [showRPipage]"
	read -p "Press ENTER to exit ..."
	exit
fi

# test whether the config file is for Arduino and in that case test whether the port exists
grep adapter.arduino.UNO_Adapter "$1" > /dev/null
arduinoConfigFound=$?
# 0 = found, 1 = not found, 2 = error
# echo arduinoConfigFound=$arduinoConfigFound

if [ X$arduinoConfigFound == X0 ] ;
then
	# This must be updated for the case that there are multiple configs with multiple USB ports
	usbport=`grep serial.device "$1" `
 
	echo $usbport
	# extract the USB port
	usbport=`echo $usbport | sed -e s/.*value=// -e "s%/>.*%%" -e s/\"//g `
	echo $usbport


	ls -l $usbport > /dev/null 2>&1
	ret=$?
	echo $ret
	
	if [ $ret != 0 ] ; 
	then
		echo "----> No Arduino connected to $usbport" 
		read -p "Press ENTER to continue ..."
		exit
	else
		echo "scratchClient gets started on $usbport"
	fi

fi

# we only get here if the config file is not for Arduino or if it is for arduino and the specified port is found
echo "scratchClient uses config file: $scratchClient_configfile"
# print the version number
python3 $scratchClient -version

status=	
while [ "X$status" == X ]
do
	# Start scratchClient and continue to test whether the process actually runs
	python3 $scratchClient -C $scratchClient_configfile & 
	SC_ProcessNum=$!
	echo "Process of scratchClient = $SC_ProcessNum"
	sleep 4
	status=`ps -h $SC_ProcessNum`
	# echo "status in the startup loop=$status"
	if [ "X$status" == X ] ;
	then
		echo "----->>> scratchClient was not successfully started, try again" 
	fi
done 
	
echo "Process of the finally running instance of scratchClient = $SC_ProcessNum"

# Now start the browser (Chrome) in a separate session which will not close (hence setsid) when this script
# closes, otherwise potentially other tabs in Chrome will also close. 
if [ "X$showRPipage" == XY ] ;
then
	( setsid chromium-browser --window-position=1,1 --window-size=800,600 http://localhost:8080/scratch2/documentation/scratchClient.html & )
fi
( setsid chromium-browser --window-position=1,1 --window-size=800,600 http://localhost:8080/adapters & )

# echo "Status of Chromium start = $?"

# now run an infinite loop that every 10 seconds tests whether scratchClient still runs and if not exit
# this process. If we would exit now, also scratchClient would stop. 
# The continuous testing is needed to prevent that if scratchClient stops, e.g. because a new instance
# of it is started, this process will not hang forever.
while [ true ]
do
	sleep 10
	status=`ps -h $SC_ProcessNum`
	#echo status=$status
	if [ "X$status" == X ] ;
	then
		#echo "Nu is status: $status"
		#ps -h $SC_ProcessNum
		echo "Exiting the $0 script because the instance of scratchClient no longer runs."
		# wait a bit so that the final message can still be read
		sleep 3
		exit
	fi

done



