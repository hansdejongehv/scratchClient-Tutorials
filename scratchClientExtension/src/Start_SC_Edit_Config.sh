#!/bin/bash

# test whether it is an arduino adapter
# If so, then start scratchClientConfig

# Make the desktop current, so that when a new file is produced, the directory to save will be the desktop by default.
cd /home/pi/Desktop



config_file="$1"
# echo "$config_file" > ~/Desktop/log.txt

# if the script is started without an argument then start scratchClient
if [ -z "$config_file" ] 
then
	java -jar ~/scratchClient/tools/scratchClientConfig.jar	
else

	grep adapter.arduino.UNO_Adapter "$config_file"
	if [ X$? == X0 ]
	then
		java -jar ~/scratchClient/tools/scratchClientConfig.jar "$config_file"
	else
		leafpad "$config_file"
	fi
fi





