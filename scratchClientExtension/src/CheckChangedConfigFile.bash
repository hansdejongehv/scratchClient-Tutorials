#!/bin/bash

#############
# 
# usage: CheckChangedConfigFile  ProcessNumber  Configfile
#	 ProcessNumber		Processnumber of scratchClient 
#	 Configfile:  		config file to be monitored
#
# This script is meant to monitor whether the config file with which scratchClient was started
# has been modified. If it is, then give a message that it is. Process exits when 
# scratchClient is no longer present.
# 
#
# Author: Hans de Jong
# Date:   2020-03-15
#
##############

SC_ProcessNum=$1
scratchClient_configfile="$2"

# echo ProcessNum=$SC_ProcessNum 
# echo scratchClient_configfile=$scratchClient_configfile 


#----------------------------------------------------------------------------------------------------------------
#string definitions for multiple languages. Default is English. They can be overwritten dependent on the language
#----------------------------------------------------------------------------------------------------------------
ConfigfileChangedTitle="Restart scratchClient"
ConfigfileChangedBody="You must restart scratchClient because the config file was changed"


if [ ${LANG:0:2} = nl ]
then
	ConfigfileChangedTitle="Herstart scratchClient"
	ConfigfileChangedBody="Je moet scratchClient herstarten omdat de config file gewijzigd is"
fi

if [ ${LANG:0:2} = de ]
then
	ConfigfileChangedTitle="ScratchClient neu starten"
	ConfigfileChangedBody="Sie müssen ScratchClient neu starten, da die Konfigurationsdatei geändert wurde"
fi

# Remember the current timestamp of the config file
LastModifiedConfigAtStart=`stat --format==%Y "$scratchClient_configfile"`


while [ true ] 
do
	# it is good enough to check every 10 seconds
	sleep 10

	# check whether scratchClient is still running. 
	status=`ps -h $SC_ProcessNum`

	# if scratchClient is not running, then exit this process as there is no need to 
	# continue checkinng

	if [ "X$status" = X ] ;
	then
		# scratchClient has stopped
		# echo status=$status
		exit
	fi

	# find the current timestamp
	LastModifiedConfig=`stat --format==%Y "$scratchClient_configfile"`

	# if the configfile has a different last modification date, then notify the user

	if [ X$LastModifiedConfig !=  X$LastModifiedConfigAtStart ] ;
	then
		notify-send -u critical -t 5000 "$ConfigfileChangedTitle" "$ConfigfileChangedBody"	
	fi

done
