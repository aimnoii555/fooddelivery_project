-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 26, 2022 at 06:45 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 8.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fooddelivery`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `Id` int(11) NOT NULL,
  `IdChef` text NOT NULL,
  `NameChef` text NOT NULL,
  `IdFood` text NOT NULL,
  `NameFood` text NOT NULL,
  `Price` int(11) NOT NULL,
  `Amount` text NOT NULL,
  `Sum` text NOT NULL,
  `Distance` text NOT NULL,
  `Transport` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`Id`, `IdChef`, `NameChef`, `IdFood`, `NameFood`, `Price`, `Amount`, `Sum`, `Distance`, `Transport`) VALUES
(11, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.03', '3'),
(12, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.03', '3'),
(13, '67', 'Demo', '82', 'ผัดไท', 40, '7', '280.0', '0.03', '3'),
(14, '67', 'Demo', '82', 'ผัดไท', 40, '3', '120.0', '0.04', '3'),
(15, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.03', '3'),
(16, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.03', '3'),
(17, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.74', '4'),
(18, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.03', '3'),
(19, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.01', '3'),
(20, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.02', '3'),
(21, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.01', '3'),
(22, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.04', '3'),
(23, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.03', '3'),
(24, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.03', '3'),
(25, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.02', '3'),
(26, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.02', '3'),
(27, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.03', '3'),
(28, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.01', '3'),
(29, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.01', '3'),
(30, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.03', '3'),
(31, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.01', '3'),
(32, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.01', '3'),
(33, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.01', '3'),
(34, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.02', '3'),
(35, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.03', '3'),
(36, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.03', '3'),
(37, '67', 'Demo', '81', 'ต้มยำกุ้ง', 50, '1', '50.0', '0.03', '3'),
(38, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.03', '3'),
(39, '67', 'Demo', '82', 'ผัดไท', 40, '1', '40.0', '0.03', '3'),
(40, '68', 'Demo2', '83', '5555', 5555, '1', '5555.0', '0.0', '3'),
(41, '68', 'Demo2', '83', '5555', 5555, '1', '5555.0', '0.02', '3'),
(42, '68', 'Demo2', '83', '5555', 5555, '1', '5555.0', '0.0', '3');

-- --------------------------------------------------------

--
-- Table structure for table `food`
--

CREATE TABLE `food` (
  `id` int(11) NOT NULL,
  `IdChef` text NOT NULL,
  `NameFood` text NOT NULL,
  `Image` text NOT NULL,
  `Price` text NOT NULL,
  `Detail` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `food`
--

INSERT INTO `food` (`id`, `IdChef`, `NameFood`, `Image`, `Price`, `Detail`) VALUES
(81, '67', 'ต้มยำกุ้ง', '/FoodDelivery/Food/food7894765.jpg', '50.0', 'พิเศษ พิเศษ พิเศษ พิเศษ พิเศษ พิเศษ พิเศษ พิเศษพิเศษพิเศษพิเศษพิเศษพิเศษพิเศษพิเศษ'),
(83, '68', '5555', '/FoodDelivery/Food/food6268465.jpg', '5555', '555'),
(84, '67', 'ปีกไก่ทอด', '/FoodDelivery/Food/food5478271.jpg', '50.0', 'พิเศษ'),
(86, '67', 'หมูย่าง', '/FoodDelivery/Food/food4020721.jpg', '50.0', 'ธรรมดา'),
(87, '67', 'ผัดไทย', '/FoodDelivery/Food/food7795913.jpg', '50', 'พิเศษ'),
(88, '67', 'ข้าวหมูแดง', '/FoodDelivery/Food/food8576630.jpg', '60', 'ธรรมดา'),
(89, '67', 'ไข่เจียวหมูสับ', '/FoodDelivery/Food/food8196079.jpg', '50', 'พิเศษ'),
(90, '67', 'ส้มตำ', '/FoodDelivery/Food/food2501550.jpg', '80', 'ตำไทย');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `dateTime` text NOT NULL,
  `idUser` text NOT NULL,
  `NameUser` text NOT NULL,
  `idChef` text NOT NULL,
  `NameChef` text NOT NULL,
  `Distance` text NOT NULL,
  `Transport` text NOT NULL,
  `IdFood` text NOT NULL,
  `NameFood` text NOT NULL,
  `Price` text NOT NULL,
  `Amount` text NOT NULL,
  `Sum` text NOT NULL,
  `idRider` text NOT NULL,
  `Status` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `dateTime`, `idUser`, `NameUser`, `idChef`, `NameChef`, `Distance`, `Transport`, `IdFood`, `NameFood`, `Price`, `Amount`, `Sum`, `idRider`, `Status`) VALUES
(33, '25-02-2022 14:00', '71', 'users', '67', 'Demo', '10.3', '15', '[86, 87, 88]', '[หมูย่าง, ผัดไทย, ข้าวหมูแดง]', '[50.0, 50, 60]', '[1, 1, 1]', '[50.0, 50.0, 60.0]', 'none', 'UserOrder'),
(34, '25-02-2022 14:41', '71', 'users', '67', 'Demo', '10.3', '15', '[86, 87, 88]', '[หมูย่าง, ผัดไทย, ข้าวหมูแดง]', '[50.0, 50, 60]', '[1, 1, 1]', '[50.0, 50.0, 60.0]', 'none', 'UserOrder'),
(35, '25-02-2022 14:45', '71', 'users', '67', 'Demo', '10.3', '15', '[86, 90]', '[หมูย่าง, ส้มตำ]', '[50.0, 80]', '[1, 1]', '[50.0, 80.0]', 'none', 'UserOrder');

-- --------------------------------------------------------

--
-- Table structure for table `status`
--

CREATE TABLE `status` (
  `id` int(11) NOT NULL,
  `idStatus` text NOT NULL,
  `username` text NOT NULL,
  `status_name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `ChooseType` text NOT NULL,
  `Name` text NOT NULL,
  `User` text NOT NULL,
  `Password` text NOT NULL,
  `NameChef` text NOT NULL,
  `Address` text NOT NULL,
  `Phone` text NOT NULL,
  `UrlPicture` text NOT NULL,
  `Lat` text NOT NULL,
  `Lng` text NOT NULL,
  `Token` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `ChooseType`, `Name`, `User`, `Password`, `NameChef`, `Address`, `Phone`, `UrlPicture`, `Lat`, `Lng`, `Token`) VALUES
