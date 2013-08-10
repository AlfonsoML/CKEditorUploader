<?php
// Upload script for CKEditor.
// Use at your own risk, no warranty provided. Be careful about who is able to access this file
// The upload folder shouldn't be able to upload any kind of script, just in case.
// If you're not sure, hire a professional that takes care of adjusting the server configuration as well as this script for you.
// (I am not such professional)

// Step 1: change the true for whatever condition you use in your environment to verify that the user
// is logged in and is allowed to use the script
if ( true ) {
	echo("You're not allowed to upload files");
	die(0);
}

// Step 2: Put here the full absolute path of the folder where you want to save the files:
// You must set the proper permissions on that folder (I think that it's 644, but don't trust me on this one)
// ALWAYS put the final slash (/)
$basePath = "/home/user/example.com/files/";

// Step 3: Put here the Url that should be used for the upload folder (it the URL to access the folder that you have set in $basePath
// you can use a relative url "/images/", or a path including the host "http://example.com/images/"
// ALWAYS put the final slash (/)
$baseUrl = "/files/";

// Done. Now test it!



// No need to modify anything below this line
//----------------------------------------------------

// ------------------------
// Input parameters: optional means that you can ignore it, and required means that you
// must use it to provide the data back to CKEditor.
// ------------------------

// Optional: instance name (might be used to adjust the server folders for example)
$CKEditor = $_GET['CKEditor'] ;

// Required: Function number as indicated by CKEditor.
$funcNum = $_GET['CKEditorFuncNum'] ;

// Optional: To provide localized messages
$langCode = $_GET['langCode'] ;

// ------------------------
// Data processing
// ------------------------

// The returned url of the uploaded file
$url = '' ;

// Optional message to show to the user (file renamed, invalid file, not authenticated...)
$message = '';

// in CKEditor the file is sent as 'upload'
if (isset($_FILES['upload'])) {
    // Be careful about all the data that it's sent!!!
    // Check that the user is authenticated, that the file isn't too big,
    // that it matches the kind of allowed resources...
    $name = $_FILES['upload']['name'];

	// It doesn't care if the file already exists, it's simply overwritten.
	move_uploaded_file($_FILES["upload"]["tmp_name"], $basePath . $name);

    // Build the url that should be used for this file   
    $url = $baseUrl . $name ;

    // Usually you don't need any message when everything is OK.
//    $message = 'new file uploaded';   
}
else
{
    $message = 'No file has been sent';
}
// ------------------------
// Write output
// ------------------------
// We are in an iframe, so we must talk to the object in window.parent
echo "<script type='text/javascript'> window.parent.CKEDITOR.tools.callFunction($funcNum, '$url', '$message')</script>";

?>