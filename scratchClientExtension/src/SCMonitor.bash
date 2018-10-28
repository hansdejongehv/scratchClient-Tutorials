#!/bin/bash

# Parameters that you might want to adapt 
ScriptLocation=$HOME/Desktop/Begeleider/
ScratchPollMax=5			# Normal poll time in seconds
ScratchPollFast=3			# If something was detected, the scrolling will be intensified. Poll time in seconds
NotifyTimeMultiScratchOpen=100		# Time that the notification for multiple opened Scratch file must be displayed in 
					# milliseconds. It must be off before the next check, so that it looks like flashing.
NotifyTimeNoScratchClient=100		# Time that the notification for no scratchClient must be displayed in 
					# milliseconds. It must be off before the next check, so that it looks like flashing.
NotifyTimeSaveAlarm=100			# Time that the alarm notification must be displayed in 
					# milliseconds. It must be off before the next check, so that it looks like flashing.
SaveWarningTime=420			# Time in seconds after which a warning will be given if the Scratch file is not saved.
SaveAlarmTime=600			# Time in seconds after which an alarm will be given if the Scratch file is not saved.
ScratchClientCommand="/bin/bash /home/pi/scratchClientExtension/src/Run_SC_Cl_and_Mon.sh"	# string that will be used to grep 
												# whether scratchClient runs.

# The intent is that the warning for saving will stay on till the alarm is going to be displayed. 
# Hence we take the time between the two numbers and do it times 1000 to convert seconds to milliseconds. 

NotifyTimeSaveWarning=`expr \( $SaveAlarmTime - $SaveWarningTime \) \* 1000`
# notify-send -u low "NotifyTimeSaveWarning = $NotifyTimeSaveWarning"

ThisFileName=`basename $0`
HOME=/home/pi
FullPath=$ScriptLocation/$ThisFileName

#env > $HOME/env

echo FullPath=$FullPath

#############
# 
# This script deals with some anomalies of Scratch 2:
# - Files that use extension blocks will be saved as .sbx rather than .sb2
# - Files will by default stored in the home directory (/home/pi), regardless
#   of where the file was originally started from.
# - If filenames contain spaces, they will not be started up, but rather Scratch 2
#   in the default configuration.
#
# Further it will warn via notify-send in case
# - Scratch is running but has not been saved for a certain amount of time.
#	It determines this that there has been no .sb2 or .sbx file in the HOME directory for a certain
#	amount of time after Scratch was started or after that the last time something was saved.
# - It will do the above with first giving a message but after nothing was saved for 
#   another configurable amount of time it will start effectively blinking a stronger message.
# - ScratchClient ought to be running (as determined by the file .SCMandatory being present on the desktop)
#   	If .SCMandatory is not present, then the script will look into the Scratch program that was started
#	by unzipping it and looking whether project.json contans the string scratchClient.js.
# - If scratchClient is running, then it warns when more than one instance of Scratch is open.
#
# 
# Finally, when started from the terminal, it will ask whether the starting should be configured into crontab
# so that the script will be started automatically at login
# It will then also determine whether notify-send already works, or whether it should install notify-send and dunst as well 
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
#     the position in the target directory (e.g. the desktop) may be changed.
#
#
# Parameters
#
# .SCMandatory file being present on the desktop
#	If present, then warn if scratchClient is not running and warn if more than one
#	Scratch instance is running
#
# Author: Hans de Jong
# Date:   14 October 2018
#
##############

targetdir=$HOME/Desktop
backupdir=$targetdir/ScratchPgms-Backup
inspectdir=$HOME
SCMandatory=$targetdir/.SCMandatory



# Determine whether the process is running from cron. For that the variable DESKTOP_SESSION is used.
# When started from cron, no messages will be given in the terminal window.

if [ "X$DESKTOP_SESSION" = X ];
then 
	ExecedFromCron=True
else
	ExecedFromCron=False
fi
#notify-send -u low "ExecedFromCron = "$ExecedFromCron


# Look how many instances of the process are running. The 
# resulting count of the grep is two higher, because it will also match on 
# the arguments of the grep itself and the command between ` and ` will also generate one higher


#ps -ef | grep "/bin/bash $0"
ProcCount=`ps -ef | grep --count "/bin/bash $0"`
#echo ProcCount=$ProcCount
#Processes=`ps -ef | grep "/bin/bash $0"`
#ps -ef | grep "/bin/bash $0" > /home/pi/test1
#echo $Processes > /home/pi/Processes


