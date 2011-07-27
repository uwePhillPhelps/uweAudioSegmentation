<html>
<!-- 
As you can tell from the sheer.... quality of the code - this is just a prototype interface with
potentially lots and lots of bugs. 
Should you have any questions or comments, please email Phill Phelps at zenpho@zenpho.co.uk
or philip3.phelps@uwe.ac.uk

Thanks,
-->
<head>
<title>Prepare for machine transcription</title>
<link rel="STYLESHEET" href="style.css" type="text/css">
</head>
<body>
<h3>Prepare uploaded recording for transcription</h3>
<ol>
    <li>Information about the recording is entered (e.g. preferred voice profile, short description, etc)</li>
    <li>The server then timecodes and segments the recording (e.g. based on pauses in speech, at regular intervals, etc)</li>
	<li>Each segment is then transcribed (either by machine, or manually)</li>
	<br>
	<li>If transcription is by machine...
		<ul>
			<li>An archive of the segments is prepared</li>
			<li>A separate transcription machine retrieves these archives and produces transcripts for each segment overnight</li>
			<li>The remote transcriotion machine then archives completed transcripts and sends back to this machine</li>
		<ul>
	</li>
	<br>
    <li>Transcriptions available for review are listed in the <a href="index.php">list of mp3 recordings awaiting processing</a></li>
</ol>
<?php

// globals
$scriptname = $_SERVER["SCRIPT_NAME"];

if (isset($_GET["pathname"])) // extract the pathname passed from the index script in the URL 
{
	$pathname = urldecode($_GET["pathname"]); // decode any %## format characters in the URL
	
	$dirname = dirname($pathname);
	$basename = basename($pathname);
			
	$just_filename = substr($basename,0, strlen($basename)-4); // minus the extention ".xyz" 4 characters
	$just_extention = substr($basename,strlen($basename)-4, strlen($basename)); 
    
    echo "<div class=\"instructions\">
        <b>Stage 1</b>
		<br>Use the embedded player to listen to the audio if required
        <br>Enter the requested information into the fields below
        </div>";
    
    // if an .m4a file is uploaded, convert to mp3 before processing further
    if ( substr_count( $just_extention, '.m4a') )
	{
		// alert the user of the conversion from M4A to MP3
		echo "<h3>WARNING! Audio in m4a format will be converted to mp3</h3>";
	
		// build the URL for the media player
		//$mediaPlayerURL = $_SERVER["HTTP_REFERER"] . $pathname;
		$mediaPlayerURL = $pathname;
	
		echo '
		<object CLASSID="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" 
			width="320"
			height="32"
			CODEBASE="http://www.apple.com/qtactivex/qtplugin.cab">
		<param name="src" value="' . $mediaPlayerURL . '">
		<param name="autoplay" value="false">
		<param name="loop" value="false">
		<param name="controller" value="true">
		<embed href="' . $mediaPlayerURL . '" 
			   src="' . $mediaPlayerURL . '" 
			   width="320" 
			   height="32"
			   autoplay="false" 
			   loop="false" 
			   controller="true" 
			   pluginspage="http://www.apple.com/quicktime/">
		</embed>
		</object> <-- quicktime player for source m4a recording
		';  
	}
	else if ( substr_count( $just_extention, '.mp3') )
	{
		// embedded mp3 player for previewing
		echo '
		<OBJECT id="audio_player" valign="top" align="right" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="330" height="80" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0">
		<PARAM name="allowScriptAccess" value="sameDomain">
		<PARAM name="movie" value="audio_player.swf?media=';
		
		echo urlencode($pathname) . '">' . "\n";
		
		echo '
		<PARAM name="quality" value="high">
		<PARAM name="scale" value="noscale">
		<PARAM name="salign" value="rt">
		<PARAM name="bgcolor" value="#ffffff">
		<EMBED src="audio_player.swf?media=';
	
		echo urlencode($pathname) . '" ';
		
		echo '
		quality="high" scale="noscale" salign="rt" bgcolor="#ffffff" width="330" height="80" name="audio_player" align="right" valign="top" allowscriptaccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer"></EMBED>
		</OBJECT>' . "\n";	
	}
	else 
	{
		// display error for filetypes without a compatible embedded player
		echo "<h3>ERROR! unknown audio format - no embedded audio player will be displayed</h3>";
	}
    
	
	}
