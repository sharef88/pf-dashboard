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
-- Table structure for table `arch_list`
--

DROP TABLE IF EXISTS `arch_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `arch_list` (
  `id` int(11) NOT NULL auto_increment,
  `name` text NOT NULL,
  `base_id` int(11) NOT NULL,
  `cast_type` enum('divine','arcane','psionic','incarnum','martial') default NULL,
  `cast_attribute` enum('str','dex','con','int','wis','cha') default NULL,
  `cast_storage` enum('innate','pray','book','psi') default NULL,
  PRIMARY KEY  (`id`),
  KEY `base_id` (`base_id`),
  CONSTRAINT `arch_list_ibfk_1` FOREIGN KEY (`base_id`) REFERENCES `classes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `arch_list`
--

LOCK TABLES `arch_list` WRITE;
/*!40000 ALTER TABLE `arch_list` DISABLE KEYS */;
INSERT INTO `arch_list` VALUES (1,'Barbarian',1,NULL,NULL,NULL),(2,'Bard',2,'arcane','cha','innate'),(3,'Cleric',3,'divine','wis','pray'),(4,'Druid',4,'divine','wis','pray'),(5,'Fighter',5,NULL,NULL,NULL),(6,'Monk',6,NULL,NULL,NULL),(7,'Paladin',7,'divine','cha','pray'),(8,'Ranger',8,'divine','wis','pray'),(9,'Rogue',9,NULL,NULL,NULL),(10,'Arcane Bloodline',10,'arcane','cha','innate'),(11,'Universalist',11,'arcane','int','book');
/*!40000 ALTER TABLE `arch_list` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-11-05 21:56:56
