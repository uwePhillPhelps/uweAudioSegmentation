<?php
	// plaintext header
	header("Content-Type: text/plain");

/*  
    As you can tell from the sheer.... quality of the code - this is just a
    prototype with potentially lots and lots of bugs. 
	
	Should you have any questions or comments (not necessarily jibes at my
	hilariously inefficient php code) please email me at zenpho@zenpho.co.uk
	or philip3.phelps@uwe.ac.uk

	Thanks,
	
	========================================================================
    Intended use:
        Produce plaintext SRT (sub rip text) subtitle format.
        Transcribed text sourced from RTF files, timecode sourced from skeleton.xml

	summary:
    
*/
    require_once('trsxmltoolsclass.inc');  // for TRS XML parsing
    
    // abort if no URL pathname set
	if (isset($_GET["pathname"])){
		// decode any %## format characters passed from previous pages
		$pathname = urldecode($_GET["pathname"]); 

		// also encode again for later use in links generated by this page
        // double encode because on some Apache servers mod_rewrite messes up '+' character
		$encodedpathname = urlencode(urlencode($pathname));
	}
    else{
        trigger_error(
            "No transcript path was specified in the URL ?pathname="
            , E_USER_ERROR);
    }
        
	// obtain original full mp3 link - $fullmp3
	$infofilename = $pathname . "/this.submissioninfo";
	$infofilehandle = fopen($infofilename, 'r') or trigger_error(
		"Can't open the submissioninfo data file for this transcript ($infofilename)"
		, E_USER_ERROR);
	$dummy = fgets($infofilehandle);
	$dummy = fgets($infofilehandle);
	$fullmp3 = fgets($infofilehandle);
	$fullmp3 = trim($fullmp3); // strip whitespace
	$fullmp3 = $pathname . '/' . $fullmp3;
	fclose($infofilehandle);
	unset($infofilename);
	unset($infofilehandle);
	unset($dummy);
                   
	// extract timecode information
    $obj_trs = new TRSXMLTools();
    // old method: $obj_trstools->parseXMLFilename($pathname . "/skeleton.xml");
    $obj_trs->fetch($pathname . "/skeleton.xml");


	// reset a counter used to indicate each subtitle block
	$srtCounter = 1;
	
	/*
	
		// debug sanitising the start and end times
	
	$aryOfTurns = $obj_trs->eachTurn();
	$numberOfTurns = count($aryOfTurns);
	foreach ($aryOfTurns as $turn)
	{
		// extract timecode information from each 'turn'
			$startTime = $turn->_attr->STARTTIME;
			$endTime = $turn->_attr->ENDTIME;
			$splitFilename = $turn->_attr->SPLITFILENAME;
			
		// sanitise startTime and endTime
			if ( $endTime < $startTime )
			{
				$turnIndex = key($turn);
				
				//if this is the last element
				// duration must be zero
				// else use the timecode for the next element
				if ($turnIndex+1 > $numberOfTurns)
					$endTime = $startTime;
				else
					$endTime = $aryOfTurns[$turnIndex+1]->_attr->STARTTIME;
			}
		
		// start timecode, followed by string " --> ", followed by endtimecode
			// timecode format HH:MM:SS,mili
			echo sprintf("%02d:%02d:%02d,0", $startTime/3600, ($startTime/60)%60, $startTime%60)
				. " --> "
				. sprintf("%02d:%02d:%02d,0", $endTime/3600, ($endTime/60)%60, $endTime%60)
				. "\n";
		
	}
	die();
	*/

    // iterate over each 'turn' in the skeleton
    foreach ($obj_trs->eachTurn() as $turn){
            
            // extract timecode information from each 'turn'
				$startTime = $turn->_attr->STARTTIME;
				$endTime = $turn->_attr->ENDTIME;
				$splitFilename = $turn->_attr->SPLITFILENAME;
				
			// sanitise startTime and endTime
				// if ( $endTime < $startTime ) $endTime = nextTurn()->_attr->STARTTIME;
				
			// build paths for potential '.txt' and '.rtf' files
				$txt_pathname = dirname($pathname) . '/' . substr($splitFilename, 0, -3) . "txt";
	            $rtf_pathname = dirname($pathname) . '/' . substr($splitFilename, 0, -3) . "rtf";
											
			//extract transcript text to var $subtitleText
				// favour .txt format, use .rtf format if available
				// warn if both formats exist
				if ( file_exists( $txt_pathname ) && file_exists( $rtf_pathname ) ){
				
					// if both rtf and txt files exist
					$subtitleText = "WARNING - conflicting transcript text. "
						. "Both RTF and TXT files exist for " 
						. substr($segment_mp3_pathname, 0, -4)
						. "\n";
				}
				else if ( file_exists( $txt_pathname ) ){
				
					// if the txt file exists
					
					// read using fopen()
					$filehandle = fopen($txt_pathname,'r') or trigger_error(
						"Error: Cannot open transcript text $txt_pathname"
						, E_USER_ERROR);
						
					// read in 4kb chunks til the end
					$subtitleText = '';
					while ($file_content = fread($filehandle, 4096))
					{
						$subtitleText .= $file_content;
					}
				}
				else if ( file_exists( $rtf_pathname )  ) {
					
					//if the rtf file exists
					
					// use external shell utility (convertRichTextToAscii)
					// TODO: use MacOS utility (textutil)
					$command = './convertRichTextToAscii ' . $rtf_pathname;
					$subtitleText = shell_exec($command);
				}
				else
				{
					$subtitleText = "ERROR - transcript text not found!\n"
						. "$txt_pathname not found\n"
						. "$rtf_pathname not found\n";
				}
            
            //sanitise transcript text
            // strip slashes
				$subtitleText = stripslashes($subtitleText);
				
			//divide segment text into smaller blocks
			// a new block is created when full stops, commas, and newlines are encountered
			// timecode is spread evenly between the original duration
			$ary_subtitleText = preg_split("/[\.,][\n\r ]|[\.,]|[\n\r]/", $subtitleText, -1, PREG_SPLIT_NO_EMPTY);
			
			// count the number of blocks that have been created
			$numberOfBlocksTotal = count($ary_subtitleText);
            
            // count the number of words in the transcript segment
            $numberOfWordsTotal = str_word_count($subtitleText);
			
			// begin at the startTime of the TRS XML element
			$blockStartTime = $blockEndTime = $previousBlockEndTime = $startTime;
			
			// produce SRT output for each block
			foreach ($ary_subtitleText as $key => $subtitleText)
			{
				// SRT counter (beginning at 1)
				echo $srtCounter
					. "\n";
				
				// blocks of transcript text should be numbered from 1
				$blockNumber = $key+1;
				
                
                // set $blockDuration, dividing the display across the number of blocks
                $blockDuration = ($endTime - $startTime) / $numberOfBlocksTotal;
               
                /*
                 * disabled
                 *
                // set $blockDuration to reflect the number of words
                $blockDurationWeighting = str_word_count($subtitleText) / $numberOfWordsTotal;               
                $blockDuration = ($endTime - $startTime ) * $blockDurationWeighting;
		 */
                              
				// set absolute block start and block end times
				$blockStartTime = $previousBlockEndTime;
				$blockEndTime =  $blockStartTime + $blockDuration;
				$previousBlockEndTime = $blockEndTime;
				
				//produce subtitle timecode (for the split block of text)
				// start timecode, followed by string " --> ", followed by endtimecode
				// timecode format HH:MM:SS,mili
				echo sprintf("%02d:%02d:%02d,%d", 
							$blockStartTime/3600,
							($blockStartTime/60)%60,
							$blockStartTime%60,
							($blockStartTime*1000)%1000
							)
					. " --> "
					. sprintf("%02d:%02d:%02d,%d", 
							$blockEndTime/3600,
							($blockEndTime/60)%60,
							$blockEndTime%60,
							($blockEndTime*1000)%1000
							)
					. "\n";
				
				// subtitle text
				echo $subtitleText;
				
				// subtitles are separated by newlines
				echo "\n\n";
				
				// increment SRT counter
				$srtCounter++;
			}
			
	}// foreach turn            

    
