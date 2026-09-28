-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: lab2
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
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `employeeID` varchar(3) NOT NULL,
  `lastName` varchar(20) NOT NULL,
  `middleName` varchar(20) DEFAULT NULL,
  `firstName` varchar(20) NOT NULL,
  `dateOfBirth` date NOT NULL,
  `gender` varchar(3) DEFAULT NULL,
  `salary` decimal(20,2) NOT NULL,
  `address` varchar(100) NOT NULL,
  `managerID` varchar(3) DEFAULT NULL,
  `departmentID` int DEFAULT NULL,
  PRIMARY KEY (`employeeID`),
  KEY `fk` (`managerID`),
  KEY `fk1` (`departmentID`),
  CONSTRAINT `fk` FOREIGN KEY (`managerID`) REFERENCES `employees` (`employeeID`),
  CONSTRAINT `fk1` FOREIGN KEY (`departmentID`) REFERENCES `department` (`departmentID`),
  CONSTRAINT `check_gender` CHECK ((`gender` in (_utf8mb4'Nam',_utf8mb4'Nu'))),
  CONSTRAINT `checkDateOfBirthEmployee` CHECK ((`dateOfBirth` < _utf8mb4'2025-07-14'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES ('123','Dinh','Ba','Tien','1955-01-09','Nam',30000.00,'731 Tran Hung Dao Q1 TPHCM','333',5),('333','Nguyen','Thanh','Tung','1945-12-08','Nam',40000.00,'638 Nguyen Van Cu Q5 TPHCM','888',5),('453','Tran','Thanh','Tam','1962-07-31','Nam',25000.00,'543 Mai Thi Luu Ba Dinh Ha Noi','333',5),('666','Nguyen','Manh','Hung','1952-09-15','Nam',38000.00,'975 Le Lai P3 Vung Tau','333',5),('777','Tran','Hong','Quang','1959-03-29','Nam',25000.00,'980 Le Hong Phong Vung Tau','987',4),('888','Vuong','Ngoc','Quyen','1927-10-10','Nu',55000.00,'450 Trung Vuong My Tho TG',NULL,1),('987','Le','Thi','Nhan','1931-06-20','Nu',43000.00,'291 Ho Van Hue Q.PN TPHCM','888',4),('999','Bui','Thuy','Vu','1958-07-19','Nam',25000.00,'332 Nguyen Thi Hoc Quy Nhon','987',4);
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-20 19:56:58
