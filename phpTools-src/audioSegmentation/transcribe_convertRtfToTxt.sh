#!/bin/bash
# $1 is working directory relative to the script (e.g. incoming/ )
# $2 is filename to process inside the working directory (e.g. input.m4a )

# see http://osxdaily.com/2011/07/06/convert-a-text-file-to-rtf-html-doc-and-more-via-command-line/

for i in *.rtf
do 
	echo "Considering file: " "$i"
	
	#if [[ "$i" =~ ^PROCESSED* ]]; then
	# as of version 3.2 of Bash, expression to match not quoted
	#	echo "Skipping file: " "$i"
	#else

	textutil -strip -format rtf -convert txt -- $i
end