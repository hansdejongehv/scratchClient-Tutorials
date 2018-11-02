#!/bin/bash

#############
# 
# usage: Run_SCTool.sh Script2Run
#	 Script2Run:  script of the tool that should be run
# This script starts the script that is passed in Script2Run
#
# Author: Hans de Jong
# Date:   2018-10-28
#
##############
ThisFile=`basename $0`
xdotool search --name $ThisFile windowfocus > /dev/null 2>&1
TimeStamp=`date +%H:%M:%S`
sleep 1
TargetFile=`basename $1`
xdotool search --name $ThisFile set_window --name "$TargetFile - $TimeStamp" > /dev/null 2>&1
/bin/bash "$1"

