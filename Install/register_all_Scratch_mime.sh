#!/bin/bash

thisdir=`dirname $0`

EXT="sb2"
APP1="$EXT"Run
ICONPREFIX="CatLogo"


# based on the work of fastrizwaan
# https://stackoverflow.com/questions/30931/register-file-extensions-mime-types-in-linux#31836

APP=$APP1
NAME="Scratch 2"
COMMENT="$APP's data file"
TERMINAL=false
EXEC=/usr/bin/scratch2
ICONDIR=$thisdir/icons


$thisdir/register_mimeapp.sh $APP "$NAME" $EXT 

$thisdir/register_mime.sh $APP "$NAME" $EXT $TERMINAL $EXEC $ICONDIR $ICONPREFIX

$thisdir/register_mimeapps_list.sh $APP1
