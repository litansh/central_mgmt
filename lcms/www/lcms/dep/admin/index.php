<!DOCTYPE html>
<html lang="en">


<head>

<link rel="stylesheet" type="text/css" href="/style/std.css">
<link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
	<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
    <title>Central Management Admin</title>
</head>

<body>
<div class="flex">
    <div align="left" class="left">
         <form class="form" method="POST">
		  <br><p align="center">Choose Operation:</p><br>
          <button type="button" class="block" onClick="parent.location='/modules/sitetodev/sitetodev.php'">Create WordPress Site</button>	<br>	
		  <button type="button" class="block" onClick="parent.location='/modules/sshtosrv/sshtoserver.php'">Connect New Host via SSH</button>	<br>
		  <button type="button" class="block" onClick="parent.location='/modules/changesshport/changesshport.php'">Change SSH Port</button>	<br>
		  <button type="button" class="block" onClick="parent.location='/modules/restartasterisk/restartasterisk.php'">Restart Asterisk</button>	<br>
		  <button type="button" class="block" onClick="parent.location='/modules/restarthttpd/restarthttpd.php'">Restart Httpd</button>	<br>
		  <button type="button" class="block" onClick="parent.location='/modules/restartmariadb/restartmariadb.php'">Restart MariaDB</button>	<br>
		  <button type="button" class="block" onClick="parent.location='/modules/installnfs/installnfs.php'">Install NFS Client and Check</button>	<br>
		  <button type="button" class="block" onClick="parent.location='/modules/restartvm/restartvm.php'">Reboot a VM</button>	<br>
		  <button type="button" class="blocka" onClick="parent.location='./usermgmt/usermgmt.php'">Manage Users</button>	<br>
		  <button type="button" class="blocka" onClick="parent.location='./newoptmp/newop.php'">New Operation</button>	<br>
		  <button type="button" class="blocka" onClick="parent.location='./searchlogs/searchlogs.php'">Search History Logs</button>	<br>
		  <button type="button" class="blocka" onClick="parent.location='./addoption/addoption.php'">Add Option</button>	<br>
		  <button type="button" class="blocka" onClick="parent.location='./hostslist/hostslist.php'">Hosts List</button>	<br>
To Be Continued...
   		<h3><a href="?delete=1" type="submit" class="submitc">RESET LOG!</a></h3>
        <?php
         if(isset($_GET['delete']))
         {
          unlink("./stat.txt");
         }
        ?>
         </form>
		
    </div>
 <div align="right" class="right">
  <?php
   
   $file_lines = file('./stat.txt');
   foreach ($file_lines as $line) {
    echo $line;
	echo "<br>";
}
  ?>
 </div>
</div>
<script>
 $(".right").load("./stat.txt", function(response, status, xhr) {
</script>
</body>
</html>

