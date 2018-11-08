#!/bin/bash

function replace {
	msgline=`echo "$msgline" | sed -e "s/.*$1.*//"`

}

LogDir=/home/pi/.SCControlDir
LogComplete=$LogDir/LogComplete.txt
LogRemain=$LogDir/LogRemain.txt


everconnected=false
nowchanged=false
connected=false

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

	replace "There was an error connecting to Scratch 1.4"
	replace "Unterstuetzung fuer Netzwerksensoren einschalten"
	replace "Activate remote sensor connections"
	replace "tornado.access"
	replace "initiate shutdown from singletonIPC"
	replace "shutdown sequence started"
	replace "object has no attribute"
	replace "thread terminated"
	replace "no socket"
	replace "active threads MainThread"
	replace "active threads run_stateQueueHandler"
	replace "scratchClient terminated"

	oldmsgline=$msgline
	oldconnected=$connected
	oldeverconnected=$everconnected
	replace "UNO ident from arduino is empty, accepted"
	if [ "$oldmsgline" != "$msgline" ] 
	then
		connected=true
		everconnected=true
		nowchanged=true
		# notify-send -u critical "1 $oldeverconnected $oldconnected $connected $everconnected $nowchanged" "$oldmsgline"
	fi

	oldmsgline=$msgline
	replace "UNO: lost connection to arduino"
	if [ "$oldmsgline" != "$msgline" ] 
	then
		connected=false
		nowchanged=true
		# notify-send -u critical "2 $oldeverconnected $oldconnected $connected $everconnected $nowchanged" "$oldmsgline"
	fi

	oldmsgline=$msgline
	replace "connection established to arduino"
	if [ "$oldmsgline" != "$msgline" ] 
	then
		connected=true
		everconnected=true
		nowchanged=true
		# notify-send -u critical -t 60000 "3 $oldeverconnected $oldconnected $connected $everconnected $nowchanged" "$oldmsgline"
	fi

	oldmsgline=$msgline
	replace "CONNECTED: start() not handled"
	if [ "$oldmsgline" != "$msgline" ] 
	then
		notify-send -u low "Je was al verbonden" "Je hebt op de groene punt gedrukt, maar de verbinding was er al."
	fi


	oldmsgline=$msgline
	replace "WAIT_START: start() not handled"
	if [ "$oldmsgline" != "$msgline" ] 
	then
		notify-send "Arduino is er niet" "Je hebt op de groene punt gedrukt, maar de Arduino is niet aangesloten of nog niet gevonden."
	fi


	oldmsgline=$msgline
	replace "could not open port"
	if [ "$oldmsgline" != "$msgline" ] 
	then
		notify-send "Arduino is er niet" "Je hebt op de groene punt gedrukt, maar de Arduino is niet aangesloten of nog niet gevonden."
	fi


	oldmsgline=$msgline
	replace "received signal 15"
	if [ "$oldmsgline" != "$msgline" ] 
	then
		notify-send -u low "scratchClient stopt" "scratchClient wordt gestopt. Mogelijk omdat een nieuwe wordt gestart."
	fi



	if [ $nowchanged = true ]
	then
		nowchanged=false

		if [ X$oldeverconnected = Xfalse ] && [ X$connected = Xtrue ] && [ X$oldconnected = Xfalse ]
		then
			notify-send "Arduino" "Arduino aangesloten"
		fi

		if [ X$oldeverconnected = Xtrue ] && [ X$connected = Xtrue ] && [ X$oldconnected = Xfalse ]
		then
			notify-send -t 600000 "Arduino is er weer" "Arduino aangesloten"
		fi

		if [  X$connected = Xfalse ]
		then
			notify-send -t 600000 -u critical "Arduino kwijt" "Arduino is niet meer aangesloten"
		fi

	fi	

	if [ "X$msgline" != X ] 
	then
		notify-send "$msgline"
		echo "$msgline" >> $LogRemain
	fi
done