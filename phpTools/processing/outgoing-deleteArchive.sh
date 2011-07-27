#!/bin/bash
# $1 is output archive full path i.e. ./outgoing/081021.tgz
# $2 is the input directory full path i.e ./segmented/081021

# useful debugging info - make sure the php arguments were passed ok
echo ============================================================
echo ================== debugging info: argument 1 is $1
startdir=$(pwd)
echo ================== debugging info: current directory is $startdir
echo ============================================================

# if path exists
if [ -e $1 ]
then
	# get the dir and ext parts
	dirpart=`dirname "$1"`
	extpart=${1##*.}

	# set what to match against
	dirmatch="outgoing"
	extmatch="tgz"


	if [ "$dirpart" == "$dirmatch" ]; then
		if [ "$extpart" == "$extmatch" ]; then
			echo ================== everything is ok - dir and ext match
			echo ================== directory: $dirpart == $dirmatch
			echo ================== extention: $extpart == $extmatch
			echo rm $1
			echo ============================================================
		else
			echo ============================================================
			echo ================== As a simple security measure, only delete certain files:
			echo ================== we only delete files inside the outgoing dir
			echo ================== and only delete files with the tgz extension.
			echo ============================================================
			echo ================== something wrong - exiting
			echo ================== full path: $1
			echo ================== directory: $dirpart == $dirmatch
			echo ================== extention: $extpart != $extmatch
			echo ============================================================
			exit 1
		fi
	else
		echo ============================================================
		echo ================== As a simple security measure, only delete certain files:
		echo ================== we only delete files inside the outgoing dir
		echo ================== and only delete files with the tgz extension.
		echo ============================================================
		echo ================== something wrong - exiting
		echo ================== full path: $1
		echo ================== directory: $dirpart != $dirmatch
		echo ============================================================
		exit 1
	fi
	
else
	echo ================== ERROR!: $1 does not exist or has already been deleted
	exit 1
fi

