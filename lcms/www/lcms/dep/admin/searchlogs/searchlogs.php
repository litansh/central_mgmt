<!DOCTYPE html>
<html lang="en">


<head>

<link rel="stylesheet" type="text/css" href="/style/std.css">
<link href="https://fonts.googleapis.com/css?family=Open+Sans&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Search Logs History</title>
</head>
<body>
    <div align="center" class="center">
        <form class="form" action="searchlogs_fun.php" method="POST">
		             <p>Choose Year:</p>
            <div class="select">
                <select name="year" tabindex="ip" class="block" required />
                <option value="2019">2019</option>
				<option value="2020">2020</option>
				                <option value="2021">2021</option>
				<option value="2022">2022</option>
				                <option value="2023">2023</option>
				<option value="2024">2024</option>
				                <option value="2025">2025</option>
				<option value="2026">2026</option>

                </select>
             <p>Choose Month:</p>
            <div class="select">
                <select name="month" tabindex="ip" class="block" required />
                <option value="Jan">January</option>
				<option value="Feb">February</option>
				                <option value="Mar">March</option>
				<option value="Apr">April</option>
				                <option value="May">May</option>
				<option value="Jun">June</option>
				                <option value="Jul">July</option>
				<option value="Aug">August</option>
				                <option value="Sep">September</option>
				<option value="Oct">October</option>
				                <option value="Nov">November</option>
				<option value="Dec">December</option>
                </select>
				            <p>Choose Day:</p>
            <div class="select">
                <select name="day" tabindex="ip" class="block" required />
                <option value="1">1</option>
				<option value="2">2</option>
				                <option value="3">3</option>
				<option value="4">4</option>
				                <option value="5">5</option>
				<option value="6">6</option>
				                <option value="7">7</option>
				<option value="8">8</option>
				                <option value="9">9</option>
				<option value="10">10</option>
				                <option value="11">11</option>
				<option value="12">12</option>
				                <option value="13">13</option>
				<option value="14">14</option>
				                <option value="15">15</option>
				<option value="16">16</option>
				                <option value="17">17</option>
				<option value="18">18</option>
				                <option value="19">19</option>
				<option value="20">20</option>
				                <option value="21">21</option>
				<option value="22">22</option>
				                <option value="23">23</option>
				<option value="24">24</option>
				                <option value="25">25</option>
				<option value="26">26</option>
				                <option value="27">27</option>
				<option value="28">28</option>
				<option value="29">29</option>
				<option value="30">30</option>
				<option value="31">31</option>
                </select>
			            <p>Input User Name:</p>
			  <input name="user" type="text" placeholder="User Name" class="blockb" required />
            <br><br>
			  <input onClick="return clicked()" type="submit" class="submita" value="Submit" />
	    	  <script type="text/javascript">
              function clicked() {         
               return true();
             }
            </script>
<input onClick="history.go(-1);" type="submit" class="submita" value="Back" />
</body>

</html>




