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
backupdir=$targetdir/ScratchPgms-Backup
inspectdir=~

# Look how many instances of the process are running. The 
# resulting count of the grep is one higher, because it will also match on 
# the arguments of the grep itself

ThisProc=$$
#echo ThisProc=$ThisProc

ThisFileName=`basename $0`
echo ThisFileName=$ThisFileName

#ps -ef | grep "/bin/bash $0"
ProcCount=`ps -ef | grep --count "/bin/bash $0"`
#echo ProcCount=$ProcCount
case $ProcCount in
0|1)	read -p "No match found on grep. Cannot occur. Hit enter to close"
	exit
	;;
2|3)	# only the grep and this process matches
	;;
*)	# the process already runs
	read -p "The process $ThisFileName is already running. Hit ENTER to continue."
	exit
	;;
esac
	


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

if [ -f /usr/bin/xdotool ] ;
then
	#echo bla
	xdotool search --name $ThisFileName windowminimize
	#xdotool search --name $ThisFileName 

	#xdotool search --name CleanUp-ScratchFiles.sh set_window --urgency 1
	#xdotool search --pid $ThisProc set_window --urgency 1
fi

LoopCount=0
ScratchPollMax=5
ScratchPollCurrent=$ScratchPollMax

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

		#echo ScratchPollCurrent=$ScratchPollCurrent

		if [ "$LoopCount" -ge "$ScratchPollCurrent" ] ;
		then
			LoopCount=0
			if [ -f /usr/bin/xdotool ] ;
			then
				ProcCountScratch1=`ps -ef | grep --count "/usr/lib/squeak/.*/usr/share/scratch/NuScratch"`
				ProcCountScratch2=`ps -ef | grep --count "/usr/lib/electron/electron /usr/lib/scratch2"`
				ProcCount=`expr $ProcCountScratch1 + $ProcCountScratch2`
				#echo -en "\r $ProcCount"
				case $ProcCount in
				0|1)	## Cannot happen
					;;
				2|3)	xdotool search --name $ThisFileName set_window --urgency 0 2>/dev/null
					echo -en "                                                                            \r" 
					ScratchPollCurrent=$ScratchPollMax	
					echo -en "  Good: There are running `expr $ProcCount - 2` instances of Scratch (1 or 2).\r"
					;;
	
				*)	xdotool search --name $ThisFileName set_window --urgency 1 2>/dev/null
					echo -en "  Error: There are running `expr $ProcCount - 2` instances of Scratch (1 or 2).\r"
					ScratchPollCurrent=1
					;;
				esac
			fi
		fi
		
		LoopCount=`expr $LoopCount + 1`
		#echo LoopCount=$LoopCount

	done
	# sleep a second to not use too much processing time
	sleep 1
done
