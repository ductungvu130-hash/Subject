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
-- Table structure for table `relative`
--

DROP TABLE IF EXISTS `relative`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relative` (
  `employeeID` varchar(3) DEFAULT NULL,
  `relativeName` varchar(50) NOT NULL,
  `gender` varchar(3) DEFAULT NULL,
  `dateOfBirth` date DEFAULT NULL,
  `relationship` varchar(30) NOT NULL,
  PRIMARY KEY (`relativeName`),
  KEY `fk7` (`employeeID`),
  CONSTRAINT `fk7` FOREIGN KEY (`employeeID`) REFERENCES `employees` (`employeeID`),
  CONSTRAINT `check_gender_relative` CHECK ((`gender` in (_utf8mb4'Nam',_utf8mb4'Nu')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relative`
--

LOCK TABLES `relative` WRITE;
/*!40000 ALTER TABLE `relative` DISABLE KEYS */;
INSERT INTO `relative` VALUES ('123','Chau','Nu','1978-12-31','Con gai'),('987','Dang','Nam','1932-02-29','Vo chong'),('333','Duong','Nu','1948-05-03','Vo chong'),('123','Duy','Nam','1978-01-01','Con trai'),('123','Phuong','Nu','1957-05-05','Vo chong'),('333','Quang','Nu','1976-04-05','Con gai'),('333','Tung','Nam','1973-10-25','Con trai');
/*!40000 ALTER TABLE `relative` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-07-20 19:56:57
