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
-- Table structure for table `skills`
--

DROP TABLE IF EXISTS `skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `skills` (
  `id` int(11) NOT NULL auto_increment,
  `name` text NOT NULL,
  `penalty` tinyint(1) NOT NULL,
  `attribute` enum('str','dex','con','int','wis','cha') NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `skills`
--

LOCK TABLES `skills` WRITE;
/*!40000 ALTER TABLE `skills` DISABLE KEYS */;
INSERT INTO `skills` VALUES (1,'Appraise',0,'int',''),(2,'Bluff',0,'cha',''),(3,'Climb',1,'str',''),(4,'Craft',0,'int',''),(5,'Diplomacy',0,'cha',''),(6,'Disable_Device',1,'dex',''),(7,'Disguise',0,'cha',''),(8,'Escape_Artist',1,'dex',''),(9,'Fly',1,'dex',''),(10,'Handle_Animal',0,'cha',''),(11,'Heal',1,'str',''),(12,'Knowledge',0,'int',''),(13,'Intimidate',0,'cha',''),(14,'Linquistics',0,'int',''),(15,'Perception',1,'str',''),(16,'Perform',0,'cha',''),(17,'Profession',1,'str',''),(18,'Ride',1,'str',''),(19,'Sense_Motive',1,'str',''),(20,'Sleight_of_Hand',1,'dex',''),(21,'Spellcraft',0,'int',''),(22,'Stealth',1,'dex',''),(23,'Survival',1,'str',''),(24,'Swim',1,'str',''),(25,'Use_Magic_Device',0,'cha',''),(26,'Acrobatics',1,'dex','');
/*!40000 ALTER TABLE `skills` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-11-05 21:24:13
