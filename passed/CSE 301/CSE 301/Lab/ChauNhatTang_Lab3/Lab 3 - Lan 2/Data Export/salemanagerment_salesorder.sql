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
-- Table structure for table `salesorder`
--

DROP TABLE IF EXISTS `salesorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salesorder` (
  `Order_Number` varchar(15) NOT NULL,
  `Order_Date` date DEFAULT NULL,
  `Client_Number` varchar(15) DEFAULT NULL,
  `Salesman_Number` varchar(15) DEFAULT NULL,
  `Delivery_Status` char(15) DEFAULT NULL,
  `Delivery_Date` date DEFAULT NULL,
  `Order_Status` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`Order_Number`),
  KEY `Client_Number` (`Client_Number`),
  KEY `Salesman_Number` (`Salesman_Number`),
  CONSTRAINT `salesorder_ibfk_1` FOREIGN KEY (`Client_Number`) REFERENCES `clients` (`Client_Number`),
  CONSTRAINT `salesorder_ibfk_2` FOREIGN KEY (`Salesman_Number`) REFERENCES `salesman` (`Salesman_Number`),
  CONSTRAINT `salesorder_chk_1` CHECK ((`Order_Number` like _utf8mb4'O%')),
  CONSTRAINT `salesorder_chk_2` CHECK ((`Client_Number` like _utf8mb4'C%')),
  CONSTRAINT `salesorder_chk_3` CHECK ((`Salesman_Number` like _utf8mb4'S%')),
  CONSTRAINT `salesorder_chk_4` CHECK ((`Delivery_Status` in (_utf8mb4'Delivered',_utf8mb4'On Way',_utf8mb4'Ready to Ship'))),
  CONSTRAINT `salesorder_chk_5` CHECK ((`Delivery_Date` > `Order_Date`)),
  CONSTRAINT `salesorder_chk_6` CHECK ((`Order_Status` in (_utf8mb4'In Process',_utf8mb4'Successful',_utf8mb4'Cancelled')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salesorder`
--

LOCK TABLES `salesorder` WRITE;
/*!40000 ALTER TABLE `salesorder` DISABLE KEYS */;
INSERT INTO `salesorder` VALUES ('O20001','2022-01-15','C101','S003','Delivered','2022-02-10','Successful'),('O20002','2022-01-25','C102','S003','Delivered','2022-02-15','Cancelled'),('O20003','2022-01-31','C103','S002','Delivered','2022-04-03','Successful'),('O20004','2022-02-10','C104','S003','Delivered','2022-04-23','Successful'),('O20005','2022-02-18','C101','S003','On Way',NULL,'Cancelled'),('O20006','2022-02-22','C105','S005','Ready to Ship',NULL,'In Process'),('O20007','2022-04-03','C106','S001','Delivered','2022-05-08','Successful'),('O20008','2022-04-16','C102','S006','Ready to Ship',NULL,'In Process'),('O20009','2022-04-24','C101','S004','On Way',NULL,'Successful'),('O20010','2022-04-29','C106','S006','Delivered','2022-05-08','Successful'),('O20011','2022-05-08','C107','S005','Ready to Ship',NULL,'Cancelled'),('O20012','2022-05-12','C108','S004','On Way',NULL,'Successful'),('O20013','2022-05-16','C109','S001','Ready to Ship',NULL,'In Process'),('O20014','2022-05-16','C110','S001','On Way',NULL,'Successful');
/*!40000 ALTER TABLE `salesorder` ENABLE KEYS */;
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
