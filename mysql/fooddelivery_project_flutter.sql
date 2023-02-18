-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 04, 2022 at 06:15 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fooddelivery_project_flutter`
--

-- --------------------------------------------------------

--
-- Table structure for table `carts`
--

CREATE TABLE `carts` (
  `id` int(11) NOT NULL,
  `idRes` text NOT NULL,
  `Restaurant_Name` text NOT NULL,
  `idFood` text NOT NULL,
  `FoodName` text NOT NULL,
  `FoodPrice` text NOT NULL,
  `Amount` text NOT NULL,
  `Sum` text NOT NULL,
  `Distance` text NOT NULL,
  `MenuFood` text NOT NULL,
  `Image` text NOT NULL,
  `Transport` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `carts`
--

INSERT INTO `carts` (`id`, `idRes`, `Restaurant_Name`, `idFood`, `FoodName`, `FoodPrice`, `Amount`, `Sum`, `Distance`, `MenuFood`, `Image`, `Transport`) VALUES
(933, '20', 'aim', '13', 'aaa', '500.0', '1', '500.0', '0.0010002054282937179', 'aaa', '/Project_Flutter/FoodDelivery/Food/food992877.jpg', '3'),
(934, '20', 'aim', '13', 'aaa', '500.0', '1', '500.0', '0.0010002054282937179', 'aaa', '/Project_Flutter/FoodDelivery/Food/food992877.jpg', '3'),
(935, '20', 'aim', '11', 'abc', '50000.0', '1', '50000.0', '0.0009442180816803989', 'zzz', '/Project_Flutter/FoodDelivery/Food/editFood55327.jpg', '3'),
(936, '20', 'aim', '13', 'aaa', '500.0', '1', '500.0', '0.0006472519891994351', 'aaa', '/Project_Flutter/FoodDelivery/Food/food992877.jpg', '3'),
(937, '20', 'aim', '13', 'aaa', '500.0', '1', '500.0', '0.0014657305213178792', 'aaa', '/Project_Flutter/FoodDelivery/Food/food992877.jpg', '3'),
(938, '20', 'aim', '13', 'aaa', '500.0', '1', '500.0', '0.0008482898652802153', 'aaa', '/Project_Flutter/FoodDelivery/Food/food992877.jpg', '3');

-- --------------------------------------------------------

--
-- Table structure for table `foods`
--

CREATE TABLE `foods` (
  `id` int(11) NOT NULL,
  `idRes` text NOT NULL,
  `FoodName` text NOT NULL,
  `FoodPrice` text NOT NULL,
  `MenuFood` text NOT NULL,
  `Detail` text NOT NULL,
  `Image` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `foods`
--

INSERT INTO `foods` (`id`, `idRes`, `FoodName`, `FoodPrice`, `MenuFood`, `Detail`, `Image`) VALUES
(11, '20', 'abc', '50000.0', 'zzz', 'aaa', '/Project_Flutter/FoodDelivery/Food/editFood55327.jpg'),
(12, '21', 'eeee', '1000.0', 'aaa', 'ssss', '/Project_Flutter/FoodDelivery/Food/editFood5928.jpg'),
(13, '20', 'aaa', '500.0', 'aaa', 'aaaa', '/Project_Flutter/FoodDelivery/Food/food992877.jpg'),
(14, '21', 'aaa', '60.0', 'aaaa', 'aaaa', '/Project_Flutter/FoodDelivery/Food/food283392.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `Type` text NOT NULL,
  `Username` text NOT NULL,
  `Password` text NOT NULL,
  `Restaurant_Name` text NOT NULL,
  `First_Name` text NOT NULL,
  `Last_Name` text NOT NULL,
  `Address` text NOT NULL,
  `Phone` text NOT NULL,
  `Image` text NOT NULL,
  `Lat` text NOT NULL,
  `Lng` text NOT NULL,
  `Token` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `Type`, `Username`, `Password`, `Restaurant_Name`, `First_Name`, `Last_Name`, `Address`, `Phone`, `Image`, `Lat`, `Lng`, `Token`) VALUES
(19, 'Customer', 'customer', '1234', '', 'aa', 'aa', 'aa', 'aa', '', '17.4479209', '102.8827169', ''),
(20, 'Restaurant', 'restaurant', '1234', 'aim', 'aim', 'aim', 'aai', '0999', 'Project_Flutter/FoodDelivery/Restaurant/Res105995.jpg', '17.4479478', '102.8827209', ''),
(21, 'Restaurant', 'res', '1234', 'mmm', 'aaaa', 'aajd', 'duui', '099999', 'Project_Flutter/FoodDelivery/Restaurant/Res968547.jpg', '17.4479374', '102.882721', '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `carts`
--
ALTER TABLE `carts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `foods`
--
ALTER TABLE `foods`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `carts`
--
ALTER TABLE `carts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=939;

--
-- AUTO_INCREMENT for table `foods`
--
ALTER TABLE `foods`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
