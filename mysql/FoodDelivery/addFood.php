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
		$FoodName = $_GET['FoodName'];
		$Image = $_GET['Image'];
		$FoodPrice = $_GET['FoodPrice'];
		$MenuFood = $_GET['MenuFood'];
		$Detail = $_GET['Detail'];


							
		$sql = "INSERT INTO `foods`(`id`, `idRes`, `FoodName`, `Image`, `FoodPrice`, `MenuFood`, `Detail`) VALUES ('Null','$idRes','$FoodName','$Image','$FoodPrice', '$MenuFood', '$Detail')";

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