<?php
/*  
    As you can tell from the sheer.... quality of the code - this is just a
    prototype with potentially lots and lots of bugs. 
	
	Should you have any questions or comments (not necessarily jibes at my
	hilariously inefficient php code) please email me at zenpho@zenpho.co.uk
	or philip3.phelps@uwe.ac.uk

	Thanks,
	
	========================================================================
*/
    // avoid browser cache
    header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0"); // HTTP/1.1
    header("Cache-Control: post-check=0, pre-check=0", false);
    header("Pragma: no-cache"); // HTTP/1.0

?>
<html>
<!-- 
As you can tell from the sheer.... quality of the code - this is just a prototype interface with
potentially lots and lots of bugs. 
Should you have any questions or comments, please email Phill Phelps at zenpho@zenpho.co.uk
or philip3.phelps@uwe.ac.uk

Thanks,
-->
<head>
	<title>Monitor and process uploaded audio recordings</title>
	<link rel="STYLESHEET" href="style.css" type="text/css">
    <script src="collapse.js" type="text/javascript" ></script> 
</head>
<body>
<h3>Monitor and process uploaded audio recordings</h3>
<br>
<center>
<?php
// link to start periodic TRS XML conversion
$encodedpathname = '';

/*
 * disabled
 *

// link to periodically merge 'approved' segments into TRS XML files
echo "<br>"
	. "<a href=\"/admin-periodicTRSXML.php\">"
	. "periodically create TRS XML (for student search)"
	. " </a>";
*/

// print the table headers
echo "
<table border=1>
<th width=\"10px\">#</th>
<th>Status</th>
<th width=\"*\">Recording mp3 filename</th>
<th>Actions</th>
";

// we count the files found to print an message if there's no files
$filecount = 0;

// look in the ./incoming directory for ORIGINAL MP3 FILES needing submission information
foreach (new DirectoryIterator('incoming') as $file) {

	// convert the filename to lowercase for substring comparisons
	$lowercasefilename = strtolower($file->getFilename());

	if ( (!$file->isDot()) // if not a dot file (dot , dot dot)
		 && !$file->isDir() // is not a directory
		 && !substr_count( $lowercasefilename, '._' )
		 && 
		 (    substr_count ( $lowercasefilename, '.m4a') 
		   || substr_count ( $lowercasefilename, '.mp3')
		 )
	)
	{
		// fixing filename - 20 character max
        // process the filename to strip out any "unsafe" or "unwise" content
		// e.g. HTML tags, spaces, non alphanumeric characters
		$lowercasefilename = strip_tags($lowercasefilename);
		$newFilename = preg_replace("/[^\.a-zA-Z0-9]/", "", $lowercasefilename);

        // if characters >= 20 combine first 10 then last 10
        $newFilenameLen = strlen($newFilename);
        if ( $newFilenameLen >= 20 )
        {
            $newFilename = substr( $newFilename, 0, 10 )
                        . substr( $newFilename, -10, 10);
        }

		$filenameDelta = strlen($file->getFilename()) - strlen($newFilename);
		$newPathname = $file->getPath().'/'.$newFilename;
	
		// rename file to the "safe" filename
		if ($filenameDelta != 0){
			rename($file->getPathname(), $newPathname);
					
			writeTableRow('--', 'Fixing filename', 
				"Original filename: " . $file->getFilename() . "<br>\n"
				. "Renamed filename: " . $newFilename . "<br>\n", 
				"removed $filenameDelta characters");
		}
		$filecount = $filecount + 1; // keep track of how many files we've counted
		
		// encode characters in the pathname and filename into %## format for URLs
		// double encode because on some Apache servers mod_rewrite messes up '+' character
		$encodedpathname = urlencode(urlencode($newPathname));
		
		// these files need sgementation
		$action = "<a href=\"incoming-getSubinfoMoveToTranscribe.php?pathname="
							. $encodedpathname // the full path to the file
							. "\">" // close the A tag
							. "Description needed!"
							. " </a>";
		/*

		$action .= "<br>"; // and another option

		$action .= "<a href=\"incoming-emptyTextStudentEditing.php?pathname="
							. $encodedpathname // the full path to the file
							. "\">" // close the A tag
							. "Empty segments student editing"
							. " </a>";
		*/
			
		writeTableRow($filecount, $file->getPath(), $newFilename, $action);
	}

}

// look in the ./segmented directory for 
// DIRECTORIES that might need to be moved
foreach (new DirectoryIterator('segmented') as $file) {

 if ( !$file->isDot() // if not a dot file (dot , dot dot)
	 && $file->isDir() // is definitely a directory
     && file_exists($file->getPathname() . '/this.submissioninfo') 
     && file_exists($file->getPathname() . '/split_wav')
     )
	{
		// encode characters in the pathname and filename into %## format for URLs
		// double encode because on some Apache servers mod_rewrite messes up '+' character
		$encodedpathname = urlencode(urlencode($file->getPathname()));

		$filecount = $filecount + 1; // keep track of how many files/dirs we've counted
				
		$action = "<a href=\"transcribe-previewViewer.php?pathname="
				. $encodedpathname
				. "\">" // close the A tag
				. "review timecoding"
				. " </a>";

		writeTableRow($filecount, $file->getPath(), $file->getFilename(), $action );	
   }
}

