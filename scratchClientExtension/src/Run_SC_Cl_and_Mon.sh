#!/bin/bash

#############
# 
# usage: Run_SC_Cl_and_Mon.sh configfile [showRPipage] [WaitForArduino]
#	 configfile:  		config file for scratchClient
#	 showRPipage: 		optional. Y or N (default). Whether or not to show the page 
#		      		that contains the link how to make the scratchClient extension
#		      		blocks visible in Scratch 2.
#	 WaitForArduino:	optional. If there is no Arduino connected although the config file says it should
#				then wait (W) or not (N) for it to appear.
#
# This script starts scratchClient and a browser to show the scratchClient
# monitor. It will use the config file passed as parameter
#
# It will monitor whether scratchClient gets really started within 4 seconds
# and if not, start it again.
# When it runs it will start the browser to look at the monitor page.
#
# Author: Hans de Jong
# Date:   2018-11-06
#
##############

ScratchClientCommand="python3.*scratchClient.py"				# string that will be used to pgrep whether scratchClient runs and in pkill to kill a potentially previous instance.
ScratchClientStatusDisplay="/bin/bash.*ScratchClientStatusDisplay.bash"		# same for the process that will be used to display notifications


ThisFile=`basename $0`

scratchClient_configfile="$1"
showRPipage=$2
WaitForArduino=$3
scratchClient=~/scratchClient/src/scratchClient.py

if [ -z "$scratchClient_configfile" ] ;
then
	echo "This script can only run when provided with an existing config file."
	echo
	echo "You probably started the tool from a menu, while it is designed to"
	echo "be started from the context menu that appears when right clicking"
	echo "on a config file."
	echo
	read -a answer -p "Hit enter to close."
	exit
fi

	
# test whether the config file is for Sonic Pi and in that case test whether Sonic Pi is running
# If it is not running then start it and wait, because it takes a considerable time to get running.
grep adapter.sonicpiAdapter.SonicPi_Adapter "$scratchClient_configfile" > /dev/null
SonicPiConfigFound=$?
# 0 = found, 1 = not found, 2 = error
# echo arduinoConfigFound=$arduinoConfigFound

if [ X$SonicPiConfigFound == X0 ] ;
then
	SonicPiPS=`ps | grep sonic-pi`
	if [ -z "$SonicPiPS" ] 
	then
		# start Sonic-Pi
		sonic-pi > /dev/null 2>&1 &
		echo "starting Sonic-Pi"
		waittime=40
		echo "This takes a while, hence count down from $waittime seconds"
		
		while [ $waittime != 0 ]
		do
			echo -n -e "\\r $waittime "
			waittime=`expr $waittime - 1`
			sleep 1
		done
		echo
		
	fi

fi

# test whether the config file is for Arduino and in that case test whether the port exists
grep adapter.arduino.UNO_Adapter "$scratchClient_configfile" > /dev/null
arduinoConfigFound=$?
# 0 = found, 1 = not found, 2 = error
# echo arduinoConfigFound=$arduinoConfigFound

if [ X$arduinoConfigFound == X0 ] ;
then
	# This must be updated for the case that there are multiple configs with multiple USB ports
	usbport=`grep serial.device "$1" `
 
	# echo $usbport
	# extract the USB port
	usbport=`echo $usbport | sed -e s/.*value=// -e "s%/>.*%%" -e s/\"//g `
	echo USB port needed for the Arduino = $usbport


	ls -l $usbport > /dev/null 2>&1
	ret=$?
	#echo eerste=$ret
	
	if [ $ret != 0 ] ; 
	then
		if [ X$WaitForArduino = XW ]
		then
			ret=1
			while [ $ret != 0 ] 
			do
				notify-send -u critical -t 100 "Geen Arduino" "De Arduino is niet aangesloten."				
				sleep 3
				ls -l $usbport > /dev/null 2>&1
				ret=$?	
				# echo tweede-$ret
					
			done		
			notify-send "ScratchClient gestart" "Gestart op $usbport"
			
		else
			echo "----> No Arduino connected to $usbport" 
			read -p "Press ENTER to continue ..."
			exit
		fi
	else
		notify-send "scratchClient started" "started on $usbport"
	fi

fi

# we only get here if the config file is not for Arduino or if it is for arduino and the specified port is found
echo "scratchClient uses config file: $scratchClient_configfile"
# print the version number
python3 $scratchClient -version

status=	
while [ "X$status" != X1 ]
do
	# first kill any running scratchClient process
	pkill -f "$ScratchClientCommand"
	sleep 1
	# pkill -f "$ScratchClientStatusDisplay"

	# Start scratchClient and continue the script in order to test whether the process actually runs
#	python3 $scratchClient -C "$scratchClient_configfile" > /home/pi/Desktop/stdout.txt 2>/home/pi/Desktop/stderr.txt & 
	( setsid python3 $scratchClient -C "$scratchClient_configfile" 2>&1 | setsid ~/scratchClientExtension/src/ScratchClientStatusDisplay.bash & )
	#SC_ProcessNum=$!
	#echo "Process of scratchClient = $SC_ProcessNum"
	sleep 4
	status=`pgrep -f -c "$ScratchClientCommand"`


	#status=`ps -ef | grep --count scratchClient.py`
	#ps -ef | grep scratchClient.py

	#status=`ps -h $SC_ProcessNum`
	#echo "status in the startup loop=$status"
	if [ "X$status" != X1 ] ;
	then
		echo "----->>> scratchClient was not successfully started, try again" 
	fi
done 
	
#echo "Process of the finally running instance of scratchClient = $SC_ProcessNum"

# Now start the browser (Chrome) in a separate session which will not close (hence setsid) when this script
# closes, otherwise potentially other tabs in Chrome will also close. 
if [ "X$showRPipage" == XY ] ;
then
	( setsid chromium-browser --window-position=1,1 --window-size=800,600 http://localhost:8080/scratch2/documentation/scratchClient.html > /home/pi/Desktop/stdout2.txt 2>/home/pi/Desktop/stderr2.txt & )
fi
( setsid chromium-browser --window-position=1,1 --window-size=800,600 http://localhost:8080/adapters > /dev/null 2>&1 & )

# echo "Status of Chromium start = $?"

sleep 8
#notify-send "voor minimize"
xdotool search --name "ScratchClient - Chromium" windowminimize > /dev/null 2>&1

#read -p bla
exit

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



