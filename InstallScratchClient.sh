#############
# 
# This script will install the scratchClient unless directed not to do so.
# 
# Calling:
#	This script must be executed in-line. So call it in this way:
#	source ./InstallScratchClient.sh
#
# Input: 
#	InstallScratchClient
#		Y or y			Delete the current scratchClient directory (if present)
#					and (re-)install scratchClient
#		any other value		Skip the installation
#	InstallTestedScratchClient	
#		Y or y			Install the scratchClient from the distribution
#		any other value		Install the scratchClient from the Internet site
#
# Output: 
#	IsScratchClientInstalled	Shell variable set to indicate whether it was installed or not.
#
# Author: Hans de Jong
#
##############


echo "InstallScratchClient=$InstallScratchClient"

case "$InstallScratchClient" in

	Y|y)
		echo "##############"
		echo "# Put scratchClient at the right place and install required packages"
		echo "##############"

		if  [  -e ~/scratchClient ] ; 
		then 
			sudo rm -r ~/scratchClient 
		fi

		cd ~				# go to the home directory
		echo "InstallTestedScratchClient=$InstallTestedScratchClient"

		rm -f ~/scratchClient.tar.gz*
		case "$InstallTestedScratchClient" in
		Y|y)
			
			cp ~/Weekendschool-PiAndMore-PiAndMore*/PiAndMore/scratchClient/scratchClient.tar.gz .
			# copy the tested scratchClient
			IsScratchClientInstalled="scratchClient was installed from the tested version."
		;;
		*)
			wget http://heppg.de/ikg/administration/pi/scratchClient/download/scratchClient.tar.gz
			# download scratchClient
			IsScratchClientInstalled="scratchClient was installed from the downloaded internet version."
		;;
		esac

		tar xzf ~/scratchClient.tar.gz	# unpack scratchClient
		chmod +r -R scratchClient/	# set read permission on the entire tree
		rm ~/scratchClient.tar.gz		
		# Cleanup: remove the downloaded or copied archive

		sudo apt-get update		# update Raspian
		sudo apt-get install python-pip python-dev
				# get install packages that scratchClient needs ...
		sudo pip install cherrypy routes mako ws4py spidev
				# ... and the same for the rest of the needed packages.
	;;

	*)	IsScratchClientInstalled="scratchClient was already present and not reinstalled."
	;;

esac

#read -p "hit enter"