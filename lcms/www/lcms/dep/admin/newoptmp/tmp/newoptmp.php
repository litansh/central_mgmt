<!DOCTYPE html>
<html lang="en">


<head>

<link rel="stylesheet" type="text/css" href="/style/std.css">
<link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Central Management</title>
</head>

<body>
    <div align="center" class="center">
        <form class="form" action="newoptmp_fun.php" method="POST">
            <div class="select">
            <p>User:</p>
               <input name="user" type="text" placeholder="User" class="block" required />
            <p>Password:</p>
               <input name="password" type="text" placeholder="Password" class="block" required />
		    <p>Port:</p>
               <input name="port" type="text" placeholder="Port" class="block" required />
            <p>Host:</p>
            <div class="select">
                <select name="ip" tabindex="ip" class="taba" required />
                <option value="192.168.25.220">Host_220</option>
				<option value="192.168.25.223">Host_223</option>
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
			<input onClick="goback();" type="submit" class="submita" value="Back" />
			<script type="text/javascript">
			 function goback()
              {
	          header(&quot;Location: {$_SERVER['HTTP_REFERER']}&quot;);
	          exit;
              }
            </script>
			</form>
    </div>
</body>

</html>

