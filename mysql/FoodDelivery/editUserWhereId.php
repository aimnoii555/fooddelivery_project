<?php
header("content-type:text/javascript;charset=utf-8");
error_reporting(0);
error_reporting(E_ERROR | E_PARSE);
$link = mysqli_connect('localhost', 'root', '', "fooddelivery_project_flutter");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}


if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
			
		$id = $_GET['id'];		
		$Restaurant_Name = $_GET['Restaurant_Name'];
		$Address = $_GET['Address'];
		$First_Name = $_GET['First_Name'];
		$Last_Name = $_GET['Last_Name'];
		$Address = $_GET['Address'];
		$Phone = $_GET['Phone'];
		$Image = $_GET['Image'];
		$Lat = $_GET['Lat'];
		$Lng = $_GET['Lng'];
		$Token = $_GET['Token'];
		
							
		$sql = "UPDATE `users` SET `Restaurant_Name` = '$Restaurant_Name', `Address` = '$Address', `Phone` = '$Phone', `Image` = '$Image', `Lat` = '$Lat', `Lng` = '$Lng',`First_Name` = '$First_Name',`Last_Name` = '$Last_Name',`Address` = '$Address' WHERE id = '$id'";
		printf($sql);

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome";
   
}

	mysqli_close($link);
?>