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
########################################

$dir = "paramdir";
$file_to_write = "paramfile";

$content_to_write_dev = $_POST['dev'];
$content_to_write_www = $_POST['domain'];
$content_to_write_sub = $_POST['sub'];
$content_to_write_ip = $_POST['ip'];

if( is_dir($dir) === false )
{
mkdir($dir);	
$file = fopen($dir . '/' . $file_to_write,"w");
fwrite($file, $content_to_write_www);
fwrite($file, "\n");
fwrite($file, $content_to_write_sub);
fwrite($file, "\n");
fwrite($file, $content_to_write_ip);
fwrite($file, "\n");
fwrite($file, $content_to_write_dev);
fclose($file);
shell_exec('sudo -uroot ./wp-script-ssh.sh');
}
else
{
echo "Directory already exists!!!";	
}

header("refresh:5; url=./lcms/admin/cm_admin.php");

?>

<html lang="en">
<head>
<link rel="stylesheet" type="text/css" href="/style/std.css">
<link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Site To Dev</title>
	<body>
	<p>Thank You! In Progress... Email will be sent to Admins</p>
	</body>
</head>
</html>


