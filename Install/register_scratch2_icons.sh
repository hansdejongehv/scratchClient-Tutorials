#!/bin/bash


# based on the work of fastrizwaan
# https://stackoverflow.com/questions/30931/register-file-extensions-mime-types-in-linux#31836

LOGOPREFIX=CatLogo
APP=scratch2
ICONDIR=$1

# copy associated icons to the icon folders
for resolution in 16 24 32 48 64 72 96 128 256 ;
do
	# echo $resolution
	iconfile=$LOGOPREFIX$resolution.png 
	iconpath=$ICONDIR/$iconfile
	if [ -e $iconpath ]
	then
		echo $iconpath
		# it is unclear which filenames must be in which directory, so to be sure, we put both filenames in
		destdir=/home/pi/.local/share/icons/hicolor/"$resolution"x"$resolution"/apps
		mkdir -p $destdir
		cp $iconpath $destdir/$APP.png
		cp $iconpath $destdir/application-x-$APP.png

		destdir=/home/pi/.local/share/icons/hicolor/"$resolution"x"$resolution"/mimetypes
		mkdir -p $destdir
		cp $iconpath $destdir/$APP.png
		cp $iconpath $destdir/application-x-$APP.png
	fi
done
