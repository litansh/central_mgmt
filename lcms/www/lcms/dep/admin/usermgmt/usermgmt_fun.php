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

$dir = "usermgmtdir";
$file_to_write = "usermgmtparam";
$content_to_write_user = $_POST['user'];
$content_to_write_pass = $_POST['pass'];
$content_to_write_opti = $_POST['opti'];
$content_to_write_perm = $_POST['perm'];

if( is_dir($dir) === false )
{
mkdir($dir);	
$file = fopen($dir . '/' . $file_to_write,"w");
fwrite($file, $content_to_write_user);
fwrite($file, "\n");
fwrite($file, $content_to_write_pass);
fwrite($file, "\n");
fwrite($file, $content_to_write_opti);
fwrite($file, "\n");
fwrite($file, $content_to_write_perm);
fclose($file);
shell_exec('sudo -uroot ./usermgmt.sh');
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
    <title>Edit Users</title>
	<body>
	<p>Thank You! In Progress... Email will be sent to Admins</p>
	</body>
</head>
</html>





