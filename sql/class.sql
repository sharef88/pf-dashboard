-- MySQL dump 10.11
--
-- Host: localhost    Database: sharef_dnd
-- ------------------------------------------------------
-- Server version	5.0.92-community

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `classes`
--

DROP TABLE IF EXISTS `classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `classes` (
  `id` int(11) NOT NULL auto_increment,
  `name` text NOT NULL,
  `type` enum('Base','Prestige') NOT NULL,
  `hd` int(11) NOT NULL,
  `bab` int(11) NOT NULL,
  `will` enum('good','poor') NOT NULL,
  `fort` enum('good','poor') NOT NULL,
  `ref` enum('good','poor') NOT NULL,
  `skill` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `classes`
--

LOCK TABLES `classes` WRITE;
/*!40000 ALTER TABLE `classes` DISABLE KEYS */;
INSERT INTO `classes` VALUES (1,'Barbarian','Base',12,100,'poor','good','poor',4),(2,'Bard','Base',8,75,'good','poor','good',6),(3,'Cleric','Base',8,75,'good','good','poor',2),(4,'Druid','Base',8,75,'good','good','poor',4),(5,'Fighter','Base',10,100,'poor','good','poor',2),(6,'Monk','Base',8,75,'good','good','good',4),(7,'Paladin','Base',10,100,'good','good','poor',2),(8,'Ranger','Base',10,100,'poor','good','good',6),(9,'Rogue','Base',8,75,'poor','poor','good',8),(10,'Sorcerer','Base',6,50,'good','poor','poor',2),(11,'Wizard','Base',6,50,'good','poor','poor',2),(12,'Alchemist','Base',8,75,'poor','good','good',4),(13,'Cavalier','Base',10,100,'poor','poor','poor',4),(14,'Gunslinger','Base',10,100,'poor','good','good',4),(15,'Inquisitor','Base',8,75,'good','good','poor',6),(16,'Magus','Base',8,75,'good','good','poor',2),(17,'Oracle','Base',8,75,'good','poor','poor',4),(18,'Summoner','Base',8,75,'good','poor','poor',2),(19,'Witch','Base',6,50,'good','poor','poor',2),(20,'Psion','Base',6,50,'good','poor','poor',2),(21,'Psychic Warrior','Base',0,75,'poor','good','poor',4),(22,'Soulknife','Base',10,100,'good','poor','good',2),(23,'Wilder','Base',8,75,'good','poor','poor',4);
/*!40000 ALTER TABLE `classes` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-11-05 21:55:35
