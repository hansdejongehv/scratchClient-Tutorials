#!/bin/bash

# test whether it is an arduino adapter
# If so, then start scratchClientConfig

# Make the desktop current, because scratchClientConfig forgets the current name of the file.
# It makes it simpler if then the folder is already correct.
cd /home/pi/Desktop

grep adapter.arduino.UNO_Adapter "$1"
if [ X$? == X0 ]
then
	java -jar ~/scratchClient/tools/scratchClientConfig.jar "$1"
else
	leafpad "$1"
fi






