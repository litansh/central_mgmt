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
        <form class="form" action="sitetodev_fun.php" method="POST">
            <div class="select">
			<p>Select DEV User:</p>
                <select name="dev" tabindex="dev" class="block" required />
				<option value="litan@cglms.com">Litan Shamir</option>
                <option value="Vladimir.migutin@cglms.com">Vladimir Migutin</option>
				<option value="Tal.Aharoni@cglms.com">Tal Aharoni</option>
                </select>
            </div>
			<p>Choose the Domain:</p>
			 <div class="select">
  <select name="domain" tabindex="domain" class="block" required />
     <option value="litanshamir.com">litanshamir.com</option>
   <option value="192.168.10.195">DEVDE_192.168.10.195</option>
   <option value="192.168.60.5">DEVNL_192.168.60.5</option>
   <option value="192.168.60.156">DEVPARTNERS_192.168.60.156</option>
   <option value="82.166.194.162">TradenetCloneIL_82.166.194.162</option>
   <option value="192.168.60.32">LPNL01_192.168.60.32</option>
  </select>
 </div>
<br><br>
            <p>Input the Sub-Domain you wish to create:</p>
               <input name="sub" type="text" placeholder="Sub Domain" class="blockb" required />
            <p>On which host you wish to create:</p>
 <div class="select">
  <select name="ip" tabindex="ip" class="block" required />
<option value="192.168.220.20">Test_192.168.220.20</option>
     <option value="192.168.60.101">Test_192.168.60.101</option>
   <option value="192.168.10.195">DEVDE_192.168.10.195</option>
   <option value="192.168.60.5">DEVNL_192.168.60.5</option>
   <option value="192.168.60.156">DEVPARTNERS_192.168.60.156</option>
   <option value="82.166.194.162">TradenetCloneIL_82.166.194.162</option>
   <option value="192.168.60.32">LPNL01_192.168.60.32</option>
  </select>
 </div>
<br><br>
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
            </script>
<input onClick="history.go(-1);" type="submit" class="submita" value="Back" />
			</form>
    </div>
</body>

</html>

<?php
shell_exec('sudo -uroot ./domainlist.sh')
?>


