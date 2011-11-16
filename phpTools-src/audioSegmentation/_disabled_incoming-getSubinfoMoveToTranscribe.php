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
Test - moving directory / file manipulation stuff to .sh script

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
}
else if (isset($_POST["pathname"])){ 
	// we may extract the pathname from the HTTP POST later
}
else // otherwise stop the whole process, we can't continue if we don't know what file we're dealing with!
{
	die('ERROR: no recording pathname was passed to this script - cannot continue!');
}

// TODO - check these values more efficiently with a function
// perhaps something like:
//    isFormSubmittedCorrectly( $_POST, $fieldName, $defaultValue );
//    containing numeric/textual tests, invoked depending on $_POST[$fieldName]

// if the form has been submitted back into itself correctly there'll be atleast
// descriptname, speakerlist, fullmp3name, and pathname (admincomment is OPTIONAL)
// later, we write these values out to filename 'this.submissioninfo'
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
	$missingFormFields = Array();
	
	// check & extract required fields if form has been submitted
	
	// descriptive name
	if ( !isset($_POST["descriptname"]) 
	     || (isset($_POST["descriptname"]) && strlen(trim($_POST["descriptname"])) < 1 )
	   )
	{
		array_push( $missingFormFields, "descriptname" );
		$isFormSubmittedCorrectly = false;
		
		echo "<b>ERROR: missing description</b><br>"
			. "\n";
	}
	else
	{
		$descriptname = $_POST["descriptname"];
	}
	
	// speaker list
	if ( !isset($_POST["speakerlist"]) 
	     || (isset($_POST["speakerlist"]) && strlen(trim($_POST["speakerlist"])) < 1 )
	   )
	{
		array_push( $missingFormFields, "speakerlist" );
		$isFormSubmittedCorrectly = false;
		
		echo "<b>ERROR: missing speaker list</b><br>"
			. "\n";
	}
	else
	{
		$speakerlist = $_POST["speakerlist"];
	}
}

// default values for fields

// default admin comment
if ( !isset($_POST["admincomment"]) 
	 || (isset($_POST["admincomment"]) && strlen(trim($_POST["admincomment"])) < 1 )
   )
{
	$admincomment = "no comment";
}
else
{
	$admincomment = $_POST["admincomment"];
}	

// sanitise POST value of segmentation mode
if (isset($_POST['segmentationMode'])){
	$segmentationMode = $_POST['segmentationMode'];
		
	// one of two valid options
	if ( $segmentationMode !== 'regularIntervals'
		&& $segmentationMode !== 'naturalSpeechPauses'){
		echo "<br><b>ERROR: segmentation mode must be either
			regularIntervals or naturalSpeechPauses!</b>";
		$isFormSubmittedCorrectly = false;
	}
}
else // set default value
{
	$segmentationMode = 'naturalSpeechPauses';
}

// sanitise POST value of natural speech pause segmentation threshold 
if (isset($_POST['segmentationThreshold'])){
	$segmentationThreshold = $_POST['segmentationThreshold'];
	if ( strlen(trim($segmentationThreshold)) < 1 ){// if it's just whitespace
		echo "<br><b>ERROR: missing segmenation threshold!</b>";
		$isFormSubmittedCorrectly = false;
	}
	else if( $segmentationThreshold >= 0 ){ // if above 0dBFS
		echo "<br><b>ERROR: segmenation threshold cannot be at or above 0dBFS!</b>";
		$isFormSubmittedCorrectly = false;
	}
}
else // set default value
{
	$segmentationThreshold = -30;
}

// sanitise POST value of natural speech pause segmentation count
if (isset($_POST['segmentationCount'])){
	$segmentationCount = $_POST['segmentationCount'];
	if ( strlen(trim($segmentationCount)) < 1 ){// if it's just whitespace
		echo "<br><b>ERROR: missing segmenation count!</b>";
		$isFormSubmittedCorrectly = false;
	}
	else if( $segmentationCount <= 0 ){ // if zero or below
		echo "<br><b>ERROR: segmenation threshold cannot be zero (or below)!</b>";
		$isFormSubmittedCorrectly = false;
	}
}
else // set default value
{
	$segmentationCount = 120;
}

// sanitise POST value of segmentation interval 
if (isset($_POST['segmentationInterval'])){
	$segmentationInterval = $_POST['segmentationInterval'];
	if ( strlen(trim($segmentationInterval)) < 1 ){// if it's just whitespace
		echo "<br><b>ERROR: missing segmenation interval!</b>";
		$isFormSubmittedCorrectly = false;
	}
	else if( $segmentationInterval < 0.1 ){ // if below 0.1 minutes (6 sec)
		echo "<br><b>ERROR: segmenation interval cannot be below 0.1 minutes (6 sec)</b>";
		$isFormSubmittedCorrectly = false;
	}
}
else // set default value (1 minute)
{
	$segmentationInterval = 1;
}


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
			. ' ' . escapeshellarg($basename)
			. ' ' . escapeshellarg($segmentationInterval);
		
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
		///////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////
		// segment mp3 recording
		///////////////////////////////////////
	
	   echo "<div class=\"instructions\">
			<b>Stage 2</b><br>
			Segmenting mp3 recording for $basename in $pathname
			</div>";
		
		$basename = basename($pathname);
		$mp3file = $just_filename . '.mp3';
		
		echo "<div style=\"height: 200px; overflow: auto; border: 2px black solid; margin-bottom: 30px\">"
			. "<pre>";
	
		// build the command
		$command = 'bash incoming-mp3shntool.sh' 
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
		echo "</pre>";
		echo "</div>";
		
		///////////////////////////
	
		// if the script is successful, the segmented directory 
		// will contain an mp3 copy and skeleton.xml
		if ( !substr_count( $output, 'ERROR' )  
			&& file_exists( 'segmented/' . $just_filename . '/'
								 . $just_filename . '.mp3')
			&& file_exists( 'segmented/' . $just_filename . '/'
							. '/skeleton.xml')  )
		{
			$isAudioProcessed = true;
		}
		else {
			echo "<h3>ERROR - cannot proceed, segmentation failed.</h3>";
			die();
		}
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
    
    
    echo "Return to the <a href=\"index.php\">list of mp3 recordings awaiting processing</a>";
    
		
}
?>
</body>
</html>
