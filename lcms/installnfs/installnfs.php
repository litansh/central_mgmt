<!DOCTYPE html>
<html lang="en">


<head>

<link rel="stylesheet" type="text/css" href="/style/std.css">
<link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Install NFS</title>
</head>

<body>
    <div align="center" class="center">
        <form class="form" action="installnfs_fun.php" method="POST">
            <p>On which Host you wish to Install NFS:</p>
 <div class="select">
  <select name="ip" tabindex="ip" class="block" required />
<option value="192.168.220.20">Test_192.168.220.20</option>
     <option value="192.168.60.101">Test_192.168.60.101</option>
   <option value="192.168.10.195">DEVDE_192.168.10.195</option>
   <option value="192.168.60.5">DEVNL_192.168.60.5</option>
   <option value="192.168.60.156">DEVPARTNERS_192.168.60.156</option>
   <option value="192.168.60.6">MoodleDevNL01_192.168.60.6</option>
   <option value="82.166.194.162">TradenetCloneIL_82.166.194.162</option>
   <option value="192.168.60.77">DocuCY_192.168.60.77</option>
   <option value="192.168.60.32">LPNL01_192.168.60.32</option>
   <option value="192.168.60.57">PBXCLMXIL01_192.168.60.57</option>
   <option value="192.168.60.58">PBXCGLMSIL01_192.168.60.58</option>
   <option value="192.168.60.59">PBXBERLIN_192.168.60.59</option>
   <option value="192.168.60.60">PBXCY_192.168.60.60</option>
   <option value="192.168.60.61">PBXTRRTIL_192.168.60.61</option>
   <option value="192.168.60.62">PBXTRSAIL_192.168.60.62</option>
   <option value="192.168.66.1">PTLIVEAPPNL01_192.168.66.1</option>
   <option value="192.168.66.2">PTLIVEAPPNL02_192.168.66.2</option>
   <option value="192.168.66.3">PTLIVEAPPNL03_192.168.66.3</option>
   <option value="192.168.66.4">PTLIVEAPPNL04_192.168.66.4</option>
   <option value="192.168.10.1">PTLIVEAPPNL05_192.168.10.1</option>
   <option value="192.168.10.2">PTLIVEAPPNL06_192.168.10.2</option>
   <option value="192.168.66.20">PTLIVEDBPGNL01_192.168.66.20</option>
   <option value="192.168.10.22">PTLIVEDBPGDE02_192.168.10.22</option>
   <option value="192.168.66.138">PTLIVEEPNL01_192.168.66.138</option>
   <option value="192.168.66.139">PTLIVEEPNL02_192.168.66.139</option>
   <option value="192.168.10.214">PTLIVEEPDE03_192.168.10.214</option>
   <option value="192.168.66.148">PTLIVESTNL01_192.168.66.148</option>
   <option value="192.168.66.149">PTLIVESTNL02_192.168.66.149</option>
   <option value="192.168.10.150">PTLIVESTDE03_192.168.10.150</option>
   <option value="192.168.66.50">PTUATAPPNL01_192.168.66.50</option>
   <option value="192.168.66.51">PTUATAPPNL02_192.168.66.51</option>
   <option value="192.168.66.52">PTUATAPPNL03_192.168.66.52</option>
   <option value="192.168.66.55">PTUATDBMDPG01_192.168.66.55</option>
   <option value="192.168.66.30">PTLIVEDBMDNL01_192.168.66.30</option>
   <option value="192.168.66.31">PTLIVEDBMDNL02_192.168.66.31</option>
   <option value="192.168.10.32">PTLIVEDBMDDE03_192.168.10.32</option>
   <option value="192.168.66.40">PTLOGDBMDNL01_192.168.66.40</option>
   <option value="192.168.66.41">PTLOGDBMDNL02_192.168.66.41</option>
   <option value="192.168.67.42">PTLOGDBMDNL03_192.168.67.42</option>
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
</body>

</html>

