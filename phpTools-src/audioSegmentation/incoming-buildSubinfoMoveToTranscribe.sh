#!/bin/bash
# $1 is the full path to the file to process (e.g. newfile.mp3 )

# #######################################################################
# #######################################################################
# ######        user configuration - you may change these          ######
# #######################################################################
# #######################################################################

# path to PHP processing directory
#PATH_TRANSCRIPTION_HUB="/Volumes/FAT32/apache2/processing/"
#PATH_TRANSCRIPTION_HUB="/Volumes/LocalHD/dev-snapshots/test-processing/"
PATH_TRANSCRIPTION_HUB="/Volumes/LocalHD/dev-snapshots/uweAudioSegme\
ntation/phpTools-src/audioSegmentation/"

# filename for logged messages
LOGFILE="/Library/Logs/uweAudioSegmentation.log"

# default .submissioninfo values
SUBINFO_SPEAKER_LIST="dan buzzo"
SUBINFO_ADMIN_COMMENT="no comment"

# segmentation configuration
#
# SEGMENT_SPEECH_COUNT=
#		(counter integer with practical range 1 to 1024)
#
# SEGMENT_SPEECH_THRESHOLD=
#		(dB threshold integer with practical range 0 to -60)
#
# SEGMENT_MODE=
#	("naturalSpeechPauses" or "regularIntervals")
#
# SEGMENT_INTERVAL_MINUTES=
#		(float with practical range 0.2 to 5.0)
#
####################
SEGMENT_MODE="regularIntervals"
SEGMENT_INTERVAL_MINUTES="1"
####################

# #######################################################################
# #######################################################################
# ######			       do not change below here                ######
# #######################################################################
# #######################################################################

##########################
# logging function
function log {
	# create logfile for the first time if required
	touch $LOGFILE
	
	# prepare a date string
	DATE_STRING=$(date '+%Y-%m-%d %H:%M:%S')

	# dump into file
	echo "$DATE_STRING $1" >> $LOGFILE
	
	# also display to stdout (without date string)
	echo "$1"
}

##########################
# script begins
##########################

# debug 
log "first argument passed to script: $1"

# work in the transcription hub root directory
WORKING_DIR="${PATH_TRANSCRIPTION_HUB}"
log "Changing working directory to $WORKING_DIR"
cd "$WORKING_DIR"

# extract pathname, dirname, basename, and file extention
FULL_PATH_SRC="$1"
FILENAME_SRC="${FULL_PATH_SRC##*/}"

PATH_DIRNAME="incoming"
JUST_FILENAME="${FILENAME_SRC%%.*}"
JUST_EXTENTION="${FILENAME_SRC#*.}"


# ########################################
# 	    	   process audio
# ########################################

# set default state of IS_AUDIO_PROCESSED to false
IS_AUDIO_PROCESSED='false'

# do we need to convert from m4a format to mp3?
# or is the input already in mp3 format?
# or perhaps another (unsupported) format
case "$JUST_EXTENTION" in
	m4a)
		# ########################################
		# 				process m4a
		# ########################################
	
		log "preparing to segment m4a file ${FILENAME_SRC}"
		
		# work in the transcription hub root directory
		WORKING_DIR="${PATH_TRANSCRIPTION_HUB}"
		log "Changing working directory to $WORKING_DIR"
		cd "$WORKING_DIR"
		
		COMMAND_TO_RUN="./incoming-m4asplit.sh"
		COMMAND_TO_RUN="$COMMAND_TO_RUN $PATH_DIRNAME"
		COMMAND_TO_RUN="$COMMAND_TO_RUN $FILENAME_SRC"
		COMMAND_TO_RUN="$COMMAND_TO_RUN $SEGMENT_INTERVAL_MINUTES"
		
		log "command to run is '$COMMAND_TO_RUN'"
		log "This part could take a while!"
		
		$COMMAND_TO_RUN | tee -a $LOGFILE
				
		# if the script is successful, the segmented directory 
		# will contain a subdirectory with the same name as
		# JUST_FILENAME, and this will contain an mp3 copy and 
		# skeleton.xml
		if [ -d "segmented/$JUST_FILENAME" ] \
		&& [ -f "segmented/$JUST_FILENAME/skeleton.xml" ] \
		&& [ -f "segmented/$JUST_FILENAME/$JUST_FILENAME.mp3" ]
		then
			IS_AUDIO_PROCESSED='true'
		
			# now tweak FILENAME_SRC and JUST_EXTENTION in order to 
			# write submissioninfo as if the original input was mp3
			#
			JUST_EXTENTION="mp3"
			FILENAME_SRC="${JUST_FILENAME}.${JUST_EXTENTION}"
			log "debug: FILENAME_SRC is now $FILENAME_SRC"
			log "debug: JUST_EXTENTION is now $JUST_EXTENTION"
		else
			IS_AUDIO_PROCESSED='false'
			log "ERROR - cannot proceed, segmentation failed."
			exit -1
		fi
		;;
	
	
	mp3)
		# ########################################
		# 				process mp3
		# ########################################
	
		log "preparing to segment mp3 file ${FILENAME_SRC}"
	
		log "ERROR - not implemented. Cannot proceed."
		exit -1
		;;
	
	*)
		# ########################################
		# 				unsupported
		# ########################################
	
		log "ERROR - $JUST_EXTENTION file extention is not supported. Cannot proceed."
		exit -1
