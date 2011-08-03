#!/bin/sh

echo ============================================================
startdir=$(pwd)
echo ================== debugging info: current directory is $startdir

cd ./transcribe

for i in *.tgz
do 
    echo ================== unpacking "$i"
    tar -zxvf "$i"
    echo ================== deleting "$i"
    rm "$i"
    echo =
    echo =
done

echo ================== done processing
