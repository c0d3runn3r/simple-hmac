<?php

	// Parameters
	$secret="Shh! This is secret!";


	// Check for the HMAC header
	$headers=getallheaders();
	if(!$authorization=$headers['Authorization']) {

		fail_authorization();
	}

	if(!check_authorization($secret, $authorization)) { 

		fail_authorization();
	}


	if(array_key_exists('resource', $_GET)) {

		$resource=$_GET['resource'];

	} else {

		$resource="";
	}

	print "Called with resource=$resource";

	print "Authorization: $authorization";


function check_authorization($secret, $authorization_header) {

	// Disassemble the SHA
	if(!preg_match('/^hmac (\d+):([^:]+):(.*)$/', $authorization_header, $matches)){

		return false;
	}

	print("timestamp: ".$matches[1]."\n");
	print("nonce: ".$matches[2]."\n");
	print("digest: ".$matches[3]."\n");

	exit();

	return false;


}

function fail_authorization() {


	header("HTTP:/1.0 401 Unauthorized");
	print("You are not authorized to access this resource");
	exit();
}



?>