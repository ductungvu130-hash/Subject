CREATE DATABASE  IF NOT EXISTS `electronicstore` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `electronicstore`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: electronicstore
-- ------------------------------------------------------
-- Server version	8.0.41

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `customer` (
  `CustomerID` varchar(10) NOT NULL,
  `FullName` varchar(255) NOT NULL,
  `PhoneNumber` varchar(15) NOT NULL,
  `Email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`CustomerID`),
  UNIQUE KEY `PhoneNumber` (`PhoneNumber`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES ('C001','Nguyen Minh Tuan','0967890123','tuan.nguyen@gmail.com'),('C002','Tran Thi Mai','0978901234','mai.tran@gmail.com'),('C003','Le Hoang Nam','0989012345','nam.le@gmail.com'),('C004','Pham Thanh Hoa','0990123456','hoa.pham@gmail.com'),('C005','Hoang Van Trung','0901123456','trung.hoang@gmail.com'),('C006','Doan Thanh Binh','0912567890','binh.doan@gmail.com'),('C007','Vu Thi Lan','0923678901','lan.vu@gmail.com');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orderdetails`
--

DROP TABLE IF EXISTS `orderdetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `orderdetails` (
  `OrderDetailID` varchar(10) NOT NULL,
  `OrderID` varchar(10) NOT NULL,
  `ProductID` varchar(10) NOT NULL,
  `Quantity` int NOT NULL,
  `SellingPrice` decimal(10,2) NOT NULL,
  PRIMARY KEY (`OrderDetailID`),
  KEY `OrderID` (`OrderID`),
  KEY `ProductID` (`ProductID`),
  CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`OrderID`) REFERENCES `ordertable` (`OrderID`),
  CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`),
  CONSTRAINT `orderdetails_chk_1` CHECK ((`Quantity` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orderdetails`
--

LOCK TABLES `orderdetails` WRITE;
/*!40000 ALTER TABLE `orderdetails` DISABLE KEYS */;
INSERT INTO `orderdetails` VALUES ('OD001','O001','P001',2,27000000.00),('OD002','O002','P005',1,22000000.00),('OD003','O003','P003',3,32000000.00),('OD004','O004','P004',1,15000000.00);
/*!40000 ALTER TABLE `orderdetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ordertable`
--

DROP TABLE IF EXISTS `ordertable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `ordertable` (
  `OrderID` varchar(10) NOT NULL,
  `CustomerID` varchar(10) NOT NULL,
  `StoreID` varchar(10) NOT NULL,
  `OrderDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `TotalAmount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`OrderID`),
  KEY `CustomerID` (`CustomerID`),
  KEY `StoreID` (`StoreID`),
  CONSTRAINT `ordertable_ibfk_1` FOREIGN KEY (`CustomerID`) REFERENCES `customer` (`CustomerID`),
  CONSTRAINT `ordertable_ibfk_2` FOREIGN KEY (`StoreID`) REFERENCES `store` (`StoreID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ordertable`
--

LOCK TABLES `ordertable` WRITE;
/*!40000 ALTER TABLE `ordertable` DISABLE KEYS */;
INSERT INTO `ordertable` VALUES ('O001','C001','S001','2024-03-01 12:00:00',27000000.00),('O002','C002','S002','2024-03-15 12:05:00',21000000.00),('O003','C003','S001','2024-03-29 12:10:00',32000000.00),('O004','C006','S001','2024-04-10 14:30:00',15000000.00);
/*!40000 ALTER TABLE `ordertable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `product` (
  `ProductID` varchar(10) NOT NULL,
  `ProductName` varchar(255) NOT NULL,
  `Description` text,
  `Brand` varchar(100) NOT NULL,
  `ProductType` varchar(50) NOT NULL,
  PRIMARY KEY (`ProductID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES ('P001','iPhone 15 Pro','Dien thoai Apple cao cap','Apple','Smartphone'),('P002','Samsung Galaxy S23','Dien thoai Samsung flagship','Samsung','Smartphone'),('P003','MacBook Air M2','Laptop mong nhe Apple','Apple','Laptop'),('P004','Dell XPS 15','Laptop sieu mong Dell','Dell','Laptop'),('P005','iPad Pro M2','Tablet cao cap Apple','Apple','Tablet');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `store`
--

DROP TABLE IF EXISTS `store`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `store` (
  `StoreID` varchar(10) NOT NULL,
  `StoreName` varchar(255) NOT NULL,
  `Address` text NOT NULL,
  `PhoneNumber` varchar(15) NOT NULL,
  `Email` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`StoreID`),
  UNIQUE KEY `PhoneNumber` (`PhoneNumber`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `store`
--

LOCK TABLES `store` WRITE;
/*!40000 ALTER TABLE `store` DISABLE KEYS */;
INSERT INTO `store` VALUES ('S001','Tech Store HCM','123 Nguyen Van Linh, HCM','0901234567','hcm@techstore.com'),('S002','Tech Store Ha Noi','45 Tran Duy Hung, Ha Noi','0912345678','hanoi@techstore.com');
/*!40000 ALTER TABLE `store` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `storestock`
--

DROP TABLE IF EXISTS `storestock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8 */;
CREATE TABLE `storestock` (
  `StoreStockID` varchar(10) NOT NULL,
  `StoreID` varchar(10) NOT NULL,
  `ProductID` varchar(10) NOT NULL,
  `Quantity` int NOT NULL,
  PRIMARY KEY (`StoreStockID`),
  KEY `StoreID` (`StoreID`),
  KEY `ProductID` (`ProductID`),
  CONSTRAINT `storestock_ibfk_1` FOREIGN KEY (`StoreID`) REFERENCES `store` (`StoreID`),
  CONSTRAINT `storestock_ibfk_2` FOREIGN KEY (`ProductID`) REFERENCES `product` (`ProductID`),
  CONSTRAINT `storestock_chk_1` CHECK ((`Quantity` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `storestock`
--

LOCK TABLES `storestock` WRITE;
/*!40000 ALTER TABLE `storestock` DISABLE KEYS */;
INSERT INTO `storestock` VALUES ('SS001','S001','P001',10),('SS002','S001','P002',15),('SS003','S001','P003',20),('SS004','S002','P004',5),('SS005','S002','P005',10),('SS006','S002','P001',8),('SS007','S002','P003',12);
/*!40000 ALTER TABLE `storestock` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-25  4:58:53
