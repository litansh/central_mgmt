<!DOCTYPE html>
<html lang="en">


<head>

<link rel="stylesheet" type="text/css" href="/style/std.css">
<link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Site To Dev</title>
</head>

<body>
    <div align="center" class="center">
	<form action="" class="form" method="post" enctype="multipart/form-data">  
    <p>Select Bash Script tp Upload:</p> 
    <input type="file" name="fileToUpload"/>  
    <input type="submit" value="Upload Script" name="submit"/>  
    </form>  
        <form class="form" action="newop_fun.php" method="POST">
        <p>Operation Name</p>
        <input name="name" type="text" placeholder="Input Name" class="blockb" required />
        <p>Which Permission:</p>
        <div class="select">
           <select name="perm" tabindex="perm" class="taba" required />
           <option value="all">Admin, IT & DEV</option>
	       <option value="admin">Admin</option>
		   <option value="adminit">Admin & IT</option>
        </select>
        </div>
        <br><br>
		<input onClick="return clicked()" type="submit" class="submita" value="submit" />
	     <script type="text/javascript">
              function clicked() {
               if (confirm('Are you sure you want to submit?')) {
               return true();
               } else {
               return false;
              }
             }
            </script>
<input onClick="history.go(-1);" type="submit" class="submita" value="Back" />
	 </form>

    </div>
</body>
<?php

$target_path = "./";  
$target_path = $target_path.basename( $_FILES['fileToUpload']['name']);   
  
if(move_uploaded_file($_FILES['fileToUpload']['tmp_name'], $target_path)) {  

}
?>
</html>



