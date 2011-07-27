<?php
/*
	taken from http://www.webcheatsheet.com/PHP/get_current_page_url.php

	replaced REQUEST_URL with PHP_SELF to omit any existing querystrings

*/

function curPageURL() {
 $pageURL = 'http';
 if ($_SERVER["HTTPS"] == "on") {$pageURL .= "s";}
 $pageURL .= "://";
 if ($_SERVER["SERVER_PORT"] != "80") {
  $pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"].$_SERVER["PHP_SELF"];
 } else {
  $pageURL .= $_SERVER["SERVER_NAME"].$_SERVER["PHP_SELF"];
 }
 return $pageURL;
}
?>