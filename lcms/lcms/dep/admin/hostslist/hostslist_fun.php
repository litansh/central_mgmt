<?php
shell_exec('sudo -uroot ./hostslist.sh');
header( "refresh:3;url=http://lcms/dep/admin/hostslist/hostslist_prev.php" );
?>

<html lang="en">
<head>
<link rel="stylesheet" type="text/css" href="/style/std.css">
<link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Hosts List</title>
	<body>
	<p>Please Wait..
Results in 5,4,3,2,1.. </p>
	</body>
</head>
</html>