?>

<?php
/* 
	strallpos
	report the position of all instances of a given needle string in a haystack string
*/
function strallpos($haystack,$needle,$offset = 0)
{
		$result = array();
		for($i = $offset; $i<strlen($haystack); $i++){
				$pos = stripos($haystack,$needle,$i);
				if($pos !== FALSE){
						$offset = $pos;
								if($offset >= $i){
										$i = $offset;
										$result[] = $offset;
								}
				}
		}
		return $result;
}

?>

<?php

/*
	//old tagcount based method

    // now iterate over each timecoded segment
    for ($outputcount = 0; $outputcount <= $obj_trstools->tagcount; $outputcount++)
    {
        
        if ($obj_trstools->ary_types[$outputcount] == 'T'){
        
        	/////////////////////////////////////////////////////////////////
        	// tag a row with an id for the scrolling flash/javascript to seek to
            echo "<tr class=\"viewerTableRow\" id=\"" 
            	. (int)($obj_trstools->ary_times[$outputcount] * 1000) 
            	. "\">\n";
                        
            /////////////////////////////////////////////////////////////////
           	// segment time column         	
            echo "<td>"
            	. "<span class=\"listenButton\" "
				. "onclick=\"seekPlayheadToTime('"
				. ($obj_trstools->ary_times[$outputcount] * 1000)
				. "')\"> "
				. $obj_trstools->ary_times[$outputcount]
				. "</span>\n"
                . "</td>\n";
                        
            ////////////////////////////////////////////////////////////////
            // segment text
            echo "<td>\n";
			
            
            //old mp3 splt version 
	    //$segment_mp3_pathname = $pathname . "/" . $obj_trstools->ary_fnames[$outputcount];
            $segment_mp3_pathname = "transcribe" . "/" . $obj_trstools->ary_fnames[$outputcount];
			
            $txt_pathname = substr($segment_mp3_pathname, 0, -3) . "txt";
            $rtf_pathname = substr($segment_mp3_pathname, 0, -3) . "rtf";

	    //echo "txt: $txt_pathname, ------ , rtf: $rtf_pathname";
            
            if ( file_exists( $txt_pathname ) && file_exists( $rtf_pathname ) ){
            
                // if both rtf and txt files exist
                $subtitleText = "<b>WARNING</b> - conflicting transcript text. "
                    . "Both RTF and TXT files exist for " 
                    . substr($segment_mp3_pathname, 0, -4)
                    . "<br><br>";
            }
            else if ( file_exists( $txt_pathname ) ){
            
                // if the txt file exists
                $filehandle = fopen($txt_pathname,'r') or trigger_error(
                    "Error: Cannot open transcript text $txt_pathname"
                    , E_USER_ERROR);
                    
                // read in 4kb chunks til the end
                $subtitleText = '';
                while ($file_content = fread($filehandle, 4096))
                {
                    $subtitleText .= $file_content;
                }
            }
            else if ( file_exists( $rtf_pathname )  ) {
                
                // if the rtf file exists
                $command = './convertRichTextToAscii ' . $rtf_pathname;
                echo shell_exec($command);
            }
            
			echo stripslashes($subtitleText); // strip slashes
            echo "</td>\n";
            
            echo "</tr>\n";
            
        }// if Turn tag
        
        	
        
    }// for
*/