case $ProcCount in
0|1|2)	# It is not possible. Because this script is running and the command started between ` and ` as well as grep,
	# so the value must at least be 3.
	if [ $ExecedFromCron = False ]; 
	then
		read -p "ProcCount=$ProcCount found on grep. Cannot occur. Hit enter to close"
	fi
	exit
	;;
3)	# only the grep and this process, plus the command between ` and ` matches
	# so the task did not yet run and the current task will continue running
	;;
*)	# the process already runs
	if [ $ExecedFromCron = False ]; 
	then
		read -p "The process $ThisFileName is already running. Hit ENTER to continue."
	fi
	# notify-send -u low "ProcCount = $ProcCount, therefore stop" 
	exit
	;;
esac

notify-send -u low "ProcCount = $ProcCount, therefore continue" 


AlreadyInCronTab=`crontab -l 2>/dev/null | grep "$ThisFileName" `
if [ "X$AlreadyInCronTab" = X ] ;
then
	# this process is not started by cron (either crontab not present, or no line for this script)
	read -p "Do you want to automatically start this script at bootup?" PutInCronTab
	echo $PutInCronTab
	if [ X$PutInCronTab = XY ] || [ X$PutInCronTab = Xy ] ;
	then
		crontab -l 2>/dev/null > /tmp/cronpi
		echo "* * * * * DISPLAY=:0.0 $FullPath" >> /tmp/cronpi
		crontab < /tmp/cronpi
	fi
fi




#----------------------------------------------------------------------------------------------------------------
#string definitions for multiple languages. Default is English. They can be overwritten dependent on the language
#----------------------------------------------------------------------------------------------------------------
MultiScratchOpenTitle="Too many Scratch open"
MultiScratchOpenBody="You have %d instances of Scratch running. Only one allowed."	# %d = number of open Scratch instances
MultiScratchOpenSCRunningTitle="Too many Scratch open"
MultiScratchOpenSCRunningBody="You have %d instances of Scratch running while also scratchClient is running. Only one instance allowed in combination with scratchClient."	# %d = number of open Scratch instances
NoScratchClientTitle="No scratchClient"
NoScratchClientBody="There is no scratchClient running"
SaveHintTitle="Remember to save"
SaveHintBody="You have not saved your Scratch program for a while"
SaveUrgentTitle="Save Scratch program"
SaveUrgentTitle="You have not saved your program for %d minutes. Everything will be lost when the computer crashes"


if [ ${LANG:0:2}=nl ]
then
	MultiScratchOpenTitle="Teveel Scratch open"
	MultiScratchOpenBody="Scratch draait %d keer. Mag slechts 1x."	# %d = number of open Scratch instances
	MultiScratchOpenSCRunningTitle="Teveel Scratch open"
	MultiScratchOpenSCRunningBody="Scratch draait %d keer terwijl scratchClient ook loopt. Mag slechts 1x als scratchClient draait."	# %d = number of open Scratch instances
	NoScratchClientTitle="Geen scratchClient"
	NoScratchClientBody="scratchClient draait niet."
	SaveHintTitle="Bedenk om op te slaan"
	SaveHintBody="Je hebt je Scratch programma al een tijdje niet opgeslagen."
	SaveUrgentTitle="Sla je Scratch programma op!"
	SaveUrgentBody="Je hebt je programma al %d minuten niet opgeslagen. Je bent alles kwijt als de de computer struikelt."
fi

if [ ${LANG:0:2}=de ]
then
	MultiScratchOpenTitle="Zuviel Scratch offen"
	MultiScratchOpenBody="Scratch dreht %d mal. Darf nur 1x."	# %d = number of open Scratch instances
	MultiScratchOpenSCRunningTitle="Zuviel Scratch offen"
	MultiScratchOpenSCRunningBody="Scratch dreht %d mal waehrend scratchClient auch dreht. Darf nur 1x als scratchClient dreht."	# %d = number of open Scratch instances
	NoScratchClientTitle="Kein scratchClient"
	NoScratchClientBody="scratchClient dreht nicht"
	SaveHintTitle="Denke daran zu speichern"
	SaveHintBody="Das Scratch Programm ist schon eine Weile nicht gespeichert"
	SaveUrgentTitle="Scratch Programm speichern!"
	SaveUrgentBody="Das Scratch Programm ist schon %d Minuten nicht gespeichert. Alles geht verloren als der Rechner nun runterfaehrt."
