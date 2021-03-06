#!/bin/bash

#############
# 
# This script will install the workshop material.
# 
# Calling:
#	This script must be executed in-line. So call it in this way:
#	source ./InstallExtAndTutorial.sh
#
# Input: 
#	The current directory must be the Install directory
#
# Output: 
#	none
#
# Author: Hans de Jong
#
##############


echo "##############"
echo "# Install the extensions for scratchClient and the tutorials."
echo "# Github results in a less than optimal placement of files and names of directories, so"
echo "# that is also corrected here."
echo "##############"
cd ..
				# go into the directory where the material was unpacked into.
				# use a wildcard so that later releases do not require update
				# of this script.
				
# now copy the README.md and the LICENSE files into both target directories
cp README.md scratchClientExtension/
cp README.md scratchClientTutorial/
cp LICENSE scratchClientExtension/
cp LICENSE scratchClientTutorial/

rm -rf ~/scratchClientExtension		# erase the old directory if it is present
rm -rf ~/scratchClientTutorial		# erase the old directory if it is present
mv scratchClientExtension ~			# move the subdirectory to the home directory
mv scratchClientTutorial ~			# move the subdirectory to the home directory
# rm ../PiAndMore-*.tar.gz	# remove the archive file that was downloaded

# cd ~/PiAndMore/ForHelpers
				# Go to the directory with scripts
cd ~/scratchClientExtension/src
chmod 744 *.sh


# Make the PiAndMore folder on the desktop


# Copy the config file to the desktop


# Make a startup file and make it executable


# Copy the scratch sample program to the desktop

 


