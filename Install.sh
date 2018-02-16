#!/bin/bash

thisdir=`pwd`	# Remember where the script is started to be able later to find the continuation scripts.
# echo $thisdir

# set -x
#############
# 
# This is the install script which will install the material of the 
# Weekendschool / scratchClient presentation and workshop on 
# a Raspberry Pi for Pi and More 10 in Trier on 24 June 2017.
#
# It will:
# - download and install the Arduino IDE 1.8.0, which is needed for
#   loading the scratchClient sketch in the Arduino Nano or Uno.
#   This is only done if it is not installed already.
# - put scratchClient at the right place. There is an option given to 
#   install a release that was tested with or the most recent version
#   from the internet site for scratchClient.
# - download and install the packages that scratchClient needs.
# - put the material of the PiAndMore workshop in a subfolder in the 
#   home directory and give the scripts execute permission.
#
# Author: Hans de Jong
#
##############

InstallScratchClient="Y"
if  [  -e ~/scratchClient ] ;
then
	echo '----> scratchClient is already installed. Do you want to reinstall (Y)'
	echo '      scratchClient or skip installation (default)?'
	read -a InstallScratchClient -p 'Y or N: '
fi


case "$InstallScratchClient" in 
	Y|y)
		echo 'Do you want to install the latest release tested with this setup (Y), or'
		echo 'do you want to take the most recent version of scratchClient from the internet (default)'
		read -a InstallTestedScratchClient -p 'Y or N: '
	;;
esac




cd $thisdir
source ./InstallScratchClient.sh

cd $thisdir
source ./InstallArduino.sh

cd $thisdir
source ./InstallWorkshop.sh

cd $thisdir
source ./InstallLes2.sh
				
echo "# FINAL CLEANUP"
				# remove the folder into which the material was unpacked.
				# note that this also deletes this install script, but since
				# that is the almost last line, it should not be a problem.
# rm -r ~/Weekendschool-PiAndMore-PiAndMore*

echo "=============================================================================="
echo "$ArduinoInstall"
echo "$IsScratchClientInstalled"
echo "=============================================================================="
echo "Hit any key to close"
read
