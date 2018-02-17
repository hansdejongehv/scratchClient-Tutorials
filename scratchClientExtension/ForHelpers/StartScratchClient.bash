#!/bin/bash
pwd
echo ~
ls -l /dev/ttyUSB0 > /dev/null 2>&1
ret=$?
if [ "$ret" = "0" ]; 
then
	echo "starten op /dev/ttyUSB0"
	sudo python ~/scratchClient/src/scratchClient.py -c ~/Weekendschool/config_weekendschool_les2_ttyUSB0.xml
else
	ls -l /dev/ttyUSB1 > /dev/null 2>&1
	ret=$?
	if [ "$ret" = "0" ]; then
		echo "starten op /dev/ttyUSB1"
		sudo python ~/scratchClient/src/scratchClient.py -c ~/Weekendschool/config_weekendschool_les2_ttyUSB1.xml
	else
		ls -l /dev/ttyUSB2 > /dev/null 2>&1
		ret=$?
		if [ "$ret" = "0" ]; then
			echo "starten op /dev/ttyUSB2"
			sudo python ~/scratchClient/src/scratchClient.py -c ~/Weekendschool/config_weekendschool_les2_ttyUSB2.xml
	
		else
			echo "----> Arduino niet aangesloten" 
			read -p "Druk op ENTER om verder te gaan ..."
		fi
	fi
fi