/*
	***********************************************************
	these disabled processing options from a previous version
	originally dealt with moving files to and from an external
	machine for transcription
	***********************************************************

// look in the ./incoming directory for DIRECTORIES with a this.submission info inside
foreach (new DirectoryIterator('incoming') as $file) {

   if ( (!$file->isDot()) // if not a dot file (dot , dot dot)
		 && $file->isDir() // is definitely a directory
		 && file_exists($file->getPathname() . '/this.submissioninfo') // and has a this.submission info file inside
	  ) 
	{
	       // encode characters in the pathname and filename into %## format for URLs
	       // double encode because on some Apache servers mod_rewrite messes up '+' character
	       $encodedpathname = urlencode(urlencode($file->getPathname()));

		$filecount = $filecount + 1; // keep track of how many files we've counted
		
		// these files need sgementation
		$action = "<a href=\"incoming-callMp3splt.php?pathname="
		        . $encodedpathname // Pathname() passes the full path
				. "\">" // close the A tag
				. "Segment recording"
				. " </a>";
			
		writeTableRow($filecount, $file->getPath(), $file->getFilename(),$action);	
		
   }
}

// now look in the OUTGOING directory for .tgz files being sent off to the win32 machine
foreach (new DirectoryIterator('outgoing') as $file) {

   // convert the filename to lowercase for substring comparisons
   $lowercasefilename = strtolower($file->getFilename());

   if ( (!$file->isDot()) // if not a dot file (dot , dot dot)
		 && (substr_count( $lowercasefilename, '.tgz') > 0) ) // and definitely has .tgz in the name
	{
		$filecount = $filecount + 1; // keep track of how many files we've counted
		
		$action = "-waiting for machine transcription-";
			
		// these files can be reviewed and/or convertuploaded
		writeTableRow($filecount, $file->getPath(), $file->getFilename() ,$action);		
    }
}

// now look in the ./transcribe directory for TGZ ARCHIVES that are returned by the naturally speaking server
$needToUnpackReturnedArchives = false;
foreach (new DirectoryIterator('transcribe') as $file) {

  // convert the filename to lowercase for substring comparisons
  $lowercasefilename = strtolower($file->getFilename());
  
  // encode characters in the pathname and filename into %## format for URLs
  // double encode because on some Apache servers mod_rewrite messes up '+' character
  $encodedpathname = urlencode(urlencode($file->getPathname()));

   if ( 	 !$file->isDot() // if not a dot file (dot , dot dot)
		 && !$file->isDir() // is NOT a directory
		 && substr_count( $lowercasefilename, '.tgz') // and name contains ".tgz" 
      ) 
	{
		$filecount = $filecount + 1; // keep track of how many files we've counted
		$needToUnpackReturnedArchives = true;
		
		// these files need unpacking
		$action = "Processing returned archive";
		$status = "<img src=\"images/exclamation_triangle_red.png\" width=\"18\" height=\"18\" align=\"left\">";
		$status .= "machine transcription complete";
		
		writeTableRow($filecount, $status, $file->getFilename(),$action);
	}
	
}

*/

// look in the ./transcribe directory for 
// DIRECTORIES with transcript segments that have been unpacked
foreach (new DirectoryIterator('transcribe') as $file) {

 if ( !$file->isDot() // if not a dot file (dot , dot dot)
	 && $file->isDir() // is definitely a directory
     && file_exists($file->getPathname() . '/this.submissioninfo') )
	{
		// encode characters in the pathname and filename into %## format for URLs
		// double encode because on some Apache servers mod_rewrite messes up '+' character
		$encodedpathname = urlencode(urlencode($file->getPathname()));

		$filecount = $filecount + 1; // keep track of how many files/dirs we've counted
				
		$action = "<a href=\"transcribe-previewViewer.php?pathname="
				. $encodedpathname
				. "\">" // close the A tag
				. "review transcript"
				. " </a>";

		$action .= "<br>"; // another action	

		$action .= "<a href=\"transcribe-generateSRT.php?pathname="
				. $encodedpathname
				. "\">" // close the A tag
				. "generate SRT subtitles"
				. " </a>";	

		$action .= "<br>"; // another action

		$action .= "<a href=\"transcribe-moveToStudentEditing.php?pathname="
			. $encodedpathname
			. "\">" // close the A tag
			. "move to student editing"
			. " </a>";	

		writeTableRow($filecount, $file->getPath(), $file->getFilename(), $action );	

		/*
		$action = "<a href=\"transcribe-showWaiting.php\">"
				. $review = "show ALL transcripts"
				. "</a>"
				. " <br> ";
		
		$action .= "<a href=\"transcribe-testTimeline.php?pathname="
				. $encodedpathname
				. "\">" // close the A tag
				. "show timeline"
				. " </a>";

		*/		
   }
}