esac


#######################################
# write the submissioninfo information
#######################################

log "debug: IS_AUDIO_PROCESSED is $IS_AUDIO_PROCESSED"

if [[ "$IS_AUDIO_PROCESSED" == 'true' ]];
then 
	# work in the 'segmented' directory
	WORKING_DIR="${PATH_TRANSCRIPTION_HUB}/segmented/"
	log "Changing working directory to $WORKING_DIR"
	cd "$WORKING_DIR"
	
	# create/overwrite empty the subinfo file
	FNAME_SUBINFO="${JUST_FILENAME}/this.submissioninfo"
	log "debug: fname_subinfo ${FNAME_SUBINFO}"
	echo -e "$JUST_FILENAME" > $FNAME_SUBINFO
	
	# append info
	echo -e "$SUBINFO_SPEAKER_LIST" >> $FNAME_SUBINFO
	echo -e "$FILENAME_SRC" >> $FNAME_SUBINFO
	echo -e "$SUBINFO_ADMIN_COMMENT" >> $FNAME_SUBINFO
	
	# append footer
	echo -e "# ###########################" >> $FNAME_SUBINFO
	echo -e "#" >> $FNAME_SUBINFO
	echo -e "# Human readable file format:" >> $FNAME_SUBINFO
	echo -e "# 1st line - Short name/description Sakai/PPad/Blackboard entry name" >> $FNAME_SUBINFO
	echo -e "# 2nd line - Names of speakers (comma separated)" >> $FNAME_SUBINFO
	echo -e "# 3rd line - MP3 filename" >> $FNAME_SUBINFO
	echo -e "# 4th line - Notes/comments ****BRIEF, ONE LINE ONLY****" >> $FNAME_SUBINFO
	echo -e "# 5th line and onward ignored" >> $FNAME_SUBINFO
	
	log "finished writing subinfo file"
else
	log "ERROR - audio is not segmented, cannot proceed"
	exit -1
fi

#######################################
# move the files to the transcribe dir
#######################################

# work in the transcription hub root directory
WORKING_DIR="${PATH_TRANSCRIPTION_HUB}"
log "Changing working directory to $WORKING_DIR"
cd "$WORKING_DIR"

# only move if subinfo exists and has a nonzero size
# also doublecheck to see if already moved
if [[ -s "segmented/${FNAME_SUBINFO}" ]];
then

	SOURCE_TO_MOVE="segmented/${JUST_FILENAME}"
	DESTINATION_FOR_MOVE="transcribe/${JUST_FILENAME}"
	log "preparing to move $SOURCE_TO_MOVE to $DESTINATION_FOR_MOVE"
	
	# abort if directory has already been moved
	if [[ -d "$DESTINATION_FOR_MOVE" ]]; then
		log "ERROR - $JUST_FILENAME directory already exists. Cannot proceed."
		exit -1
	else
		log "moving"
		mv "$SOURCE_TO_MOVE" "$DESTINATION_FOR_MOVE"
	fi
fi