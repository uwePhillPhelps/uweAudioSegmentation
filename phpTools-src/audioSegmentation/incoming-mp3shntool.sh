#!/bin/bash
# $1 is working directory relative to the script (e.g. incoming/ )
# $2 is filename to process inside the working directory (e.g. input.mp3 )

# todo: add segmentation interval (in minutes) ala incoming-m4asplit.sh

echo "debug: $1 $2"

FPATH_SRC="$2"
BASENAME_SRC="${FPATH_SRC%%.mp3}"

if [[ -d "segmented/${BASENAME_SRC}" ]]; then
	echo "WARNING - $BASENAME_SRC already exists in segmented directory"
	exit 0
elif [[ -d "transcribe/${BASENAME_SRC}" ]]; then
	echo "ERROR - $BASENAME_SRC already exists in transcribe directory"
	exit 0
fi

echo Changing working directory to "$1"
cd "$1"

if [[ -f "$FPATH_SRC" ]]; then
    echo "ok"
else
	echo "ERROR - $FPATH_SRC could not be found"
	exit 0
fi

FPATH_SKELETON_XML="${BASENAME_SRC}/skeleton.xml"
FPATH_FULL_WAV_SRC="${BASENAME_SRC}/${BASENAME_SRC}.wav"
PATH_SPLIT_WAV="${BASENAME_SRC}/split_wav"
PATH_SPLIT_MP3="${BASENAME_SRC}/split_mp3"
EACH_SPLIT_APPEND="_silence"
FNAME_EACH_SPLIT="${BASENAME_SRC}${EACH_SPLIT_APPEND}"
PATH=$PATH:/usr/local/bin

echo "\tChecking length of source audio ${FPATH_SRC}"
# different procedure depending on length of source audio
# abort if length is under 10 seconds
#
LENGTH_SECONDS_SRC=`afinfo -b "${FPATH_SRC}" | awk '/,/{print $3}'`
IS_UNDER_ONE_MINUTE=`echo $LENGTH_SECONDS_SRC 60.0 | awk '{if ($1 < $2) print "true"; else print "false";}'`
IS_OVER_TEN_SECONDS=`echo $LENGTH_SECONDS_SRC 10.0 | awk '{if ($1 > $2) print "true"; else print "false";}'`
	if [[ "$IS_UNDER_ONE_MINUTE" = "true" ]]; then
			if [[ "$IS_OVER_TEN_SECONDS" = "true" ]]; then
					LENGTH_MINUTES_SPLIT=0
					LENGTH_SECONDS_SPLIT=10
			else
					echo "\t\tERROR - source must be longer than 10 seconds"
					exit -1
			fi
	else
			LENGTH_MINUTES_SPLIT=1
			LENGTH_SECONDS_SPLIT=00
	fi
STRING_TIME_SPLIT="${LENGTH_MINUTES_SPLIT}:${LENGTH_SECONDS_SPLIT}"

echo "Creating sub-dirs"
mkdir "$BASENAME_SRC"
mkdir "$PATH_SPLIT_WAV"
mkdir "$PATH_SPLIT_MP3"	

echo "\tConverting $FPATH_SRC to $FPATH_FULL_WAV_SRC"
afconvert -f WAVE -d LEI16 "$FPATH_SRC" \
-o "$FPATH_FULL_WAV_SRC"
# test exit status
if [[ $? -ne 0 ]]; 
then
	echo "\t\tERROR - converting to WAV failed"
	exit -1
fi 	

echo "\tMoving source mp3 $FPATH_SRC to ${BASENAME_SRC}/"
mv "$FPATH_SRC" "${BASENAME_SRC}/"

# move everything to the segmented directory
echo "\tMoving $BASENAME_SRC to the segmented directory"
mv "$BASENAME_SRC" ../segmented/
# test exit status
if [[ $? -ne 0 ]]; 
then
	echo "\t\tERROR - moving files to segmented directory failed"
	exit -1
fi

echo "\tChanging working directory to segmented directory"
cd ../segmented

# begin the split using shntool
echo "\tSource audio is ${LENGTH_SECONDS_FULL_WAV} seconds long"
echo "\tSplitting and timecoding from $FPATH_FULL_WAV_SRC at $STRING_TIME_SPLIT"
echo "\tto $FPATH_SKELETON_XML with prefix $FNAME_EACH_SPLIT"
shntool split -l "$STRING_TIME_SPLIT" -q -d "$PATH_SPLIT_WAV" \
-a "$FNAME_EACH_SPLIT" "$FPATH_FULL_WAV_SRC" 2>&1 > "$FPATH_SKELETON_XML"
# test exit status
if [[ $? -ne 0 ]]; 
then
	echo "\t\tERROR- splitting WAV failed"
	cat "$FPATH_SKELETON_XML"
	exit -1
fi

# if converted ok continue processing
echo "\tRemoving wav $FPATH_FULL_WAV_SRC (WAV splitparts remain)"
rm "$FPATH_FULL_WAV_SRC"

echo "\tConverting splitparts to mp3 (for transcript viewer)"
for j in "$PATH_SPLIT_WAV/"*.wav
do
	BASENAME_SPLIT_MP3="${j##*/}"
	BASENAME_SPLIT_MP3="${BASENAME_SPLIT_MP3%wav}mp3"
	FPATH_SPLIT_MP3="${PATH_SPLIT_MP3}/${BASENAME_SPLIT_MP3}"

	echo "\t\tProcessing splitpart" "$j"
	lame --quiet "$j" "${FPATH_SPLIT_MP3}"
	# test exit status
	if [[ $? -ne 0 ]]; 
	then
		echo "\t\tERROR - converting to mp3 failed"
		exit -1
	fi
done
