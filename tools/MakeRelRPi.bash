#!/bin/bash
ParentDir=~/NAS/GitHub
SourceDir=$ParentDir/scratchClient-Tutorials
TargetDir=$ParentDir/scratchClient-Tutorials-Rel-RPi
TargetTarFile=$ParentDir/scratchClient-Tutorials-Rel-Rpi.tar.gz

# chmod 777 $TargetDir
rm -rf $TargetDir
rm -rf $TargetTarFile
cp -r $SourceDir $TargetDir

cd $TargetDir

rm -rf $TargetDir/.git

for f in $TargetDir/*
do
	echo "$f"
	case "$f" in
	$TargetDir/tools|$TargetDir/docs)	rm -rf "$f"
	;;
	esac
done

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

