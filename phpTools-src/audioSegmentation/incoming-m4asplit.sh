#!/bin/bash
# $1 is working directory relative to the script (e.g. incoming/ )
# $2 is filename to process inside the working directory (e.g. input.m4a )
# $3 is segmentation interval in minutes (e.g. 0.2 for 12 second intervals)

# #######################################################################
# #######################################################################
# ######        user configuration - you may change these          ######
# #######################################################################
# #######################################################################

#
# none
#

# #######################################################################
# #######################################################################
# ######			begin script - do not change below here        ######
# #######################################################################
# #######################################################################

# test segmentation interval
SEGMENTATION_INTERVAL="$3"
IS_SEGMENTATION_INTERVAL_IN_RANGE=`echo ${SEGMENTATION_INTERVAL} | awk '{if ($1 > 0.1  && $1 < 3) print "true"; else print "false";}'`
if [[ "$IS_SEGMENTATION_INTERVAL_IN_RANGE" = "false" ]]; then
	echo "ERROR - valid segmentation interval range is 0.1 to 3 minutes"
	exit -1
fi

FPATH_SRC="$2"
BASENAME_SRC="${FPATH_SRC%%.m4a}"

if [[ -d "segmented/${BASENAME_SRC}" ]]; then
	echo "ERROR - $BASENAME_SRC already exists in segmented directory. Cannot proceed."
	exit -1
elif [[ -d "transcribe/${BASENAME_SRC}" ]]; then
	echo "ERROR - $BASENAME_SRC already exists in transcribe directory. Cannot proceed."
	exit -1
fi

echo Changing working directory to "$1"
cd "$1"

if [[ -f "$FPATH_SRC" ]]; then
    echo "ok"
else
	echo "ERROR - $FPATH_SRC could not be found"
	exit -1
fi


FPATH_SKELETON_XML="${BASENAME_SRC}/skeleton.xml"
FPATH_FULL_WAV_SRC="${BASENAME_SRC}/${BASENAME_SRC}.wav"
PATH_SPLIT_WAV="${BASENAME_SRC}/split_wav"
PATH_SPLIT_MP3="${BASENAME_SRC}/split_mp3"
EACH_SPLIT_APPEND="_silence"
FNAME_EACH_SPLIT="${BASENAME_SRC}${EACH_SPLIT_APPEND}"
PATH=$PATH:/usr/local/bin

# check length of converted WAV audio
LENGTH_SECONDS_SRC=`afinfo -b "${FPATH_SRC}" | awk '/,/{print $3}'`
echo -e "\tLength of converted WAV audio ${FPATH_FULL_WAV_SRC} is ${LENGTH_SECONDS_SRC} seconds"

# different procedure depending on length of source audio
# abort if length is under 10 seconds
#
IS_UNDER_ONE_MINUTE=`echo $LENGTH_SECONDS_SRC 60.0 | awk '{if ($1 < $2) print "true"; else print "false";}'`
IS_OVER_TEN_SECONDS=`echo $LENGTH_SECONDS_SRC 10.0 | awk '{if ($1 > $2) print "true"; else print "false";}'`
	if [[ "$IS_UNDER_ONE_MINUTE" = "true" ]]; then
			if [[ "$IS_OVER_TEN_SECONDS" = "true" ]]; then
				# source is under one minute, but over ten seconds
				echo -e "\t\tSource is under one minute, but over ten seconds"

				# we split at ten second intervals
				STRING_TIME_SPLIT="0:10"
			else
				# source is under one minute, and under ten seconds
				echo -e "\t\tSource is under one minute, and under ten seconds"
				
				# we reject this
				echo -e "\t\tERROR - source must be longer than 10 seconds"
				exit -1
			fi
	else
			# source is over one minute
			echo -e "\t\tSource is over one minute"
		
			# we split at the requested interval
			# format minutes:seconds
			# minutes and seconds formatted as integer using awk with printf()
			# seconds converted from minutes by multiplying and modulo
			STRING_TIME_SPLIT=$(echo "${SEGMENTATION_INTERVAL}" | awk '{printf("%d:%02d",$1,$1*60%60)}')
	fi

#debug shntool split time calculation
echo -e "\t\tTime split command set to $STRING_TIME_SPLIT (i.e. minutes:seconds)"

echo -e "\tCreating sub-dirs ${BASENAME_SRC} ${PATH_SPLIT_WAV} ${PATH_SPLIT_MP3}"
mkdir "$BASENAME_SRC"
mkdir "$PATH_SPLIT_WAV"
mkdir "$PATH_SPLIT_MP3"	

echo -e "\tConverting $FPATH_SRC to $FPATH_FULL_WAV_SRC"
afconvert -f WAVE -d LEI16 "$FPATH_SRC" \
-o "$FPATH_FULL_WAV_SRC"
# test exit status
if [[ $? -ne 0 ]]; 
then
	echo -e "\t\tERROR - converting to WAV failed"
	exit -1
fi 	

echo -e "\tRemoving source m4a $FPATH_SRC"
rm "$FPATH_SRC"

#move everything to the segmented directory
echo -e "\tMoving $BASENAME_SRC to the segmented directory"
mv "$BASENAME_SRC" ../segmented/
# test exit status
if [[ $? -ne 0 ]]; 
then
	echo -e "\t\tERROR - moving files to segmented directory failed"
	exit -1
fi

echo -e "\tChanging working directory to segmented directory"
cd ../segmented

# begin the split using shntool
echo -e "\tSource audio is ${LENGTH_SECONDS_SRC} seconds long"
echo -e "\tSplitting and timecoding from $FPATH_FULL_WAV_SRC at $STRING_TIME_SPLIT"
echo -e "\tto $FPATH_SKELETON_XML with prefix $FNAME_EACH_SPLIT"
shntool split -l "$STRING_TIME_SPLIT" -q -d "$PATH_SPLIT_WAV" \
-a "$FNAME_EACH_SPLIT" "$FPATH_FULL_WAV_SRC" 2>&1 > "$FPATH_SKELETON_XML"
# test exit status
if [[ $? -ne 0 ]]; 
then
	echo -e "\t\tERROR- splitting WAV failed"
	cat "$FPATH_SKELETON_XML"
	exit -1
fi


	echo -e "\tConverting full source recording to mp3"
	echo -e "\t\tplease wait - this could take several minutes to process"

	lame --quiet "$FPATH_FULL_WAV_SRC" "${FPATH_FULL_WAV_SRC%wav}mp3"
	# test exit status
	if [[ $? -ne 0 ]]; 
	then
		echo -e "\t\tERROR - converting to mp3 failed"
		exit -1
	fi

	# if converted ok continue processing
	echo -e "\tRemoving WAV copy of full recording (WAV splitparts remain)"
	rm "$FPATH_FULL_WAV_SRC"

echo -e "\tConverting splitparts to mp3 (for win32 processing)"
for j in "$PATH_SPLIT_WAV/"*.wav
do
	BASENAME_SPLIT_MP3="${j##*/}"
	BASENAME_SPLIT_MP3="${BASENAME_SPLIT_MP3%wav}mp3"
	FPATH_SPLIT_MP3="${PATH_SPLIT_MP3}/${BASENAME_SPLIT_MP3}"

	echo -e "\t\tProcessing splitpart" "$j"
	lame --quiet "$j" "${FPATH_SPLIT_MP3}"
	# test exit status
	if [[ $? -ne 0 ]]; 
	then
		echo -e "\t\tERROR - converting to mp3 failed"
		exit -1
	fi
done