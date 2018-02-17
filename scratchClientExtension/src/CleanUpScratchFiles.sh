#!/bin/bash

#############
# 
# This script deals with some anomalies of Scratch 2:
# - Files that use an extension will be saved as .sbx rather than .sb2
# - Files will by default stored in the home directory (/home/pi), regardless
#   of where the file was originally started from.
# - If filenames contain spaces, they will not be started up, but rather Scratch 2
#   in the default configuration.
#
# Hence this script will loop forever and do this:
# - Create a folder ScratchProgramsBackup on the desktop if it does not yet exist.
# - Every few seconds look whether there are any .sbx files in the home directory.
# - If such a file is found, then:
#   - Strip any spaces from the filename and change the extension to .sb2
#   - Move the file to the desktop, because for the purpose of the workshops / classes
#     the scratch files are located on the desktop.
#   - If a file with the same name already exists, copy this with a timestamp added
#     to the end of the filename to the backup folder that was created.
#     On purpose we do not move that one, since then the placement on the desktop 
#     may get changed.
#
# Author: Hans de Jong
# Date:   2018-01-27
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

echo "Now looping forever over  $inspectdir  and moving all .sbx files as"
echo ".sb2 files to  $targetdir."
echo "Any spaces in the filename will be removed."
echo "A file of the same name - if present there - will be moved to "
echo "$backupdir  with a timestamp appended."
echo

while [ true ]
do
	# Loop over all .sbx files and process them.
	for f in $inspectdir/*.sbx
	do
		#echo "voor dir check $f"
		if [ ! -d "$f" ] && [ -e "$f" ] ;
		then
			# echo f="$f"
			# remove extension .sbx and the folderpath
			newname=`basename "$f" .sbx`
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

				# wait for a second, so that there is some visual feedback that the 
				# move has happened
				#sleep 1
			fi

			mv "$f" $targetdir/$newnameWithExt
			echo "moved  $f  to  $targetdir/$newnameWithExt"
		fi
	done
	# sleep a second to not use too much processing time
	sleep 1
done
