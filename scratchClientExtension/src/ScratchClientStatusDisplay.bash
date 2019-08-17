#!/bin/bash

function replace {
	msgline=`echo "$msgline" | sed -e "s/.*$1.*//"`

}

timestamp=`date "+%Y%m%d-%H%M%S"`
LogDir=/home/pi/.SCControlDir
LogComplete=$LogDir/SCLogComplete-$timestamp.txt
LogRemain=$LogDir/SCLogRemain-$timestamp.txt



#----------------------------------------------------------------------------------------------------------------
#string definitions for multiple languages. Default is English. They can be overwritten dependent on the language
#----------------------------------------------------------------------------------------------------------------
AlreadyConnectedTitle="Already connected"
AlreadyConnectednBody="You pressed the green dot, but the connection already existed."
NoArduinoTitle="No Arduino"
NoArduinoBody="You pressed the green button, but the Arduino is not yet connected or was not yet found."
ScratchClientStopsTitle="scratchClient stops"
ScratchClientStopsBody="scratchClient is stopped. Potentially because a new one is started."
ArduinoConnectedTitle="Arduino connected"
ArduinoConnectedBody="Arduino was connected."
ArduinoLostTitle="Arduino lost"
ArduinoLostBody="Arduino is no longer connected."
ArduinoAgainTitle="Arduino is back"
ArduinoAgainBody="Arduino is connected again."


if [ ${LANG:0:2} = nl ]
then
	AlreadyConnectedTitle="Je was al verbonden"
	AlreadyConnectednBody="Je hebt op de groene punt gedrukt, maar de verbinding was er al."
	NoArduinoTitle="Arduino is er niet"
	NoArduinoBody="Je hebt op de groene punt gedrukt, maar de Arduino is niet aangesloten of nog niet gevonden."
	ScratchClientStopsTitle="scratchClient stopt"
	ScratchClientStopsBody="scratchClient wordt gestopt. Mogelijk omdat een nieuwe wordt gestart."
	ArduinoConnectedTitle="Arduino aangesloten"
	ArduinoConnectedBody="Arduino is aangesloten."
	ArduinoLostTitle="Arduino kwijt"
	ArduinoLostBody="Arduino is niet meer aangesloten."
	ArduinoAgainTitle="Arduino is er weer"
	ArduinoAgainBody="Arduino is weer aangesloten."

fi

if [ ${LANG:0:2} = de ]
then
	AlreadyConnectedTitle="Schon verbunden"
	AlreadyConnectednBody="Sie haben den grünen Punkt gedrückt, aber die Verbindung bestand bereits."
	NoArduinoTitle="Kein Arduino"
	NoArduinoBody="Sie haben die grüne Taste gedrückt, aber das Arduino ist noch nicht verbunden oder wurde noch nicht gefunden."
	ScratchClientStopsTitle="scratchClient wird angehalten"
	ScratchClientStopsBody="scratchClient wird gestoppt. Möglicherweise weil ein neuer gestartet wird."
	ArduinoConnectedTitle="Arduino verbunden"
	ArduinoConnectedBody="Arduino war verbunden."
	ArduinoLostTitle="Arduino ist verloren"
	ArduinoLostBody="Arduino ist nicht mehr verbunden."
	ArduinoAgainTitle="Arduino ist zurück"
	ArduinoAgainBody="Arduino ist wieder verbunden."
fi






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
	replace "No Mesh session at host"

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
		notify-send -u low "$AlreadyConnectedTitle" "$AlreadyConnectednBody"
	fi


	oldmsgline=$msgline
	replace "WAIT_START: start() not handled"
	if [ "$oldmsgline" != "$msgline" ] 
	then
		notify-send "$NoArduinoTitle" "$NoArduinoBody"
	fi


	oldmsgline=$msgline
	replace "could not open port"
	if [ "$oldmsgline" != "$msgline" ] 
	then
		notify-send "$NoArduinoTitle" "$NoArduinoBody"
	fi


	oldmsgline=$msgline
	replace "received signal 15"
	if [ "$oldmsgline" != "$msgline" ] 
	then
		notify-send -u low "$ScratchClientStopsTitle" "$ScratchClientStopsBody"
	fi


	



	if [ $nowchanged = true ]
	then
		nowchanged=false

		if [ X$oldeverconnected = Xfalse ] && [ X$connected = Xtrue ] && [ X$oldconnected = Xfalse ]
		then
			notify-send "$ArduinoConnectedTitle" "$ArduinoConnectedBody"
		fi

		if [ X$oldeverconnected = Xtrue ] && [ X$connected = Xtrue ] && [ X$oldconnected = Xfalse ]
		then
			notify-send -t 600000 "$ArduinoAgainTitle" "$ArduinoAgainBody"
		fi

		if [  X$connected = Xfalse ]
		then
			notify-send -t 600000 -u critical "$ArduinoLostTitle" "$ArduinoLostBody"
		fi

	fi	

	if [ "X$msgline" != X ] 
	then
		notify-send "$msgline"
		echo "$msgline" >> $LogRemain
	fi
done