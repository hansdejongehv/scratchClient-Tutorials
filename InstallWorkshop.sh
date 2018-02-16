#############
# 
# This script will install the workshop material.
# 
# Calling:
#	This script must be executed in-line. So call it in this way:
#	source ./InstallWorkshop.sh
#
# Input: 
#	none
#
# Output: 
#	none
#
# Author: Hans de Jong
#
##############


echo "##############"
echo "# Install the workshop material of the PiAndMore conference"
echo "# Github results in a less than optimal placement of files and names of directories, so"
echo "# that is also corrected here."
echo "##############"
cd ~/Weekendschool-PiAndMore-PiAndMore*
				# go into the directory where the material was unpacked into.
				# use a wildcard so that later releases do not require update
				# of this script.
mv README.md PiAndMore		# move the readme file into the subdirectory
rm -rf ~/PiAndMore		# erase the old directory if it is present
mv PiAndMore ~			# move the subdirectory to the home directory
# rm ../PiAndMore-*.tar.gz	# remove the archive file that was downloaded
# cp Install* ~/PiAndMore
				# copy the install scripts (including this script that is executed)
				# it will loose the executable property by this copy operation, but 
				# that is fine. It is only to be used for reference since the 
				# references to the paths would be wrong anyway.
cd ~/PiAndMore/ForHelpers
				# Go to the directory with scripts
chmod 744 *.bash


# Make the PiAndMore folder on the desktop
if [ -e ~/Desktop/PiAndMore ] ;
then
	echo "~/Desktop/PiAndMore already exists, no new directory created."
else
	mkdir ~/Desktop/PiAndMore	# make the working directory on the desktop
fi

# Copy the presentation to the desktop/PiAndMore folder and make it read only
cd /home/pi/PiAndMore/Part-1--Breadboard
cp PiAndMore.*.odp' ~/Desktop/PiAndMore
cp ForCopyPaste.txt ~/Desktop/PiAndMore
chmod 444 ~/Desktop/PiAndMore/*

# Copy the config file to the desktop


# Make a startup file and make it executable


# Copy the scratch sample program to the desktop

 