fi

# Create the backup directory if not yet existing
if  [ ! -e $backupdir ];
then
	mkdir $backupdir
	echo "Created backup folder  $backupdir"
fi

if [ $ExecedFromCron = False ]; 
then
	echo "Now looping forever over  $inspectdir  and moving all .sbx or .sb2 files as"
	echo ".sb2 files to  $targetdir."
	echo "Any spaces in the filename will be removed."
	echo "A file of the same name - if present there - will be moved to "
	echo "$backupdir  with a timestamp appended."
	echo
fi

StartSaveWarn=0

LoopCount=$ScratchPollMax 		# make sure that after start there is directly done a check.

ScratchPollCurrent=$ScratchPollMax
NotSavedTime=0

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
				NotSavedTime=0			# saving has happened, so reset counter
				CachedScratchFileName=		# the saved filechecking must not be bypassed based on the cache, so reset the cache
				;;
			*.sb2)
				newname=`basename "$f" .sb2`
				NotSavedTime=0   		# saving has happened, so reset counter
				CachedScratchFileName=		# the saved filechecking must not be bypassed based on the cache, so reset the cache
				;;
			esac

			# echo newname=$newname
			# remove all spaces from the name
			newname=`echo "$newname" | sed -e 's/ //g'`
			# echo newname=$newname
			newnameWithExt="$newname.sb2"
	
			# test whether the new file name already exists in the targetdir. 
			# if so, copy it to the backupdir with a timestamp added.
			if [ -e "$targetdir/$newnameWithExt" ] ;
			then
				timestamp=`date "+%Y%m%d-%H%M%S"`
				#echo $timestamp 
				timestampedName=$newname-$timestamp.sb2
				cp $targetdir/$newnameWithExt $backupdir/$timestampedName
				if [ $ExecedFromCron = False ]; 
				then
					echo "copied  $targetdir/$newnameWithExt  to  $backupdir/$timestampedName"
				fi

			fi

			mv "$f" $targetdir/$newnameWithExt
			if [ $ExecedFromCron = False ]; 
			then			
				echo "moved  $f  to  $targetdir/$newnameWithExt"
			fi
		fi
	done


	if [ "$NotSavedTime" = "$SaveWarningTime" ] ;
	then
		StartSaveWarn=1			# set the flag that a warning to save the file must be given (warning, not yet an alarm)
	fi

	#echo ScratchPollCurrent=$ScratchPollCurrent

	if [ "$LoopCount" -ge "$ScratchPollCurrent" ] ;
	then
		LoopCount=0				# reset the counter that counts the loops
		ScratchPollCurrent=$ScratchPollMax	# reset the current polling time. When faster is needed it will be set below.

		# The next block will test, if needed, whether one of the open Scratch files refers in it to scratchClient.js.
		# It will also cache the last filename (usually there only file open) and the checking status.
		# This avoids having to the unzip operation every few seconds.
		# The result will be that SCLProjectOpen=1 if at least one Scratch file is open which which refers to scratchClient.js.
		SCLprojectOpen=0
		if [ -e $SCMandatory ] ; 
		then
			a=a ; # no need to inspect whether the latest opened file of the project that is open in Scratch has the scratchClient extension
		else
			CurrentlyOpenScratchFile=`ps -ef | grep scratch2 | sed -e "/.*grep.*/d" -e "/.*electron.*/d" -e "s/.*scratch2 //" | tr '\n' ' '`
			# notify-send CurrentlyOpenScratchFile "$CurrentlyOpenScratchFile"

			if [ -n "$CurrentlyOpenScratchFile" ] ;
			then
				for filepath in $CurrentlyOpenScratchFile
				do
					if [ "$filepath" = "$CachedScratchFileName" ] ;
					then
						SCLprojectOpen=$CachedScratchFileStatus
					else
						# notify-send filepath "$filepath"
					
						SCLprojectOpen=`unzip -p "$filepath" -x \*.png \*.svg \*.wav | grep --count "scratchClient.js"`
						# notify-send SCLprojectOpen $SCLprojectOpen

						CachedScratchFileName="$filepath"
						CachedScratchFileStatus=$SCLprojectOpen
	
					fi

					if [ $SCLprojectOpen = 1 ]
					then 
						break	# if we find a file that uses scratchClient extension then break, because having one is sufficient for the further operation
					fi
				
				done
			fi
		
	
		fi

		# notify-send -u normal -t 3000 "NotSavedTime=$NotSavedTime" "SaveAlarmTime=$SaveAlarmTime"

		# now we will determine if an alarm or warning must be given to save the open Scratch file
		if [ "$NotSavedTime" -ge "$SaveAlarmTime" ] ;
		then
			TempTime=`expr $NotSavedTime / 60`		# convert seconds to minutes
			# echo NotSavedTime=$NotSavedTime    TempTime=$TempTime
			Temp=`printf "$SaveUrgentBody" $TempTime `
			# echo $Temp
			notify-send -u critical -t $NotifyTimeSaveAlarm "$SaveUrgentTitle" "$Temp"
			# 
			ScratchPollCurrent=$ScratchPollFast	# from now on poll fast
		elif [ "$StartSaveWarn" = "1" ] ;
		then
			notify-send -u normal -t $NotifyTimeSaveWarning "$SaveHintTitle" "$SaveHintBody"
			StartSaveWarn=0		# Switch off the flag. The warning will be displayed for a long time, no need to display it in the next cycle

		fi
	
		
		# Determine whether scratchClient is running
		ProcCountScratchClient=`ps -ef | grep --count "$ScratchClientCommand"`

		# If ScratchClient is mandatory then first test whether there are two Scratch instances running. If so give a notification.
		# If SC is mandatory then if Scratch is running give a notification if ScratchClient is not running.

		ProcCountScratch1=`ps -ef | grep --count "/usr/lib/squeak/.*/usr/share/scratch/NuScratch"`	#Scratch 1.4
		ProcCountScratch2=`ps -ef | grep --count "/usr/lib/electron/electron /usr/lib/scratch2"`	#Scratch 2
		ProcCount=`expr $ProcCountScratch1 + $ProcCountScratch2 - 2`	# -2 to compensate for two times grep matching.
		#echo -en "\r $ProcCount"


		if [ $ProcCountScratch2 = 1 ] ;	# it will always be at least 1 because it matches the grep itself. So if it is 1, there will be no
						# Scratch2 running 
		then
			NotSavedTime=0		# Reset the saved counter. When no Scratch2 is running, there is no need to save a Scratch file,
						# so no reason to give warnings. Saving through the HOME folder is only done for Scratch 2.		
		fi

		case $ProcCount in

		0)	# no Scratch running
			# notify-send -u low -t 100 "No Scratch. ProcCount = "$ProcCount"  ScratchPollCurrent = "$ScratchPollCurrent"  LoopCount = "$LoopCount
			ScratchPollCurrent=$ScratchPollMax

			;;
		1)	# one instance running, so this is OK. Now check whether scratchClient is running in case that it should (when .SCMandatory is present on the desktop)
			# or in case it was detected that a Scratch program referring to scratchClient is running.

			# ScratchPollCurrent=$ScratchPollMax



			if  [ X$ProcCountScratchClient = X1 ] && ( [ -e $SCMandatory ]  || [ $SCLprojectOpen = 1 ] ) ;	# it will be always at least 1 because of grep. So the value 1 means that scratchClient does not run.
			then
				notify-send -u normal -t $NotifyTimeNoScratchClient "$NoScratchClientTitle" "$NoScratchClientBody"
				ScratchPollCurrent=$ScratchPollFast
			fi	

 
			;;

		*)	# Scratch is open more than once
			# notify-send -u critical -t 100 "$MultiScratchOpenBody"
			if [ -e $SCMandatory ] || [ $SCLprojectOpen = 1 ] ;
			then
				Temp=`printf "$MultiScratchOpenBody" $ProcCount`
				notify-send -u critical -t $NotifyTimeMultiScratchOpen "$MultiScratchOpenTitle" "$Temp"
				# increase the polling frequency
				ScratchPollCurrent=$ScratchPollFast
			else
				# Warn that scratchClient is open and that therefore there should be only one Scratch open
				if [ X$ProcCountScratchClient = X2 ] ;
				then
					Temp=`printf "$MultiScratchOpenSCRunningBody" $ProcCount`
					notify-send -u critical -t $NotifyTimeMultiScratchOpen "$MultiScratchOpenSCRunningTitle" "$Temp"
				fi					
			fi
			;;
		esac


	
	fi
	
	LoopCount=`expr $LoopCount + 1`
	NotSavedTime=`expr $NotSavedTime + 1`
	#echo LoopCount=$LoopCount


	# sleep a second to not use too much processing time
	sleep 1
done
