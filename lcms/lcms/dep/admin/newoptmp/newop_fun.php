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

$dir = "newopdir";
$file_to_write = "newopparam";
$content_to_write_name = $_POST['name'];
$content_to_write_perm = $_POST['perm'];

if( is_dir($dir) === false )
{
mkdir($dir);	
$file = fopen($dir . '/' . $file_to_write,"w");
fwrite($file, $content_to_write_name);
fwrite($file, "\n");
fwrite($file, $content_to_write_perm);
fwrite($file, "\n");
fclose($file);
shell_exec('sudo -uroot ./scripts/newop_pre.sh');
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
    <title>New Operation</title>
	<body>
	<p>Thank You! In Progress... Email will be sent to Admins</p>
	</body>
</head>
</html>


