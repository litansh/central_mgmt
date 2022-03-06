<?php
// change the name below for the folder you want
# Create dir
$dir = "paramdirssh";
$file_to_write = "paramfilessh";

$content_to_write_user = $_POST['user'];
$content_to_write_pass = $_POST['pass'];
$content_to_write_ip = $_POST['ip'];
#$content_to_write_pnum = $_POST['pnum'];

if( is_dir($dir) === false )
{
mkdir($dir);	
$file = fopen($dir . '/' . $file_to_write,"w");
fwrite($file, $content_to_write_user);
fwrite($file, "\n");
fwrite($file, $content_to_write_pass);
fwrite($file, "\n");
fwrite($file, $content_to_write_ip);
#fwrite($file, "\n");
#fwrite($file, $content_to_write_pnum);

#echo "Thank You! In Progress... Email will be sent to Admins";

// closes the file
fclose($file);
shell_exec('sudo -uroot ./ssh-to-server-pre.sh');
}
else
{
echo "Directory already exists!!!";	
}
//$my_file = $_POST['feature'].'html';
//$handle = fopen($my_file, 'w') or die('Cannot open file:  '.$my_file); //implicitly creates file

header("Location: http://lcms/dep/admin");

?>

<html lang="en">
<head>
<link rel="stylesheet" type="text/css" href="/style/std.css">
<link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>SSH to Server</title>
	<body>
	<p>Thank You! In Progress... Email will be sent to Admins</p>
	</body>
</head>
</html>


