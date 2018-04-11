#!/bin/bash

#############
# 
# This is the install script which will install the material of the 
# scratchClient-Tutorials project on the Raspberry Pi where this script is run.
#
# It will:
# - download and install the Arduino IDE, which is needed for
#   loading the scratchClient sketch in the Arduino Nano or Uno.
#   This is only done if it is not installed already.
# - put scratchClient at the right place. There is an option given to 
#   install a release that was tested with or the most recent version
#   from the internet site for scratchClient.
# - download and install the packages that scratchClient needs.
# - put the material of the PiAndMore workshop in a subfolder in the 
#   home directory and give the scripts execute permission.
# - Put sample files on the desktop
# - Put links to the tutorials on the desktop
#
# Author: Hans de Jong
# Date: 2 April 2018
#
##############

echo release=$release
if [ -z $release ] ;
then
	echo The variable  release  is not set
	exit
fi


thisdir=`pwd`	# Remember where the script is started to be able later to find the continuation scripts.
# echo $thisdir

# erase the .gz file that was used to download
# rm ../../*$release.tar.gz


InstallScratchClient="Yes"
if  [  -e ~/scratchClient ] ;
then
	PS3='----> scratchClient is already installed. Do you want to reinstall? Select 1 or 2. (Hit Enter to see the choices again).'
	select InstallScratchClient in Yes No
	do
		case $InstallScratchClient in
		Yes|No)	break ;;
		esac
	done
		
fi





case "$InstallScratchClient" in 
	Yes)
		#echo 'You can choose to install the tested release of scratchClient Do you want to install the latest release tested with this setup (Y, default), or'
		#echo 'do you want to take the most recent version of scratchClient from the internet (N)'
		#read -a InstallTestedScratchClient -p 'Y or N: '
		PS3='----> Which release of scratchClient do you want to install? (Hit Enter to see the choices again). '
		select InstallScratchClient in 'Tested release: Install the release of scratchClient that was tested with this package' 'Latest release: Install the latest release from the internet' 'Help me'
		do
			case "$InstallScratchClient" in
			Tested*|Latest*) break 
				;;
			Help*)
				echo "-"
				echo "- Although we try to make sure that next releases of scratchClient work with the current release"
				echo "- of this package (scratchClient Extensions / scratchClient Tutorials), it can be that you get"
				echo "- errors. Hence the safest is to install the tested release, however then you may miss out on"
				echo "- new features or fixes in the current release of scratchClient."
				echo "-"
			esac
		done
	;;
esac

# After this choice, the variable InstallScratchClient can have one of these values
# No					--> do not install scratchClient
# string starting with: Tested		--> install the tested version
# string starting with: Latest		--> install scratchClient from the internet

exit


cd $thisdir
source ./InstallScratchClient.sh

cd $thisdir
source ./InstallArduino.sh


cd $thisdir
source ./InstallExtAndTutorial.sh

cd $thisdir
#these scripts will be executed, so make sure this is possible
chmod 744 register*sh

./register_scratch1_icons.sh ~/scratchClientExtension/Icons

./register_scratch2_icons.sh ~/scratchClientExtension/Icons

./register_all_SC_mime.sh ~/scratchClientExtension/Icons

cp ~/scratchClientExtension/Examples/* ~/Desktop/

chmod 744 SetLinks.sh
./SetLinks.sh


cd $thisdir
#source ./InstallLes2.sh
				
echo "# FINAL CLEANUP"
				# remove the folder into which the material was unpacked.
				# note that this also deletes this install script, but since
				# that is the almost last line, it should not be a problem.
cd ..
echo rm -r . 

echo "=============================================================================="
echo "$ArduinoInstall"
echo "$IsScratchClientInstalled"
echo To see the newly installed icons you must reboot
echo "=============================================================================="
echo "Do you want to reboot now?"
read -a RebootNow -p 'Y or N: '
case "$RebootNow" in
	Y|y)
		reboot
	;;
	*)
		echo "You must manually reboot later"
	;;
esac
	

echo "Hit any key to close"
read

exit

# get keyboard input
# $1 = 
function getanswer()
{

}