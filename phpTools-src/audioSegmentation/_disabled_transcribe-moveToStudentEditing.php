<html>
<!-- 
As you can tell from the sheer.... quality of the code - this is just a prototype interface with
potentially lots and lots of bugs. 
Should you have any questions or comments, please email Phill Phelps at zenpho@zenpho.co.uk
or philip3.phelps@uwe.ac.uk

Thanks,
-->
<head>
	<title>Prepare for student editing - 
<?php
// extract values from URL passed from the previous script
if (isset($_GET["pathname"]))
{
	// decode any %## format characters in the URL
	$pathname = urldecode($_GET["pathname"]); 

	$basename = basename($pathname);
}
else // otherwise set them all to blank
{
	$pathname = '';
	$basename = '';
}
?>
	</title>
	<link rel="STYLESHEET" href="style.css" type="text/css">
</head>
<body>
<?php
echo "<h3>Prepare for student editing</h3>";
?>

<div class="instructions">
<br>This page will attempt to update dynamically as the archive process is underway.
<br>It is safe to return to the main <a href="index.php">list of mp3 recordings awaiting processing</a> now if you dont want to wait, but some useful debugging info is shown here after the process ends.
</div>
<br>

<?php

require_once('transcribe_symlink/../timecodelistclass.inc'); // for approval and allocation timecodes

if (strlen($pathname)>0){
	
	//Strip whitespace (and tab,newline,etc) from the beginning and end of the arguments
	$pathname = trim($pathname);
	$basename = trim($basename);
	$symlinkname = 'transcribe_symlink/' . $basename;

	echo "<pre>";
        
	// create allocation and approval data files
        if ( !file_exists($pathname . "/allocatedTimes.data") ) {
            $obj_allocated = new timecodeList();
            file_put_contents($pathname . "/allocatedTimes.data", serialize($obj_allocated))
		or trigger_error("cannot write allocation timecode file"
		,E_USER_ERROR);
	     echo "Created allocation file for $pathname successfully<br>";
        }
	
        
        if ( !file_exists($pathname . "/approvedTimes.data") ) {            
            $obj_approved = new timecodeList();
            file_put_contents($pathname . "/approvedTimes.data", serialize($obj_approved))
		or trigger_error("cannot write approval timecode file"
		,E_USER_ERROR);
            echo "Created approval file for $pathname successfully<br>";
        }
	
	//  to copy files
	$command = 'mv -v '  . escapeshellarg($pathname) . ' ' . escapeshellarg($symlinkname);
	
	// print some debugging info
	echo "debugging info:\n";
	echo "directory : " . $pathname . "\n";
	echo "basename : " . $basename . "\n";
	echo "command to run is: ". $command. "\n";
	
	// run the command
	//$output = shell_exec($command);
	//$output = exec($command);
	$output = system($command)
		or trigger_error("There was a problem running the command " . $command
		,E_USER_ERROR);;
	echo $output; // and print the debugging output
	echo "</pre>";


}
else
{
	die('ERROR: no filename was passed to this script - cannot continue!');
}

?>

<div class="instructions>
Actions: <a href="index.php">go back to the list of mp3 recordings awaiting processing</a>
</div>

</body>
</html>