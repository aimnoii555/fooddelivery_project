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
				
		$idRes = $_GET['idRes'];
		$Restaurant_name = $_GET['Restaurant_Name'];
		$IdFood = $_GET['idFood'];
		$FoodName = $_GET['FoodName'];
		$FoodPrice = $_GET['FoodPrice'];
		$Amount = $_GET['Amount'];
		$Sum = $_GET['Sum'];
		$Distance = $_GET['Distance'];
		$MenuFood = $_GET['MenuFood'];
		$Image = $_GET['Image'];
		$Transport = $_GET['Transport'];
							
		$sql = "INSERT INTO `carts`(`id`, `idRes`, `Restaurant_name`, `IdFood`, `FoodName`, `FoodPrice`, `Amount`, `Sum`, `Distance`, `MenuFood`, `Image`, `Transport`) VALUES (Null, '$idRes','$Restaurant_name','$IdFood','$FoodName','$FoodPrice','$Amount','$Sum','$Distance','$MenuFood','$Image','$Transport')";

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