else if (isset($_POST["pathname"])){ 
	// we may extract the pathname from the HTTP POST later
}
else // otherwise stop the whole process, we can't continue if we don't know what file we're dealing with!
{
	die('ERROR: no recording pathname was passed to this script - cannot continue!');
}

// if the form has been submitted back into itself correctly there'll be atleast
// descriptname, speakerlist, fullmp3name, with an OPTIONAL admincomment
// we write out to the this.submissioninfo file
if (isset($_POST["descriptname"])
	&& isset($_POST["speakerlist"])
	&& isset($_POST["fullmp3name"])
	&& isset($_POST["pathname"])
   )
{	

	$pathname = $_POST["pathname"]; // $_POST pathname overrides $_GET pathname
	$dirname = dirname($pathname);
	$basename = basename($pathname);
	$just_filename = substr($basename,0, strlen($basename)-4); // minus the extention ".xyz" 4 characters
	$just_extention = substr($basename,strlen($basename)-4, strlen($basename)); 

	$isFormSubmittedCorrectly = true;
	
	// check & extract required fields if form has been submitted
	if (isset($_POST["descriptname"])){
		$descriptname = $_POST["descriptname"];
		
		if ( strlen(trim($descriptname)) < 1 ){// if it's just whitespace
			echo "<br><b>ERROR: missing description!</b>";
			$isFormSubmittedCorrectly = false;
		}	
	}
	else{ // if it's empty
		die("<br><b>ERROR: Description field is mandatory - please enter a short description for the file</b>");
	}
	if (isset($_POST["speakerlist"])){
		$speakerlist = $_POST["speakerlist"];
		if ( strlen(trim($speakerlist)) < 1 ){// if it's just whitespace
			echo "<br><b>ERROR: missing list of speakers!</b>";
			$isFormSubmittedCorrectly = false;
		}
	}
	else {// if it's empty
		echo "<br><b>ERROR: All fields are required - please enter a name for atleast one speaker
		(names of multiple speaker should be separated by commas: E.g. speaker 1, speaker 2)</b>";
		$isFormSubmittedCorrectly = false;
	}

	// fullmp3name is $basename
	
	if (isset($_POST["admincomment"])){
		$admincomment = $_POST["admincomment"];
		if ( strlen(trim($admincomment)) < 1 ){// if it's just whitespace
			// the .submission info has a MANDATORY FOUR LINES set a default
			$admincomment = "no comment";
		}
	}

}

/////////////////
// start of form
/////////////////
echo "<form action=\"$scriptname\" method=\"post\">";
echo '<fieldset>';

// (64 character max) short description i.e. for sakai, projectpad, blackboard, etc
echo '<b>Short description of recording:</b>';
echo '<input type="text" name="descriptname" size=30 maxlength=64 value="'. $descriptname . '">';
echo '<br>';

// (1024 character max) list of speaker names
echo '<b>Speaker names (comma separated):</b>';
echo '<input type="text" name="speakerlist" size=30 maxlength=1024 value="'. $speakerlist . '">';
echo '<br>';

// (2048 character max) hidden field containing filename
echo '<input type="hidden" name="fullmp3name" maxlength=2048 value="'. $fullmp3name . '">';

// (2048 character max) comment
echo '<b>(optional) Comment for administration purposes:</b>';
echo '<input type="text" name="admincomment" size=30 maxlength=2048 value="'. $admincomment . '">'; 
echo '<br>';
	
// hidden field containing pathname that was in the URL
echo '<input type="hidden" name="pathname" value="'. $pathname . '">';
	
// submit button and end of form
echo '<input type="submit" value="Ok">';
echo '</fieldset>';
echo "</form>\n";