?>

<?php

/*

	// old from plaintext viewer

function processDirectory($pathname){

	$output = '';
      
	$output .= "<pre>\n";
	$output .= "Processing $pathname\n";
	
	// extract original full mp3 link
	$infofilehandle = fopen($pathname . "/this.submissioninfo", 'r') or trigger_error(
		"Can't open the submissioninfo data file for this transcript ($infofilename)"
		, E_USER_ERROR);
    	$dummy = fgets($infofilehandle);
    	$dummy = fgets($infofilehandle);
        $originalmp3 = trim(fgets($infofilehandle));
	fclose($infofilehandle);
	unset($infofilehandle);
	unset($dummy);
	    
    // extract timecode information from skeleton
    $obj_trs = new TRSXMLTools();
    $obj_trs->fetch($pathname . "/skeleton.xml");
       
   	/////////////////////////////////////////////////////////////
    // load approval data - do not need allocation data
    if (!file_exists($pathname . '/approvedTimes.data')){
        trigger_error(
            "Approval data file " . $pathname . "/approvedTimes.data does not exist"
            ,E_USER_ERROR);
        
        // create empty timecode list
        $obj_approved = new timecodeList();
    }
    else{
        $obj_approved = unserialize(file_get_contents($pathname . '/approvedTimes.data')) or trigger_error(
            "Error: Can't open the approval data file for " . $pathname . "/approvedTimes.data"
            , E_USER_ERROR);
    }
           
    // now open a TRS XML file for writing
    $output_xml_handle = fopen($pathname . "/"
        . substr($originalmp3,0,strlen($originalmp3)-4) // original mp3 name minus the .mp3 extention
        . ".xml", 'w')
        or trigger_error(
		"Can't open the output file"
		, E_USER_ERROR);
    
	// now blat out the XML header
    fwrite($output_xml_handle, "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n");
	fwrite($output_xml_handle, "<!DOCTYPE Trans SYSTEM \"trans-zenpho-13.dtd\">\n");

	// uses mp3 filename from submission info
	fwrite($output_xml_handle, "<Trans scribe=\"zenpho\" audio_filename=\"$originalmp3\" version=\"2\" version_date=\"\">\n");
	fwrite($output_xml_handle, "<Speakers>\n");

	// add default selfclosing speaker tags
        // FIXME: could extract from submission info
	fwrite($output_xml_handle, "<Speaker id=\"spk1\" name=\"DEFAULT_SPEAKER_NAME\" check=\"no\" dialect=\"native\" accent=\"\" scope=\"local\"/>\n");
	fwrite($output_xml_handle, "</Speakers>\n");
	fwrite($output_xml_handle, "<Episode>\n");

	// produce a section tag using start and end times from skeleton
    $startTime = $obj_trs->firstTurnStartTime();
    $endTime = $obj_trs->lastTurnEndTime();
	fwrite($output_xml_handle, "<Section type=\"report\" startTime=\"$startTime\" endTime=\"$endTime\">");

    // for each turn tag in the skeleton, produce a corresponding turn and sync tag
    foreach ($obj_trs->eachTurn() as $turn){
            $startTime = $turn->_attr->STARTTIME;
            $endTime = $turn->_attr->ENDTIME;
			$splitFilename = $turn->_attr->SPLITFILENAME;
			
			// if approved
			if (in_array($startTime,$obj_approved->ary_times)){
				// then we open the text file for reading
				$transcript = "";
				$segment_txt_filename = $pathname . '/' . substr($splitFilename,0,-4) . ".txt";
				$segment_txt_handle = fopen($segment_txt_filename,'r')
					or trigger_error( "Can't open the segment text file for reading " . $segment_txt_filename
					, E_USER_ERROR);
				while ($file_content = fread($segment_txt_handle, 4096))
				{
					$transcript .= $file_content;
				}
				fclose($segment_txt_handle);
				$transcript = stripslashes($transcript); // strip slashes
				$transcript = htmlentities($transcript); // convert < to &lt (and others)
				
				// output an open turn tag, selfclosing sync tag, transcript text, and closeturn tag
				fwrite($output_xml_handle, 
					'<Turn startTime="' . $startTime . '" '
					. 'endTime="' . $endTime . '" '
					. 'speaker="spk1"' // FIXME: could extract from submission info . $ary_spktimes[$ary_times[$outputcount]] . '" '
					. '>'
					. "\n");
					
					fwrite($output_xml_handle,
						'<Sync time="' . $startTime . '" '
						. '/>' 
						. "\n");
						
					fwrite($output_xml_handle, $transcript . "\n");
					
				fwrite($output_xml_handle, "</Turn>\n");
				
				$output .= "Approved turn $startTime - $endTime\n";
				
			}
			else {
				// if NOT approved
				
				// output an open turn tag, selfclosing sync tag, EMPTY LINE, and closeturn tag
				fwrite($output_xml_handle, 
				'<Turn startTime="' . $startTime . '" '
				. 'endTime="' . $endTime . '" '
				. 'speaker="spk1"' // FIXME: could extract from submission info . $ary_spktimes[$ary_times[$outputcount]] . '" '
				. '>'
				. "\n");
				fwrite($output_xml_handle,
					'<Sync time="' . $startTime . '" '
					. '/>' 
					. "\n");                    
				fwrite($output_xml_handle, "\n"); // EMPTY LINE
				fwrite($output_xml_handle, "</Turn>\n");
			
				$output .= "Unapproved turn $startTime - $endTime\n";
			}
			
	}// foreach

    fwrite($output_xml_handle, 
        "</Section>\n"
        . "</Episode>\n"
        . "</Trans>\n");
    fclose($output_xml_handle);
    
    $output .= "Success for $pathname\n"
   		. "</pre>\n";
   		
   	return $output;
}

*/

?>