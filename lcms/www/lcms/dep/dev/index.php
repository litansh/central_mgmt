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
    <title>Central Management DEV</title>
</head>

<body>
<div class="flex">
    <div align="left" class="left">
        <form class="form" method="POST">
		<br><p align="center">Choose Operation:</p><br><br><br><br>
        <button type="button" class="block" onClick="parent.location='/modules/sitetodev/sitetodev.html'">Create WordPress Site</button>	<br><br>
        </form>
   		<h3><a href="?delete=1" type="submit" class="submita">RESET LOG!</a></h3>
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