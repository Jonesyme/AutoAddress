<?php
//
//  Google Places API - Place Search Relay
//  Method: GET 
//  Format: JSON
//

include_once('../library.php');

// Validate Session
// Note: this is NOT secure enough for production environments.  In the interest of time, I limited security...
$apiKey = secretGoogleAPIKey();
if($apiKey=="") // validate google key
	die("Invalid API Key");
if(!validateAPICode($_GET['code'])) // validate client key
	die("Invalid DWS Key");

// input parameters (NOTE: pass-thru to google so no need to sanitize)
$str = $_GET['str'];  // search string
$opt = $_GET['opt'];  // options flag (optional)

$options = array('min' => true);
if($opt=="raw") // output raw JSON response from google
	$options['min'] = false;
if($opt=="test") // override query string (for testing)
	$str = "Marthas";

// generate request URL
$type = "json";
$url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/".$type;
$url .= "?key=".$apiKey;
$url .= "&inputtype=textquery"; // limited to textquery for now, no phone number search...
$url .= "&input=".$str;

// fetch google places results
$response = fetchRemoteWebpage($url);
$error = $response["error_desc"];
$content = $response["content"];

// decode and minimize JSON response (if requested)
$json = array();
if($options["min"]) {
	// decode google response
	$goog = json_decode($content);
	$list = $goog->predictions;
	
	// parse out only what we want
	$json['status'] = $goog->status;
	$json['error'] = $error;
	$json['list'] = $list;
} else {
	$json = json_decode($content);
}

// homogenize JSON structure for easier consumption via mobile app
$output = json_encode($json);

// output JSON response
header('Content-Type: application/json');
echo $output;
die();

?>