<?php
//
//  Google Places API - Place Details
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
$placeID = $_GET['placeid'];  // valid placeID
$opt = $_GET['opt'];  		  // options flag (optional)

if($opt=="test") // override query string (for testing)
	$place_id = "ChIJV2BQ4laeekgRFauLvdXbFXE";

// generate request URL
$type = "json";
$url = "https://maps.googleapis.com/maps/api/place/details/".$type;
$url .= "?key=".$apiKey;
$url .= "&placeid=".$placeID;

// fetch google places API response
$response = fetchRemoteWebpage($url);
$error = $response["error_desc"];
$errcode = $response["error_code"];
$content = $response["content"];

// refactor JSON response
$json = array();
$goog = json_decode($content);
$json['status'] = $goog->status;
$json['error'] = $error;
$result = $goog->result;

// flatten location data into a single object for easier parsing
$json['data'] = array();
$json['data']['lat'] = $result->geometry->location->lat;
$json['data']['lng'] = $result->geometry->location->lng;
$json['data']['ne_lat'] = $result->geometry->viewport->northeast->lat;
$json['data']['ne_lng'] = $result->geometry->viewport->northeast->lng;
$json['data']['sw_lat'] = $result->geometry->viewport->southwest->lat;
$json['data']['sw_lng'] = $result->geometry->viewport->southwest->lng;

// re-encode
$output = json_encode($json);

// output JSON response
header('Content-Type: application/json');
echo $output;
die();

?>