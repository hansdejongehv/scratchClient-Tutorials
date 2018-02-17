
#############
# 
# This script will install the Arduino IDE 1.8.0 if it is not installed already.
# 
# Calling:
#	This script must be executed in-line. So call it in this way:
#	source ./InstallArduino.sh
#
# Input: none
#
# Output: 
#	ArduinoInstall	Shell variable set to indicate whether it was installed or not.
#
# Author: Hans de Jong
#
##############

echo "##############"
echo "# Download and install Arduino 1.8.0"
echo "##############"
if [ -e ~/Arduino-1.8.0 ];
then
	echo "----> Arduino 1.8.0 already installed. Skipping reinstallation"
	echo "----> If Arduino 1.8.0 should be reinstalled, then remove "
	echo "      ~/Arduino-1.8.0"
	ArduinoInstall="Arduino was already installed, not reinstalled. To get it reinstalled, delete ~/Arduino-1.8.0 and rerun."
else
	cd ~				# go to the home directory
	mkdir Arduino-1.8.0		# make a directory for installing the Arduino IDE
	cd Arduino-1.8.0		# go in that directory
	wget https://downloads.arduino.cc/arduino-1.8.0-linuxarm.tar.xz
				# download the Arduino IDE
	tar xvJf arduino-1.8.0-linuxarm.tar.xz
				# unpack the Arduino IDE
	cd arduino-1.8.0/		# Go into the directory that was created as result of the unpacking
	./install.sh			# install the Arduino IDE
	rm ../arduino-1.8.0-linuxarm.tar.xz	# remove the downloaded package
	ArduinoInstall="Arduino 1.8.0 has been installed."
fi
##############

#read -p "Press Enter to continue"

