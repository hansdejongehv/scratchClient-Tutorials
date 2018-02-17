#!/bin/bash

# based on the work of fastrizwaan
# https://stackoverflow.com/questions/30931/register-file-extensions-mime-types-in-linux#31836

APP=$1
NAME="$2"
EXT="$3"
COMMENT="$APP's data file"
TERMINAL=$4
EXEC=$5
ICONDIR=$6
LOGOPREFIX=$7

# Create directories if missing
mkdir -p ~/.local/share/applications


# Create application desktop
echo "[Desktop Entry]
Name=$NAME
Exec=$EXEC %f
MimeType=application/x-$APP
Icon=$APP
Terminal=$TERMINAL
Type=Application
Categories=
Comment=
"> ~/.local/share/applications/$APP.desktop

# update databases for both application and mime
update-desktop-database ~/.local/share/applications
update-mime-database    ~/.local/share/mime

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