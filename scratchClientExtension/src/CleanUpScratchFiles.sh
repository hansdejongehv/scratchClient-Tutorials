#!/bin/bash

#############
# 
# This script deals with some anomalies of Scratch 2:
# - Files that use extension blocks will be saved as .sbx rather than .sb2
# - Files will by default stored in the home directory (/home/pi), regardless
#   of where the file was originally started from.
# - If filenames contain spaces, they will not be started up, but rather Scratch 2
#   in the default configuration.
#
# Hence this script will loop forever and do this:
# - Create a folder ScratchProgramsBackup on the desktop if it does not yet exist.
# - Every few seconds look whether there are any .sbx or .sb2 files in the home directory.
# - If such a file is found, then:
#   - Strip any spaces from the filename and set the extension to .sb2
#   - Move the file to the desktop, because for the purpose of the workshops / classes
#     the scratch files are located on the desktop.
#   - If a file with the same name already exists, copy this with a timestamp added
#     to the end of the filename to the backup folder that was created.
#     On purpose we copy the file to the backup directory rather than move it there,
#     so that we can move the new file in place rather than copy it in place since then
#     it the position in the target directory (e.g. the desktop) may be changed.
#
# Author: Hans de Jong
# Date:   2 April 2018
#
##############

targetdir=~/Desktop
backupdir=$targetdir/ScratchProgramsBackup
inspectdir=~

# Create the backup directory if not yet existing
if  [ ! -e $backupdir ];
then
	mkdir $backupdir
	echo "Created backup folder  $backupdir"
fi

echo "Now looping forever over  $inspectdir  and moving all .sbx or .sb2 files as"
echo ".sb2 files to  $targetdir."
echo "Any spaces in the filename will be removed."
echo "A file of the same name - if present there - will be moved to "
echo "$backupdir  with a timestamp appended."
echo

while [ true ]
do
	# Loop over all .sbx files and process them.
	for f in $inspectdir/*.sbx $inspectdir/*.sb2
	do
		#echo "voor dir check $f"
		if [ ! -d "$f" ] && [ -e "$f" ] ;
		then
			# echo f="$f"
			# remove extension .sbx and the folderpath
			case "$f" in 
			*.sbx)
				newname=`basename "$f" .sbx`
				;;
			*.sb2)
				newname=`basename "$f" .sb2`
				;;
			esac

			# echo newname=$newname
			# remove all spaces from the name
			newname=`echo "$newname" | sed -e 's/ //g'`
			# echo newname=$newname
			newnameWithExt="$newname.sb2"
	
			# test whether the new file name already exists in the targetdir. 
			# if so, move it to the backupdir
			if [ -e "$targetdir/$newnameWithExt" ] ;
			then
				timestamp=`date "+%Y%m%d-%H%M%S"`
				#echo $timestamp 
				timestampedName=$newname-$timestamp.sb2
				cp $targetdir/$newnameWithExt $backupdir/$timestampedName
				echo "moved  $targetdir/$newnameWithExt  to  $backupdir/$timestampedName"

			fi

			mv "$f" $targetdir/$newnameWithExt
			echo "moved  $f  to  $targetdir/$newnameWithExt"
		fi
	done
	# sleep a second to not use too much processing time
	sleep 1
done
