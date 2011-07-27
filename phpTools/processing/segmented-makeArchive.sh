#!/bin/bash
# $1 is output archive full path i.e. ./outgoing/081021.tgz
# $2 is the input directory full path i.e ./segmented/081021

# useful debugging info - make sure the php arguments were passed ok
echo ============================================================
echo ================== debugging info: argument 1 is $1
echo ================== debugging info: argument 2 is $2
startdir=$(pwd)
echo ================== debugging info: current directory is $startdir
echo ============================================================

# check to see if the user accidentally invoked the script after processing completed
# if so, the files will already be present in the outgoing directory
if [ -f $1 ]
then
	echo ================== ERROR!: $2 has already been processed into $1
	break
else
	echo ================== debugging info: chmod -R 777 $2
	chmod -R 777 $2
	echo ================== PLEASE WAIT!: this part could take a while...
	tar --remove-files -czvf $1 $2
	echo ================== COMPLETE!: listing output files in directory outgoing dir
	ls -l outgoing/
	echo ================== debugging info: tidying up input directory
	rmdir $2
	echo ================== debugging info: listing input directory
	ls -l $2
fi

