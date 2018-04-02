#!/bin/bash

#############
# 
# This is the script to create a release tar file with the material for
# users who want to install scratchClient-Tutorials
#
# It will:
# It will take the entire local copy of the Github project and
# - Copy the whole local copy and from that copy:
# - Delete the .git folder (which contains old commits and the Github administration)
# - Delete the docs folder (which contians Github pages)
# - Delete the _NOT_PART_OF_RELEASE folder
# - Delete specific files that are not required for users of the project 
# 	(e.g. if delete the .pptx files of the presentations, because the user uses the .pdf files)
#
# Author: Hans de Jong
# Date: 2 April 2018
#
##############


ParentSourceDir=~/NAS/GitHub
ParentReleaseDir=$ParentSourceDir/Releases
SourceDir=$ParentSourceDir/scratchClient-Tutorials
TargetDir=$ParentTargetDir/scratchClient-Tutorials-Rel-RPi
TargetTarFile=$ParentTargetDir/scratchClient-Tutorials-Rel-Rpi.tar.gz

# chmod 777 $TargetDir
rm -rf $TargetDir
rm -rf $TargetTarFile
cp -r $SourceDir $TargetDir

cd $TargetDir

rm -rf $TargetDir/.git
rm -rf $TargetDir/_NOT_PART_OF_RELEASE
rm -rf $TargetDir/docs

# for f in $TargetDir/*
# do
	# echo "$f"
	# case "$f" in
	# $TargetDir/tools|$TargetDir/docs)	rm -rf "$f"
	# ;;
	# esac
# done

for f in $TargetDir/*/*/Thumbs.db
do
	echo "$f"
	rm -rf "$f"
done

for f in $TargetDir/*/*/*.pptx
do
	echo "$f"
	rm -rf "$f"
done

for f in $TargetDir/*/*/*/*.pptx
do
	echo "$f"
	rm -rf "$f"
done

for f in $TargetDir/*/*/*/Thumbs.db
do
	echo "$f"
	rm -rf "$f"
done

for f in $TargetDir/*/*/*/*.odp
do
	echo "$f"
	rm -rf "$f"
done

for f in $TargetDir/scratchClientExtension/Icons/PDF* $TargetDir/scratchClientExtension/Icons/Thumbs.db
do
	echo "$f"
	rm -rf "$f"
done

tar -C $TargetDir/.. -c -a -f $TargetTarFile `basename $TargetDir`

