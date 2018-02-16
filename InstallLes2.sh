#############
# 
# This script will install the Les 2 of the Weekendschool Programming curriculum
# 
# Calling:
#	This script must be executed in-line. So call it in this way:
#	source ./InstallLes2.sh
#

# Output: 
#	IsScratchClientInstalled	Shell variable set to indicate whether it was installed or not.
#
# Author: Hans de Jong
#
##############




if  [  -e ~/Weekendschool/Les_2 ] ; 
then 
	sudo rm -r ~/Weekendschool/Les_2
fi


release=1.0.3
		
cd ~ # go to the home folder
rm -rf $release.tar.gz*
wget https://github.com/hansdejongehv/Weekendschool-Programmeren-Programming/archive/$release.tar.gz # download the archive
tar xzf $release.tar.gz # unpack the archive.

mv ~/Weekendschool-Programmeren-Programming-$release/LICENSE ~/Weekendschool-Programmeren-Programming-$release/Les_2
mv ~/Weekendschool-Programmeren-Programming-$release/README.md ~/Weekendschool-Programmeren-Programming-$release/Les_2

if [ -e ~/Weekendschool ] ;
then
	echo Directory "~/Weekendschool not created because it already exists"
else
	mkdir ~/Weekendschool
fi

mv ~/Weekendschool-Programmeren-Programming-$release/Les_2 ~/Weekendschool

chmod 744 ~/Weekendschool/Les_2/StartScratchClient.bash





read -p "hit enter"