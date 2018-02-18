#!/bin/bash

thisdir=`dirname $0`

EXT="ascl"
APP1="$EXT"Run
APP2="$EXT"Edit
ICONPREFIX="SCLogo"


# based on the work of fastrizwaan
# https://stackoverflow.com/questions/30931/register-file-extensions-mime-types-in-linux#31836

APP=$APP1
NAME="scratchClient Run"
COMMENT="$APP's data file"
TERMINAL=true
EXEC=~/scratchClientExtension/src/Run_SC_Cl_and_Mon.sh
ICONDIR=$1


$thisdir/register_mimeapp.sh $APP "$NAME" $EXT 

$thisdir/register_mime.sh $APP "$NAME" $EXT $TERMINAL $EXEC $ICONDIR $ICONPREFIX

APP=$APP2
NAME="scratchClient Edit"
COMMENT="$APP's data file"
TERMINAL=false
EXEC=~/scratchClientExtension/src/Start_SC_Edit_Config.sh
ICONDIR=$1

$thisdir/register_mime.sh $APP "$NAME" $EXT $TERMINAL $EXEC $ICONDIR $ICONPREFIX

$thisdir/register_mimeapps_list.sh $APP1 $APP2 leafpad

