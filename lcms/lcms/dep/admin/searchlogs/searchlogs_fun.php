<?php
$dir = "searchlogsdir";
$file_to_write = "searchlogsparam";
$content_to_write_year = $_POST['year'];
$content_to_write_month = $_POST['month'];
$content_to_write_day = $_POST['day'];
$content_to_write_user = $_POST['user'];

if( is_dir($dir) === false )
{
mkdir($dir);	
$file = fopen($dir . '/' . $file_to_write,"w");
fwrite($file, $content_to_write_year);
fwrite($file, "\n");
fwrite($file, $content_to_write_month);
fwrite($file, "\n");
fwrite($file, $content_to_write_day);
fwrite($file, "\n");
fwrite($file, $content_to_write_user);
fclose($file);
shell_exec('sudo -uroot ./searchlogs.sh');
}
else
{
echo "Directory already exists!!!";	
}
header( "refresh:3;url=http://lcms/dep/admin/result.txt" );
?>


<html lang="en">
<head>
<link rel="stylesheet" type="text/css" href="/style/std.css">
<link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Search results</title>
	<body>
Please Wait..
Results in 5,4,3,2,1.. 
	</body>
</head>
</html>





