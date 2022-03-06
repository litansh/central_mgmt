
<html lang="en">
<head>
	<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
<link rel="stylesheet" type="text/css" href="/style/std.css">
<link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Hosts List</title>
	<body>
	 <div align="center" class="center">
	 <p>Host List:</p>
     <div class="hostslist">
	 </div>
		</div>	
     <div align="left" class="center">
			<input onClick="goback();" type="submit" class="submita" value="Back" />
			<script type="text/javascript">
			 function goback()
              {
	          header(&quot;Location: {$_SERVER['HTTP_REFERER']}&quot;);
	          exit;
              }
            </script>
     </div>
	</body>
	    <script>
	  $( ".hostslist" ).load( "./hostslist.txt" );
		</script>
</head>
</html>



