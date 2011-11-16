#!/bin/bash
# $1 is input path e.g. ./incoming/081021
# $2 is file name  e.g. R09-raw-081021.mp3

# useful debugging info - make sure the php arguments were passed ok
echo ============================================================
echo ================== debugging info: argument 1 is $1
echo ================== debugging info: argument 2 is $2
echo ================== debugging info: argument 3 is $3
startdir=$(pwd)
echo ================== debugging info: current directory is $startdir
echo ============================================================

echo afconvert -f WAVE -d LEI16 input output
echo lame --quiet "$FPATH_FULL_WAV_SRC" "${FPATH_FULL_WAV_SRC%wav}mp3"