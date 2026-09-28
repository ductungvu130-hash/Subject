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
-- Table structure for table `salesorderdetails`
--

DROP TABLE IF EXISTS `salesorderdetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `salesorderdetails` (
  `Order_Number` varchar(15) DEFAULT NULL,
  `Product_Number` varchar(15) DEFAULT NULL,
  `Order_Quantity` int DEFAULT NULL,
  `Discount_Rate` int DEFAULT NULL,
  KEY `Order_Number` (`Order_Number`),
  KEY `Product_Number` (`Product_Number`),
  CONSTRAINT `salesorderdetails_ibfk_1` FOREIGN KEY (`Order_Number`) REFERENCES `salesorder` (`Order_Number`),
  CONSTRAINT `salesorderdetails_ibfk_2` FOREIGN KEY (`Product_Number`) REFERENCES `product` (`Product_Number`),
  CONSTRAINT `salesorderdetails_chk_1` CHECK ((`order_number` like _utf8mb4'O%')),
  CONSTRAINT `salesorderdetails_chk_2` CHECK ((`Product_Number` like _utf8mb4'P%'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salesorderdetails`
--

LOCK TABLES `salesorderdetails` WRITE;
/*!40000 ALTER TABLE `salesorderdetails` DISABLE KEYS */;
INSERT INTO `salesorderdetails` VALUES ('O20001','P1001',5,NULL),('O20001','P1002',4,NULL),('O20002','P1007',10,NULL),('O20003','P1003',12,NULL),('O20004','P1004',3,NULL),('O20005','P1001',8,NULL),('O20005','P1008',15,NULL),('O20005','P1002',14,NULL),('O20006','P1002',5,NULL),('O20007','P1005',6,NULL),('O20008','P1004',8,NULL),('O20009','P1008',2,NULL),('O20010','P1006',11,NULL),('O20010','P1001',9,NULL),('O20011','P1007',6,NULL),('O20012','P1005',3,NULL),('O20012','P1001',2,NULL),('O20013','P1006',10,NULL),('O20014','P1002',20,NULL);
/*!40000 ALTER TABLE `salesorderdetails` ENABLE KEYS */;
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
