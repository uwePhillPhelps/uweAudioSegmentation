<html>
<body>
<?php

if (isset($_GET["status"])) // extract the pathname passed from the index script in the URL 
{
	$status = urldecode($_GET["status"]); // decode any %## format characters in the URL
	
	//open the submission info file
	$statusfilename = "macmini/macmini.status";
	$statusfilehandle = fopen($statusfilename, 'w') or die(
	  	"<b>Cannot open " . $statusfilename . " for writing</b><br>");
	  	
	// write status line
	date_default_timezone_set('UTC');
	$status .= " " . date("Y-F-j, G:i:s");  // 2001-March-10, 17:16
	fwrite($statusfilehandle, $status . "\n", 1024);
	fclose($statusfilehandle);
	
	echo "Successfully wrote status ($status)<br>";
}
else  // error if not passed a status message
{	
	echo "This script is normally called by an automated process<br>";
}
?>
</body>
</html>
