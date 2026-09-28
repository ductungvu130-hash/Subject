-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: salemanagerment
-- ------------------------------------------------------
-- Server version	8.0.42

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
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients` (
  `Client_Number` varchar(10) NOT NULL,
  `Client_Name` varchar(25) NOT NULL,
  `Address` varchar(30) DEFAULT NULL,
  `City` varchar(30) DEFAULT NULL,
  `Pincode` int NOT NULL,
  `Province` char(25) DEFAULT NULL,
  `Amount_Paid` decimal(15,4) DEFAULT NULL,
  `Amount_Due` decimal(15,4) DEFAULT NULL,
  PRIMARY KEY (`Client_Number`),
  CONSTRAINT `clients_chk_1` CHECK ((`Client_Number` like _utf8mb4'C%'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES ('C101','Mai Xuan','Phu Hoa','Dai An',700001,'Binh Duong',10000.0000,5000.0000),('C102','Le Xuan','Phu Hoa','Thu Dau Mot',700051,'Binh Duong',18000.0000,3000.0000),('C103','Trinh Huu','Phu Loi','Da Lat',700051,'Lam Dong',7000.0000,3200.0000),('C104','Tran Tuan','Phu Tan','Thu Dau Mot',700080,'Binh Duong',8000.0000,0.0000),('C105','Ho Nhu','Chanh My','Hanoi',700005,'Hanoi',7000.0000,150.0000),('C106','Tran Hai','Phu Hoa','Ho Chi Minh',700002,'Ho Chi Minh',7000.0000,1300.0000),('C107','Nguyen Thanh ','Hoa Phu','Dai An',700023,'Binh Duong',8500.0000,7500.0000),('C108','Nguyen Sy','Tan An','Da Lat',700032,'Lam Dong',15000.0000,1000.0000),('C109','Duong Thanh','Phu Hoa','Ho Chi Minh',700011,'Ho Chi Minh',12000.0000,8000.0000),('C110','Tran Minh','Phu My','Hanoi',700005,'Hanoi',9000.0000,1000.0000);
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-28  0:40:42