(67, 'Chef', 'chef', 'chef', '1234', 'Demo', '53/4', '0955555555', 'FoodDelivery/Chef/editChef65649.jpg', '17.424917', '102.788809', 'coe1BQwZTdu2BmPKESJjQS:APA91bFj9X9Vp1MD4JYEoF19NllUhSZnVF9rqFBKdkYOvFzDO2Hw6fTzXheODq5lIcxX3k82dx6FAIVh1w9mYX2RIdd4yCz3Azt0Nji9f7OiIyaXxsver8lC4qWrcQBeA7IOpYWaVlEe'),
(71, 'User', 'users', 'users', '1234', '', '', '', '', '', '', 'coe1BQwZTdu2BmPKESJjQS:APA91bFj9X9Vp1MD4JYEoF19NllUhSZnVF9rqFBKdkYOvFzDO2Hw6fTzXheODq5lIcxX3k82dx6FAIVh1w9mYX2RIdd4yCz3Azt0Nji9f7OiIyaXxsver8lC4qWrcQBeA7IOpYWaVlEe'),
(72, 'Chef', 'chef1', 'chef1', '1234', '', '', '', '', '', '', 'coe1BQwZTdu2BmPKESJjQS:APA91bFj9X9Vp1MD4JYEoF19NllUhSZnVF9rqFBKdkYOvFzDO2Hw6fTzXheODq5lIcxX3k82dx6FAIVh1w9mYX2RIdd4yCz3Azt0Nji9f7OiIyaXxsver8lC4qWrcQBeA7IOpYWaVlEe');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`Id`);

--
-- Indexes for table `food`
--
ALTER TABLE `food`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `Id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `food`
--
ALTER TABLE `food`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `status`
--
ALTER TABLE `status`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
