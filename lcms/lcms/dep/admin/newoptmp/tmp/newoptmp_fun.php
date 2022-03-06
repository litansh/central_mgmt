<?php
$usernamel = $_SERVER['PHP_AUTH_USER'];
$passwordl = $_SERVER['PHP_AUTH_PW'];
$dirl = "loggeduserdir";
if( is_dir($dirl) === false )
{
mkdir($dirl);	
$file_to_writel = "loggeduser";
$filel = fopen($dirl . '/' . $file_to_writel,"w");
fwrite($filel, $usernamel);
fclose($filel);
}
######################################

$dir = "newoptmpdir";
$file_to_write = "newoptmpparam";
$content_to_write_user = $_POST['user'];
$content_to_write_password = $_POST['password'];
$content_to_write_port = $_POST['port'];
$content_to_write_ip = $_POST['ip'];

if( is_dir($dir) === false )
{
mkdir($dir);	
$file = fopen($dir . '/' . $file_to_write,"w");
fwrite($file, $content_to_write_user);
fwrite($file, "\n");
fwrite($file, $content_to_write_password);
fwrite($file, "\n");
fwrite($file, $content_to_write_port);
fwrite($file, "\n");
fwrite($file, $content_to_write_ip);
fwrite($file, "\n");
fclose($file);
shell_exec('sudo -uroot ./newoptmp_pre.sh');
}
else
{
echo "Directory already exists!!!";	
}
header("Location: http://lcms/dep/admin");
?>

<html lang="en">
<head>
<link rel="stylesheet" type="text/css" href="/style/std.css">
<link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>New Operation TMP</title>
	<body>
	<p>Thank You! In Progress... Email will be sent to Admins</p>
	</body>
</head>
</html>