// look in the ./transcribe_symlink directory for 
// for DIRECTORIES visible in the STUDENT SYSTEM
foreach (new DirectoryIterator('transcribe_symlink') as $file) {

 if ( !$file->isDot() // if not a dot file (dot , dot dot)
	 && $file->isDir() // is definitely a directory
     && file_exists($file->getPathname() . '/this.submissioninfo') )
	{
		$linkpathname = 'transcribe/' . basename($file->getPathname());
		// double encode because on some Apache servers mod_rewrite messes up '+' character
		$encodedpathname = urlencode(urlencode($linkpathname));

		$filecount = $filecount + 1; // keep track of how many files/dirs we've counted

		$action = "<a href=\"/lecturer_viewer.php?pathname="
				. $encodedpathname
				. "\">" // close the A tag
				. "View editing by students (lecturer login)"
				. " </a>";

		// and for consolidating searchable TRS XML
		//
		$action .= "<br>"
		. "<a href=\"/test-convertTRSXML.php?pathname="
		. $encodedpathname
		. "\">" // close the A tag
		. "Create TRS XML (for student search)"
		. " </a>";

		$status = "<img src=\"images/kirby.png\" width=\"18\" height=\"18\" align=\"left\">";
		$status .= 'student editing'; // .= $file->getPath()
		
		writeTableRow($filecount, $status, $file->getFilename(), $action );	
		
   }
}

echo "</table>\n"; // always close the table
echo $filecount . " files found";

if ($filecount == 0){ // if there are no files - print a message to that effect
	echo "	<font color=\"red\" size=\"+3\">
	<b>There are no mp3 recordings to process</b>
	</font>
	- no further action can be taken at this time";
}


function writeTableRow($filecount,$status,$filename,$action){
	// each file needs a new table row

	if ( $status == "incoming" )
		echo "<tr bgcolor=\"Magenta\">";
	else if ( $status == "transcribe" )
		echo "<tr bgcolor=\"Khaki\">";
	else
		echo "<tr>";

	
	// fill the number column
	echo "<td>". $filecount . "</td>\n";
   
	// fill the status column
	echo "<td>". $status . "</td>\n";
   
    // Fill the filename column
    echo "<td align=\"center\">". $filename . "</td>\n"; 
	 
	// fill the action column
	echo "<td align=\"right\"> ". $action ." </td>\n";
	
	// end the table row to begin a new one later
    echo "</tr>";
}
?>


</center>
<br><br>
<script type="text/javascript">
	/* if javascript is on, create a link to show/hide instructions */
	document.write('<a href="#" onclick="collapse(\'instructions\');return false">Show/hide instructions</a>');
</script>
<div class="instructions hidden" id="instructions">
<b>Instructions:</b>
To upload recordings for processing - <a href="ftp://ppad:@<?php echo $_SERVER[SERVER_ADDR]; ?>/Public/Drop Box/">Connect via FTP</a> or 
or <a href="afp://incoming:@<?php echo $_SERVER[SERVER_ADDR]; ?>/Public/Drop Box/">connect via AFP</a><br>
You can then use this interface to monitor and manage the various processing stages (where each row in the table above represents a file or group of files).<br>
</p>
<p>
<b>Processing uploaded recordings is only semi-automated:</b></li>
<ul>
	<li>Some things can be processed automatically, other things require a choice to be made.<br></li>
	<li>Automatic processing information for each file (or group of files) appear in the <b>status</b> column.</li>
	<li>Manual choices about processing for each file (or group of files) appear as <b>links</b> in the </b>actions</b> column.</li>
</ul>
<b>Normally each uploaded recording will be processed in the following sequence:</b>
<ol>
<li>Manual description (adding information about who is speaking on the recording, etc)
<li>Automated segmentation (Mp3splt: splitting into paragraph chunks, based on pauses in speech)</li>
<li>Automated transcription (Naturally Speaking: speech recognition)</li>
<li>Manual review and export to student editing/marking system (collaborative proof-reading and correction of machine-transcribed text)</li>
	<ul>
		<li>including comprehensive timecoded transcript audio/text viewers with timelines,search,and cross referencing tools</li>
	</ul>	
</ol>
</div>

<?php
if ($needToUnpackReturnedArchives == true){
	echo "<h3>Machine transcription archives were found</h3>";
	echo "<div class=\"instructions\">";
	echo "<b>Information:</b> We now run a script to unpack all .tgz archives that have returned from the Naturally Speaking server, and may take some time<br>";
	echo "<br>This page will attempt to update dynamically as the process is underway - but in the event that the process takes so long that your browser times out; simply refresh the <a href=\"index.php\">list of mp3 recordings awaiting processing</a> where the resultant files will be available for further processing in due course.";
	echo "</div><hr>";
	
		echo "<pre>";
	
		// build the command
		$command = 'bash transcribe-unpackAllReturnedArchives.sh';
		
		// print some debugging info
		echo "command to run is: ". $command. "\n";
		
		// run the command
		//$output = shell_exec($command);
		//$output = exec($command);
		$output = system($command);
		echo $output; // and print the debugging output
		echo "</pre>";
}		
?>
</body>
</html>