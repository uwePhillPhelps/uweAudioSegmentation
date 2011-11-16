#!/bin/bash
# $1 is the full path to the file to process (e.g. newfile.mp3 )

# #######################################################################
# #######################################################################
# ######        user configuration - you may change these          ######
# #######################################################################
# #######################################################################

# path to PHP audioSegmentation directory
#PATH_TRANSCRIPTION_HUB="/Volumes/FAT32/apache2/processing/"
PATH_TRANSCRIPTION_HUB="/Volumes/LocalHD/dev-snapshots/uweAudioSegmentation/phpTools-src/audioSegmentation/"

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
# ######		   do not change below here                ######
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
log "Changing working directory to $PATH_TRANSCRIPTION_HUB"
cd "$PATH_TRANSCRIPTION_HUB"

# extract pathname, dirname, basename, and file extention
FULL_PATH_SRC="$1"
FILENAME_SRC="${FULL_PATH_SRC##*/}"

PATH_DIRNAME="incoming"
JUST_FILENAME="${FILENAME_SRC%%.*}"
JUST_EXTENTION="${FILENAME_SRC#*.}"

# display processed strings
log "full path src $FULL_PATH_SRC"
log "filename src $FILENAME_SRC"
log "path dirname $PATH_DIRNAME"
log "just filename $JUST_FILENAME"
log "just extention $JUST_EXTENTION"