// process audio if the form has been submitted back into itself correctly
if ( $isFormSubmittedCorrectly == true )
{	
	
	$isAudioProcessed = false;
	
	////////////////////////////////////////////
	// do we need to convert from m4a format?
	////////////////////////////////////////////
	if ( substr_count( $just_extention, '.m4a') )
	{
		echo "<div class=\"instructions\">
		<b>Stage 1</b><br>
        Segmenting audio could take a while - the page will gradually update whilst the process is underway.
		</div>\n";
		
		echo "<div style=\"height: 200px; overflow: auto; border: 2px black solid; margin-bottom: 30px\">"
			. "<pre>";
	
		// build the command
		$command = 'bash incoming-m4asplit.sh' 
			. ' ' . escapeshellarg($dirname) 
			. ' ' . escapeshellarg($basename);
		
		// print some debugging info
		echo "command to run is: ". $command. "\n";
		echo "This part could take a while!\n";
		flush();
		
		// run the command
		$output = shell_exec($command);
		$output = stripcslashes($output);
		echo $output; // and print the debugging output
		
		flush();
		echo "</pre>" 
			. "</div>";	
		
		// if the script is successful, the segmented directory 
		// will contain an mp3 copy and skeleton.xml
		if ( !substr_count( $output, 'ERROR' )  
			&& file_exists( 'segmented/' . $just_filename . '/'
								 . $just_filename . '.mp3')
			&& file_exists( 'segmented/' . $just_filename . '/'
							. '/skeleton.xml')  )
		{
			$isAudioProcessed = true;

			// after converting m4a to mp3 we need to change the $basename
			$basename = $just_filename . ".mp3";
			$just_extention = ".mp3";
			$fullmp3name = $basename;
		}
		else {
			echo "<h3>ERROR - cannot proceed, segmentation failed.</h3>";
			die();
		}
	
		
	}
	else if ( substr_count( $just_extention, '.mp3') )
	{	
		//////////////////////
		// create directories
		//////////////////////
		echo "<div class=\"instructions\">
			<b>Stage 1a</b><br>
			Creating directory structure in $dirname
			make a directory $just_filename, move $basename into $just_filename directory 
			</div>";
		
		// chmod mp3 file 755
		//system('chmod 755 ' . escapeshellarg($basename)) or die(
		//    "error: could not chmod $basename to 755 (rwxr-xr-x)");
		
				echo "<div style=\"height: 200px; overflow: auto; border: 2px black solid; margin-bottom: 30px\">";
		
		// change into the directory derived from dirname($pathname) 
		chdir($dirname) or die( 
			 "error: cannot chdir into $dirname");
			
		// make a directory with the same name as the mp3 file (minus the .mp3 part)
		mkdir($just_filename) or die( 
			"error: cannot make directory $just_filename in $dirname");
	
		// change into this new directory";
		chdir($just_filename) or die(
			"error: cannot chdir into $dirname/$just_filename/");
	
		// move the mp3 file into the new directory
		$oldpath = '../' . $basename;
		$newpath = './' . $basename;
		rename($oldpath , $newpath) or die (
			"error: cannot move file from $oldpath to $newpath");	
		echo "</div>\n";
		
		 
		chdir('..'); // back up to apache document root/incoming/
		chdir('..'); // back up to apache document root/
		
		
		$pathname = 'incoming/' . $just_filename;
		
		echo "pathname set to $pathname<br>";
		echo "current path is " . getcwd() . "<br>";
				
		///////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////
		// segment mp3 recording
		///////////////////////////////////////
	
	   echo "<div class=\"instructions\">
			<b>Stage 2</b><br>
			Segmenting mp3 recording for $basename in $pathname
			</div>";
	
				echo "<div style=\"height: 200px; overflow: auto; border: 2px black solid; margin-bottom: 30px\">";
		
		$basename = basename($pathname);
		$mp3file = $just_filename . '.mp3';
		
		echo "<pre>";
		echo "Segmenting mp3 recording - this part could take a while!\n";
		flush();
			
		//Strip whitespace (and tab,newline,etc) from the beginning and end of the arguments
		$pathname = trim($pathname);
		$mp3file = trim($mp3file);
		$basename = trim($basename);
	
		// build the command
		$command = 'bash incoming-mp3splt.sh ' 
			. escapeshellarg($pathname) . ' ' 
			. escapeshellarg($mp3file) . ' ' 
			. escapeshellarg($basename);
		
		// print some debugging info
		echo "directory : " . $pathname . "\n";
		echo "mp3 : " . $mp3file . "\n";
		echo "basename : " . $basename . "\n";
		echo "command to run is: ". $command. "\n";
		
		// run the command
		//$output = shell_exec($command);
		//$output = exec($command);
		$output = system($command);
		echo $output; // and print the debugging output
		echo "</pre>";
		
		///////////////////////////
	
		$pathname = 'segmented/' . $basename;
	
		echo "</div>\n";
		echo "set pathname to " . $pathname;
		
		///////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////
		// create empty text segments for each mp3 file
		///////////////////////////////////////
	
	   echo "<div class=\"instructions\">
			<b>Stage 3</b><br>
			Archiving segments for remote machine-transcription
			</div>";
	
				echo "<div style=\"height: 200px; overflow: auto; border: 2px black solid; margin-bottom: 30px\">";
		
		echo "<pre>";
		echo "Preparing archive for machine-transcription - this could take a while!\n";
		flush();
		
		$basename = basename($pathname);
		$archivename = 'outgoing/' . $basename . '.tgz';
		
		$pathname = trim($pathname);
		$basename = trim($basename);
		$archivename = trim($archivename);
		
		// build the command
		$command = 'bash segmented-makeArchive.sh '  . escapeshellarg($archivename) . ' ' . escapeshellarg($pathname);
		
		// print some debugging info
		echo "debugging info:\n";
		echo "directory : " . $pathname . "\n";
		echo "basename : " . $basename . "\n";
		echo "command to run is: ". $command. "\n";
		
		// run the command
		//$output = shell_exec($command);
		//$output = exec($command);
		$output = system($command);
		echo $output; // and print the debugging output
		echo "</pre>";
		echo "</div>\n";
		
		echo "<div class=\"instructions\">
		<b>Stage 4 - waiting for machine transcription</b><br>
			An archive is now prepared - please return to the <a href=\"index.php\">list of mp3 recordings awaiting processing</a>
			</div>\n";

		$isAudioProcessed = true;
	
	}
	else
	{
		echo "<h3>ERROR! unknown audio format $just_extention - cannot proceed!</h3>";
	}
	
	///////////////////////////////////////////////////////////////////////////////////	
	
	///////////////////////////////////////
	// prepare to write to the .submissioninfo file
	///////////////////////////////////////

	$subfilename = "segmented/$just_filename/this.submissioninfo";

	if  ( $isAudioProcessed != true )
	{
		die( "<b>Error creating $subfilename</b>");	
	}
	else {
		echo "<div class=\"instructions\">
			<b>Stage 2</b><br>
			Preparing $subfilename file
			</div>";
	
		echo "<div style=\"height: 200px; overflow: auto; border: 2px black solid; margin-bottom: 30px\">";
		echo "<pre>";
		echo "Preparing $subfilename file\n";
		flush();
	
		// abort if file exists
		if ( file_exists( $subfilename ) ) {
			echo "<b>ERROR - $subfilename already exists</b>";
		}
		else {
			$filehandle = fopen($subfilename, 'w') or die(
				"<b>Error opening $subfilename for writing</b>");
			
			// write all four lines
			fwrite($filehandle, $descriptname . "\n", 64);
			fwrite($filehandle, $speakerlist . "\n", 1024);
			fwrite($filehandle, $basename . "\n", 2048);
			fwrite($filehandle, $admincomment . "\n", 2048);
			
			// write the footer  
			fwrite($filehandle, "# ###########################\n");
			fwrite($filehandle, "# \n");
			fwrite($filehandle, "# Human readable file format:\n");
			fwrite($filehandle, "# 1st line - Short name/description Sakai/PPad/Blackboard entry name\n");
			fwrite($filehandle, "# 2nd line - Names of speakers (comma separated)\n");
			fwrite($filehandle, "# 3rd line - MP3 filename\n");
			fwrite($filehandle, "# 4th line - Notes/comments ****BRIEF, ONE LINE ONLY****\n");
			fwrite($filehandle, "# 5th line and onward ignored\n");
			
			fclose($filehandle);
			
			echo "Successfully wrote submission information to $subfilename<br>";
			print_r($_POST);
			echo $descriptname . "\n";
			echo $speakerlist . "\n";
			echo $basename . "\n";
			echo $admincomment . "\n";
		}
		echo "</pre>"
			. "</div>";
            
        // move the processed files into the transcribe directory
		echo "<div class=\"instructions\">
			<b>Stage 3</b><br>
			Moving files to transcribe directory
			</div>";
            
        echo "<div style=\"height: 200px; overflow: auto; border: 2px black solid; margin-bottom: 30px\">"
			. "<pre>";
        
        $oldpath = 'segmented/' . $just_filename;
		$newpath = 'transcribe/'. $just_filename;
        
        // abort if already moved
        if ( file_exists( $newpath ) ){
            echo "<b>ERROR</b> - files already exist at $newpath<br>\n";
        }
        else {
            echo "Moving files from $oldpath to $newpath<br>";
            rename($oldpath , $newpath) or die (
                "error: cannot move files from $oldpath to $newpath");
            
        }
        
        echo "</pre>"
            . "</div>\n";
        
	}
    
    
		
}
?>
</body>
</html>
