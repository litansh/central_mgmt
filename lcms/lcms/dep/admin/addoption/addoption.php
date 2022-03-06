<!DOCTYPE html>
<html lang="en">


<head>

<link rel="stylesheet" type="text/css" href="/style/std.css">
<link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Restart Httpd</title>
</head>
<body>
    <div align="center" class="center">
        <form class="form" action="restarthttpd_fun.php" method="POST">
		       <p>In Which Operation:</p>
               <input name="opn" type="text" placeholder="Input Operation" class="blockb" required />
               <p>Input the option NAME:</p>
               <input name="name" type="text" placeholder="Name" class="blockb" required />
			   <p>Input the option VALUE:</p>
               <input name="value" type="text" placeholder="Value for NEW Tab" class="blockb" required />
			  <input onClick="return clicked()" type="submit" class="submita" value="Submit" />
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
</body>

</html>




