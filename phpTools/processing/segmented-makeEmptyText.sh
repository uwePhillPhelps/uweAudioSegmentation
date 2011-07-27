#!/bin/bash

echo =================================================
echo argument 1 is $1
echo argument 2 is $2
echo argument 3 is $3
echo =================================================
startdir=$(pwd)
echo ================== debugging info: current directory is $startdir
echo ============================================================

cd $1
echo ================== debugging info: current directory is now $1

echo ================== PLEASE WAIT!: this part might take a while!
for i in *.mp3
do 
	newname=${i%%.mp3}.txt
	touch $newname
	echo creating empty segment $newname
done

cd $startdir
echo ================== debugging info: current directory is now $startdir

mv $1 transcribe/$3
echo ================== debugging info: chmod 777 transcribed/$3
chmod -R 777 transcribe/$3