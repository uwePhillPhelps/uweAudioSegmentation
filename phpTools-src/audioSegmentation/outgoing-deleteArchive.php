<html>
<!-- 
As you can tell from the sheer.... quality of the code - this is just a prototype interface with
potentially lots and lots of bugs. 
Should you have any questions or comments, please email Phill Phelps at zenpho@zenpho.co.uk
or philip3.phelps@uwe.ac.uk

Thanks,
-->
<head>
	<title>transcription complete - </title>
<?php
// extract values from URL passed from the previous script
if (isset($_GET["pathname"]))
{
	// decode any %## format characters in the URL
	$pathname = urldecode($_GET["pathname"]); 

}
else // otherwise set to blank
{
	$pathname = '';
}
?>
	
	<link rel="STYLESHEET" href="style.css" type="text/css">
</head>
<body>
<?php
echo "<h3>Remove the temporary archive file $pathname</h3>";
?>

<div class="instructions">
<b>This page is not intended for human use!</b><br>
This php script is called from the win32 machine after transcription is complete. It is part of the mechanism for automatically moving data files between this PHP server and the speech recognition machine.<br>
This PHP page calls a shell script (outgoing-deleteArchive.sh) which deletes the file specified by the pathname variable in the URL.<br>
</div>
<br>

<?php
if (strlen($pathname)>0){
	
	echo "<pre>";
	
	//Strip whitespace (and tab,newline,etc) from the beginning and end of the arguments
	$pathname = trim($pathname);

	// build the command
	$command = 'bash outgoing-deleteArchive.sh '  . escapeshellarg($pathname);
	
	// print some debugging info
	echo "debugging info:\n";
	echo "directory : " . $pathname . "\n";
	echo "command to run is: ". $command. "\n";
	
	// run the command
	//$output = shell_exec($command); //not this one
	//$output = exec($command); // not this one either
	
	$output = system($command); // this one updates dynamically
	echo $output; // and print the debugging output
	echo "</pre>";
}
else
{
	die('ERROR: no filename was passed to this script - cannot continue!');
}

?>

<div class="instructions">
Actions: <a href="index.php">go back to the list of mp3 recordings awaiting processing</a>
</div>

</body>
</html>