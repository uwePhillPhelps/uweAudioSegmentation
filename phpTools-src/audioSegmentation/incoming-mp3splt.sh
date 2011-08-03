#!/bin/bash
# $1 is input path i.e. ./incoming/081021
# $2 is mp3 file name inside the input path i.e ./incoming/081021/R09-raw-081021.mp3
# $3 is basename of directory i.e. 081021 (for input path ./incoming/081021)

# useful debugging info - make sure the php arguments were passed ok
echo ============================================================
echo ================== debugging info: argument 1 is $1
echo ================== debugging info: argument 2 is $2
echo ================== debugging info: argument 3 is $3
startdir=$(pwd)
echo ================== debugging info: current directory is $startdir
echo ============================================================

# check to see if the user has accidentally invoked this script twice
# if so, the building of skeleton.xml is already in progress
#
if [ -f $1/skeleton.xml ]
then
	echo ================== ERROR!: $1 has already begun processing
	break
fi

# check to see if the user accidentally invoked the script after processing completed
# if so, the files will already be present in the segmented directory
if [ -f segmented/$3 ]
then
	echo ================== ERROR!: $2 has already been processed into segmented/$3
	break
else
	# otherwise, lets begin
	echo ================== debugging info: chmod -R 777 $1
	chmod -R 777 $1
	
	echo ================== debugging info: changing to directory $1
	cd $1
	processingdir=$(pwd)
	echo ================== debugging info: current directory is now $processingdir
	
	echo =============================================================
	echo ================== PLEASE WAIT!: Creating TRS XML timecode file could take a few minutes!
	echo =
	echo ================== It is safe to return to the main page now if you dont want to wait,
	echo ================== but some useful debugging info is shown here after the process ends.
	/usr/local/bin/mp3splt -s -p th=-30,nt=120 -n $2 >skeleton.xml
	rm mp3splt.log
	echo =============================================================
	echo ================== COMPLETE!: listing output files in directory $processingdir
	ls -l
	
	echo ================== debugging info: moving processed files into segmented dir
	cd $startdir
	mv $1 segmented/$3
	echo ================== debugging info: chmod 777 segmented/$3
	chmod -R 777 segmented/$3
fi
