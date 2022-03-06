<!DOCTYPE html>
<html lang="en">


<head>

<link rel="stylesheet" type="text/css" href="/style/std.css">
<link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>User Management</title>
</head>

<body>
    <div align="center" class="center">
        <form class="form" action="usermgmt_fun.php" method="POST">
            <p>Input Username:</p>
			 <input name="user" type="text" placeholder="Username" class="blockb" required />
		    <p>Input Password: (To Delete put one character!)</p>
		     <input name="pass" type="text" placeholder="Password" class="blockb" required />
			<p>Which operation:</p>
			<div class="select">
			 <select name="opti" tabindex="opti" class="block" required />
              <option value="create">Create</option>
			  <option value="update">Update</option>
			  <option value="delete">Delete</option>
             </select>
            </div>
			<p>With which permissions:</p>
			<div class="select">
			 <select name="perm" tabindex="perm" class="block" required />
              <option value="it">IT</option>
			  <option value="dev">DEV</option>
			  <option value="admin">Admin</option>
             </select>
            </div>
            <br><br>
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
    </div>
</body>

</html>


