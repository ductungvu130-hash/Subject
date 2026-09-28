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
-- Table structure for table `salesman`
--

DROP TABLE IF EXISTS `salesman`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salesman` (
  `Salesman_Number` varchar(15) NOT NULL,
  `Salesman_Name` varchar(25) NOT NULL,
  `Address` varchar(30) DEFAULT NULL,
  `City` varchar(30) DEFAULT NULL,
  `Pincode` int NOT NULL,
  `Province` char(25) DEFAULT (_utf8mb4'Viet Nam'),
  `Salary` decimal(15,4) NOT NULL,
  `Sales_Target` int NOT NULL,
  `Target_Achieved` int DEFAULT NULL,
  `Phone` char(10) NOT NULL,
  PRIMARY KEY (`Salesman_Number`),
  UNIQUE KEY `Phone` (`Phone`),
  CONSTRAINT `salesman_chk_1` CHECK ((`Salesman_Number` like _utf8mb4'S%')),
  CONSTRAINT `salesman_chk_2` CHECK ((`Salary` <> 0)),
  CONSTRAINT `salesman_chk_3` CHECK ((`Sales_Target` <> 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salesman`
--

LOCK TABLES `salesman` WRITE;
/*!40000 ALTER TABLE `salesman` DISABLE KEYS */;
INSERT INTO `salesman` VALUES ('S001','Huu','Phu Tan','Ho Chi Minh',700002,'Ho Chi Minh',15000.0000,50,35,'0902361123'),('S002','Phat','Tan An','Hanoi',700005,'Hanoi',25000.0000,100,110,'0903216542'),('S003','Khoa','Phu Hoa','Thu Dau Mot',700051,'Binh Duong',17500.0000,40,30,'0904589632'),('S004','Tien','Phu Hoa','Dai An',700023,'Binh Duong',16500.0000,70,72,'0908654723'),('S005','Deb','Hoa Phu','Thu Dau Mot',700051,'Binh Duong',13500.0000,60,48,'0903213659'),('S006','Tin','Chanh My','Da Lat',700032,'Lam Dong',20000.0000,80,55,'0907853497');
/*!40000 ALTER TABLE `salesman` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-28  0:40:41
