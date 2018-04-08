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

#set -x
# change these variables when material is moved to another location
ParentSourceDir=~/NAS/GitHub
ParentReleaseDir=$ParentSourceDir/Releases

# set the derived locations
RepositoryName=scratchClient-Tutorials
ReleaseGeneralName=scratchClient-Tutorials-Rel-Rpi
SourceDir=$ParentSourceDir/$RepositoryName
RepositoryReleaseDir=$ParentReleaseDir/$RepositoryName
TargetDir=$RepositoryReleaseDir/$ReleaseGeneralName
TargetTarFile=$RepositoryReleaseDir/$ReleaseGeneralName.tar.gz

echo "-----> Create the release for the current version of repository: $RepositoryName"
echo "-----> Generic name of the installer that will be created:       $ReleaseGeneralName"

# make the path to the target folder if not yet present
# The purpose is not to create $TargetDir (it will be deleted next), 
# but to create the parent path
mkdir -p $TargetDir


# Remove previous release, if present
echo "--> Remove any previous release, if present"
rm -rf $TargetDir
rm -rf $TargetTarFile

echo "--> Copy the entire directory to be able to start weeding"
cp -r $SourceDir $TargetDir

cd $TargetDir

echo "--> Remove those parts that should not be part of the released installer"
rm -rf $TargetDir/.git
rm -rf $TargetDir/_NOT_PART_OF_RELEASE
rm -rf $TargetDir/docs
rm -rf $TargetDir/ForHelpers

rm -rf $TargetDir/*/*/Thumbs.db
rm -rf $TargetDir/*/*/*/Thumbs.db
rm -rf $TargetDir/*/*/*.pptx
rm -rf $TargetDir/*/*/*/*.pptx
rm -rf $TargetDir/*/*/*/*.odp
rm -rf $TargetDir/scratchClientExtension/Icons/PDF* 
rm -rf $TargetDir/scratchClientExtension/Icons/Thumbs.db
rm -rf $TargetDir/scratchClientExtension/Icons/CatLogoScratch1*
rm -rf $TargetDir/scratchClientExtension/Icons/CatLogoScratch2*


# for f in $TargetDir/*
# do
	# echo "$f"
	# case "$f" in
	# $TargetDir/tools|$TargetDir/docs)	rm -rf "$f"
	# ;;
	# esac
# done

echo "--> Create the tar file for release"
# The -C option directs to tar to take this as directory to be.
# Then package that same directory, which is done by finding out what the basename is
# This is effectively the same as when specifying a dot, however then the tar file has 
# a folder name that is a single dot.
tar -C $TargetDir/.. -c -a -f $TargetTarFile `basename $TargetDir`

read -p "Hit Enter to continue"

