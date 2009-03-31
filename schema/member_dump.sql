-- MySQL dump 10.11
--
-- Host: localhost    Database: billtrack_member
-- ------------------------------------------------------
-- Server version	5.0.45

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
-- Table structure for table `bill_issues`
--

DROP TABLE IF EXISTS `bill_issues`;
CREATE TABLE `bill_issues` (
  `id` int(11) NOT NULL auto_increment,
  `bill_id` int(11) default NULL,
  `issue_id` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `bill_issues_on_bill` (`bill_id`),
  KEY `bill_issues_on_issue` (`issue_id`)
) ENGINE=InnoDB AUTO_INCREMENT=66 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `bill_issues`
--

LOCK TABLES `bill_issues` WRITE;
/*!40000 ALTER TABLE `bill_issues` DISABLE KEYS */;
INSERT INTO `bill_issues` VALUES (1,1325,3),(2,1325,4),(3,1326,3),(4,1327,5),(5,1327,6),(6,1329,7),(7,1329,8),(8,1330,9),(9,1330,10),(10,1331,11),(11,1331,12),(12,1331,13),(13,1310,14),(14,1310,15),(15,1310,13),(16,1311,16),(17,1312,17),(18,1312,5),(19,1313,18),(20,1314,11),(21,1314,13),(22,1315,19),(23,1315,20),(25,1316,5),(31,1318,8),(32,1318,22),(33,1318,23),(34,1319,24),(35,1319,25),(36,1320,26),(37,1320,27),(38,1321,13),(39,1322,28),(40,1324,22),(41,1324,7),(42,1410,29),(43,1046,29),(44,1047,30),(45,1410,30),(46,1046,30),(47,1303,31),(48,1048,30),(49,1304,32),(50,1049,33),(51,1049,34),(52,1305,35),(53,1307,30),(54,1307,22),(55,1307,8),(56,1308,22),(57,1309,11),(58,820,36),(59,821,37),(60,823,22),(61,823,8),(62,825,38),(63,827,3),(64,827,39),(65,828,40);
/*!40000 ALTER TABLE `bill_issues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `issues`
--

DROP TABLE IF EXISTS `issues`;
CREATE TABLE `issues` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) collate utf8_bin default NULL,
  `status` varchar(255) collate utf8_bin default NULL,
  `stance_positive` varchar(255) collate utf8_bin default NULL,
  `stance_negative` varchar(255) collate utf8_bin default NULL,
  `parent_id` int(11) default NULL,
  `lft` int(11) default NULL,
  `rgt` int(11) default NULL,
  `suggested_by` int(11) default NULL,
  `usage_count` int(11) default '0',
  PRIMARY KEY  (`id`),
  KEY `issues_lft` (`lft`),
  KEY `issues_rgt` (`rgt`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `issues`
--

LOCK TABLES `issues` WRITE;
/*!40000 ALTER TABLE `issues` DISABLE KEYS */;
INSERT INTO `issues` VALUES (3,'military','approved',NULL,NULL,NULL,NULL,NULL,7,3),(4,'legal appeals','approved',NULL,NULL,NULL,NULL,NULL,7,1),(5,'parks','approved',NULL,NULL,NULL,NULL,NULL,7,3),(6,'hawaii','approved',NULL,NULL,NULL,NULL,NULL,7,1),(7,'banks','approved',NULL,NULL,NULL,NULL,NULL,7,2),(8,'stimulus package','approved',NULL,NULL,NULL,NULL,NULL,7,4),(9,'immigration','approved',NULL,NULL,NULL,NULL,NULL,7,1),(10,'illegal detention','approved',NULL,NULL,NULL,NULL,NULL,7,1),(11,'veteran\'s benefits','approved',NULL,NULL,NULL,NULL,NULL,7,3),(12,'collective bargaining','approved',NULL,NULL,NULL,NULL,NULL,7,1),(13,'health','approved',NULL,NULL,NULL,NULL,NULL,7,4),(14,'social security','approved',NULL,NULL,NULL,NULL,NULL,7,1),(15,'medicare','approved',NULL,NULL,NULL,NULL,NULL,7,1),(16,'banking','approved',NULL,NULL,NULL,NULL,NULL,7,1),(17,'environment','approved',NULL,NULL,NULL,NULL,NULL,7,1),(18,'abortion','approved',NULL,NULL,NULL,NULL,NULL,7,1),(19,'poverty','approved',NULL,NULL,NULL,NULL,NULL,7,1),(20,'social services','approved',NULL,NULL,NULL,NULL,NULL,7,1),(22,'economy','approved',NULL,NULL,NULL,NULL,NULL,7,5),(23,'unemployment','approved',NULL,NULL,NULL,NULL,NULL,7,1),(24,'iraq war','approved',NULL,NULL,NULL,NULL,NULL,7,1),(25,'oil','approved',NULL,NULL,NULL,NULL,NULL,7,1),(26,'broadcasting','approved',NULL,NULL,NULL,NULL,NULL,7,1),(27,'entertainment','approved',NULL,NULL,NULL,NULL,NULL,7,1),(28,'benefits','approved',NULL,NULL,NULL,NULL,NULL,7,1),(29,'elections','approved',NULL,NULL,NULL,NULL,NULL,7,2),(30,'politics','approved',NULL,NULL,NULL,NULL,NULL,7,5),(31,'food safety','approved',NULL,NULL,NULL,NULL,NULL,7,1),(32,'indian affairs','approved',NULL,NULL,NULL,NULL,NULL,7,1),(33,'arts','approved',NULL,NULL,NULL,NULL,NULL,7,1),(34,'literature','approved',NULL,NULL,NULL,NULL,NULL,7,1),(35,'homeland security','approved',NULL,NULL,NULL,NULL,NULL,7,1),(36,'transportation','approved',NULL,NULL,NULL,NULL,NULL,7,1),(37,'taxes','approved',NULL,NULL,NULL,NULL,NULL,7,1),(38,'sex crimes','approved',NULL,NULL,NULL,NULL,NULL,7,1),(39,'earthquake safety','approved',NULL,NULL,NULL,NULL,NULL,7,1),(40,'affordable housing','approved',NULL,NULL,NULL,NULL,NULL,7,1);
/*!40000 ALTER TABLE `issues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
CREATE TABLE `members` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(255) collate utf8_bin default NULL,
  `salt` varchar(255) collate utf8_bin default NULL,
  `crypted_password` varchar(255) collate utf8_bin default NULL,
  `email` varchar(255) collate utf8_bin default NULL,
  `password_reset_code` varchar(255) collate utf8_bin default NULL,
  `activated_at` datetime default NULL,
  `activation_code` varchar(255) collate utf8_bin default NULL,
  `remember_token_expires_at` datetime default NULL,
  `remember_token` varchar(255) collate utf8_bin default NULL,
  `roles` varchar(255) collate utf8_bin default NULL,
  `first_name` varchar(255) collate utf8_bin default NULL,
  `last_name` varchar(255) collate utf8_bin default NULL,
  `visibility` text collate utf8_bin,
  `address` text collate utf8_bin,
  `city` varchar(255) collate utf8_bin default NULL,
  `zip_main` varchar(255) collate utf8_bin default NULL,
  `zip_plus_four` varchar(255) collate utf8_bin default NULL,
  `state_id` varchar(255) collate utf8_bin default NULL,
  `district_id` int(11) default NULL,
  `party_id` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `members_name` (`username`),
  KEY `members_district` (`district_id`),
  KEY `members_party` (`party_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES (7,'kane','d30ad408619edad50629e80a23e62f6db2289c81','cb34d93f20694cec44348978d4863e0c45895e03','baccigalupi@gmail.com',NULL,'2009-02-27 23:06:59',NULL,'2009-04-01 14:48:58','5994172dfcb2bd1896526d2a0b24b028cdffb43c','issues, admin','Kane','Baccigalupi',NULL,'126 Page Street','San Francisco','94102',NULL,'33',352,NULL,'2009-02-27 18:53:14','2009-03-22 20:09:20'),(8,'baccigalupi','8c972c29aad7af6f7e5b6a5ceb04bef1dddb6c99','ce444914af66227c272467fee6e52df583f0a5f2','kaneellen@yahoo.com',NULL,'2009-03-22 12:09:51',NULL,NULL,NULL,NULL,'Kane','Baccigalupi',NULL,'1110 Ralph Drive','Cary','27511',NULL,'NC',322,196,'2009-03-22 09:15:10','2009-03-22 20:09:25');
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `politician_issues`
--

DROP TABLE IF EXISTS `politician_issues`;
CREATE TABLE `politician_issues` (
  `id` int(11) NOT NULL auto_increment,
  `politician_id` int(11) default NULL,
  `issue_id` int(11) default NULL,
  `type` varchar(255) collate utf8_bin default NULL,
  `issue_count` int(11) default '0',
  `score` decimal(5,2) default NULL,
  `politician_role` varchar(255) collate utf8_bin default NULL,
  `session` int(11) default NULL,
  PRIMARY KEY  (`id`),
  KEY `politician_issues_on_politician` (`politician_id`),
  KEY `politician_issues_on_issue` (`issue_id`)
) ENGINE=InnoDB AUTO_INCREMENT=442 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `politician_issues`
--

LOCK TABLES `politician_issues` WRITE;
/*!40000 ALTER TABLE `politician_issues` DISABLE KEYS */;
INSERT INTO `politician_issues` VALUES (1,222,3,NULL,5,'1.00',NULL,NULL),(2,222,3,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(3,223,3,NULL,5,'1.00',NULL,NULL),(4,223,3,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(5,530,3,NULL,5,'1.00',NULL,NULL),(6,530,3,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(7,222,4,NULL,5,'1.00',NULL,NULL),(8,222,4,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(9,223,4,NULL,5,'1.00',NULL,NULL),(10,223,4,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(11,530,4,NULL,5,'1.00',NULL,NULL),(12,530,4,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(13,171,3,NULL,5,'10.00',NULL,NULL),(14,171,3,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(15,347,3,NULL,5,'1.00',NULL,NULL),(16,347,3,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(17,377,3,NULL,5,'1.00',NULL,NULL),(18,377,3,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(19,456,3,NULL,5,'1.00',NULL,NULL),(20,456,3,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(21,289,5,NULL,5,'1.00',NULL,NULL),(22,289,5,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(23,289,6,NULL,5,'1.00',NULL,NULL),(24,289,6,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(25,377,7,NULL,5,'1.00',NULL,NULL),(26,377,7,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(27,377,8,NULL,5,'1.00',NULL,NULL),(28,377,8,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(29,343,9,NULL,5,'1.00',NULL,NULL),(30,343,9,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(31,343,10,NULL,5,'1.00',NULL,NULL),(32,343,10,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(33,116,11,NULL,5,'1.00',NULL,NULL),(34,116,11,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(35,399,11,NULL,5,'1.00',NULL,NULL),(36,399,11,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(37,469,11,NULL,10,'10.00',NULL,NULL),(38,469,11,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(39,491,11,NULL,5,'1.00',NULL,NULL),(40,491,11,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(41,575,11,NULL,5,'1.00',NULL,NULL),(42,575,11,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(43,116,12,NULL,5,'1.00',NULL,NULL),(44,116,12,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(45,399,12,NULL,5,'1.00',NULL,NULL),(46,399,12,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(47,469,12,NULL,5,'1.00',NULL,NULL),(48,469,12,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(49,491,12,NULL,5,'1.00',NULL,NULL),(50,491,12,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(51,575,12,NULL,5,'1.00',NULL,NULL),(52,575,12,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(53,116,13,NULL,10,'10.00',NULL,NULL),(54,116,13,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(55,399,13,NULL,5,'1.00',NULL,NULL),(56,399,13,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(57,469,13,NULL,10,'10.00',NULL,NULL),(58,469,13,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(59,491,13,NULL,5,'1.00',NULL,NULL),(60,491,13,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(61,575,13,NULL,5,'1.00',NULL,NULL),(62,575,13,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(63,175,14,NULL,5,'1.00',NULL,NULL),(64,175,14,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(65,348,14,NULL,5,'1.00',NULL,NULL),(66,348,14,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(67,175,15,NULL,5,'1.00',NULL,NULL),(68,175,15,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(69,348,15,NULL,5,'1.00',NULL,NULL),(70,348,15,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(71,175,13,NULL,5,'1.00',NULL,NULL),(72,175,13,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(73,348,13,NULL,5,'1.00',NULL,NULL),(74,348,13,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(75,247,16,NULL,5,'1.00',NULL,NULL),(76,247,16,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(77,343,16,NULL,5,'1.00',NULL,NULL),(78,343,16,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(79,118,17,NULL,5,'1.00',NULL,NULL),(80,118,17,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(81,308,17,NULL,5,'1.00',NULL,NULL),(82,308,17,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(83,311,17,NULL,5,'1.00',NULL,NULL),(84,311,17,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(85,340,17,NULL,5,'1.00',NULL,NULL),(86,340,17,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(87,357,17,NULL,5,'1.00',NULL,NULL),(88,357,17,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(89,118,5,NULL,5,'1.00',NULL,NULL),(90,118,5,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(91,308,5,NULL,5,'1.00',NULL,NULL),(92,308,5,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(93,311,5,NULL,5,'1.00',NULL,NULL),(94,311,5,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(95,340,5,NULL,5,'1.00',NULL,NULL),(96,340,5,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(97,357,5,NULL,5,'1.00',NULL,NULL),(98,357,5,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(99,118,18,NULL,5,'1.00',NULL,NULL),(100,118,18,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(101,159,18,NULL,5,'10.00',NULL,NULL),(102,159,18,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(103,192,18,NULL,5,'10.00',NULL,NULL),(104,192,18,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(105,215,18,NULL,5,'1.00',NULL,NULL),(106,215,18,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(107,288,18,NULL,5,'10.00',NULL,NULL),(108,288,18,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(109,370,18,NULL,5,'10.00',NULL,NULL),(110,370,18,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(111,549,18,NULL,5,'1.00',NULL,NULL),(112,549,18,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(113,564,18,NULL,5,'10.00',NULL,NULL),(114,564,18,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(115,565,18,NULL,5,'10.00',NULL,NULL),(116,565,18,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(117,582,18,NULL,5,'10.00',NULL,NULL),(118,582,18,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(119,214,11,NULL,5,'1.00',NULL,NULL),(120,214,11,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(121,469,11,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(122,214,13,NULL,5,'1.00',NULL,NULL),(123,214,13,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(124,469,13,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(125,469,19,NULL,5,'1.00',NULL,NULL),(126,469,19,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(127,525,19,NULL,5,'1.00',NULL,NULL),(128,525,19,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(129,469,20,NULL,5,'1.00',NULL,NULL),(130,469,20,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(131,525,20,NULL,5,'1.00',NULL,NULL),(132,525,20,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(137,144,5,NULL,5,'1.00',NULL,NULL),(138,144,5,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(139,530,5,NULL,5,'1.00',NULL,NULL),(140,530,5,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(141,75,8,NULL,10,'10.00',NULL,NULL),(142,75,8,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(143,75,22,NULL,10,'10.00',NULL,NULL),(144,75,22,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(145,75,23,NULL,5,'1.00',NULL,NULL),(146,75,23,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(147,76,24,NULL,5,'1.00',NULL,NULL),(148,76,24,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(149,214,24,NULL,5,'1.00',NULL,NULL),(150,214,24,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(151,76,25,NULL,5,'1.00',NULL,NULL),(152,76,25,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(153,214,25,NULL,5,'1.00',NULL,NULL),(154,214,25,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(155,144,26,NULL,5,'1.00',NULL,NULL),(156,144,26,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(157,201,26,NULL,5,'1.00',NULL,NULL),(158,201,26,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(159,262,26,NULL,5,'1.00',NULL,NULL),(160,262,26,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(161,286,26,NULL,5,'1.00',NULL,NULL),(162,286,26,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(163,311,26,NULL,5,'1.00',NULL,NULL),(164,311,26,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(165,324,26,NULL,5,'1.00',NULL,NULL),(166,324,26,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(167,325,26,NULL,5,'1.00',NULL,NULL),(168,325,26,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(169,456,26,NULL,5,'1.00',NULL,NULL),(170,456,26,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(171,469,26,NULL,5,'1.00',NULL,NULL),(172,469,26,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(173,491,26,NULL,5,'1.00',NULL,NULL),(174,491,26,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(175,500,26,NULL,5,'1.00',NULL,NULL),(176,500,26,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(177,144,27,NULL,5,'1.00',NULL,NULL),(178,144,27,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(179,201,27,NULL,5,'1.00',NULL,NULL),(180,201,27,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(181,262,27,NULL,5,'1.00',NULL,NULL),(182,262,27,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(183,286,27,NULL,5,'1.00',NULL,NULL),(184,286,27,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(185,311,27,NULL,5,'1.00',NULL,NULL),(186,311,27,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(187,324,27,NULL,5,'1.00',NULL,NULL),(188,324,27,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(189,325,27,NULL,5,'1.00',NULL,NULL),(190,325,27,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(191,456,27,NULL,5,'1.00',NULL,NULL),(192,456,27,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(193,469,27,NULL,5,'1.00',NULL,NULL),(194,469,27,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(195,491,27,NULL,5,'1.00',NULL,NULL),(196,491,27,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(197,500,27,NULL,5,'1.00',NULL,NULL),(198,500,27,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(199,98,13,NULL,5,'10.00',NULL,NULL),(200,98,13,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(201,116,13,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(202,137,28,NULL,5,'10.00',NULL,NULL),(203,137,28,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(204,144,28,NULL,5,'1.00',NULL,NULL),(205,144,28,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(206,311,28,NULL,5,'1.00',NULL,NULL),(207,311,28,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(208,339,28,NULL,5,'10.00',NULL,NULL),(209,339,28,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(210,347,28,NULL,5,'1.00',NULL,NULL),(211,347,28,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(212,377,28,NULL,5,'1.00',NULL,NULL),(213,377,28,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(214,395,28,NULL,5,'10.00',NULL,NULL),(215,395,28,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(216,399,28,NULL,5,'1.00',NULL,NULL),(217,399,28,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(218,491,28,NULL,5,'1.00',NULL,NULL),(219,491,28,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(220,533,28,NULL,5,'1.00',NULL,NULL),(221,533,28,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(222,575,28,NULL,5,'1.00',NULL,NULL),(223,575,28,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(224,734,28,NULL,5,'10.00',NULL,NULL),(225,734,28,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(226,107,22,NULL,5,'1.00',NULL,NULL),(227,107,22,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(228,122,22,NULL,5,'1.00',NULL,NULL),(229,122,22,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(230,107,7,NULL,5,'1.00',NULL,NULL),(231,107,7,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(232,122,7,NULL,5,'1.00',NULL,NULL),(233,122,7,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(234,79,29,NULL,5,'1.00',NULL,NULL),(235,79,29,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(236,222,29,NULL,5,'1.00',NULL,NULL),(237,222,29,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(238,374,29,NULL,5,'1.00',NULL,NULL),(239,374,29,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(240,811,29,NULL,5,'1.00',NULL,NULL),(241,811,29,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(242,965,30,NULL,5,'10.00',NULL,NULL),(243,965,30,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(244,79,30,NULL,5,'1.00',NULL,NULL),(245,79,30,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(246,222,30,NULL,5,'1.00',NULL,NULL),(247,222,30,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(248,374,30,NULL,5,'1.00',NULL,NULL),(249,374,30,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(250,811,30,NULL,5,'1.00',NULL,NULL),(251,811,30,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(252,70,31,NULL,5,'10.00',NULL,NULL),(253,70,31,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(254,167,31,NULL,5,'10.00',NULL,NULL),(255,167,31,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(256,201,31,NULL,5,'1.00',NULL,NULL),(257,201,31,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(258,215,31,NULL,5,'1.00',NULL,NULL),(259,215,31,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(260,301,31,NULL,5,'10.00',NULL,NULL),(261,301,31,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(262,377,31,NULL,5,'1.00',NULL,NULL),(263,377,31,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(264,423,31,NULL,5,'10.00',NULL,NULL),(265,423,31,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(266,544,31,NULL,5,'10.00',NULL,NULL),(267,544,31,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(268,549,31,NULL,5,'1.00',NULL,NULL),(269,549,31,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(270,605,30,NULL,5,'10.00',NULL,NULL),(271,605,30,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(272,223,32,NULL,5,'1.00',NULL,NULL),(273,223,32,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(274,671,33,NULL,5,'1.00',NULL,NULL),(275,671,33,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(276,684,33,NULL,5,'1.00',NULL,NULL),(277,684,33,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(278,707,33,NULL,5,'1.00',NULL,NULL),(279,707,33,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(280,765,33,NULL,5,'1.00',NULL,NULL),(281,765,33,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(282,766,33,NULL,5,'1.00',NULL,NULL),(283,766,33,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(284,850,33,NULL,5,'1.00',NULL,NULL),(285,850,33,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(286,907,33,NULL,5,'1.00',NULL,NULL),(287,907,33,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(288,941,33,NULL,5,'1.00',NULL,NULL),(289,941,33,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(290,951,33,NULL,5,'1.00',NULL,NULL),(291,951,33,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(292,671,34,NULL,5,'1.00',NULL,NULL),(293,671,34,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(294,684,34,NULL,5,'1.00',NULL,NULL),(295,684,34,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(296,707,34,NULL,5,'1.00',NULL,NULL),(297,707,34,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(298,765,34,NULL,5,'1.00',NULL,NULL),(299,765,34,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(300,766,34,NULL,5,'1.00',NULL,NULL),(301,766,34,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(302,850,34,NULL,5,'1.00',NULL,NULL),(303,850,34,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(304,907,34,NULL,5,'1.00',NULL,NULL),(305,907,34,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(306,941,34,NULL,5,'1.00',NULL,NULL),(307,941,34,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(308,951,34,NULL,5,'1.00',NULL,NULL),(309,951,34,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(310,89,35,NULL,5,'10.00',NULL,NULL),(311,89,35,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(312,286,35,NULL,5,'1.00',NULL,NULL),(313,286,35,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(314,75,30,NULL,5,'1.00',NULL,NULL),(315,75,30,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(316,247,30,NULL,5,'1.00',NULL,NULL),(317,247,30,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(318,75,22,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(319,247,22,NULL,5,'1.00',NULL,NULL),(320,247,22,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(321,75,8,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(322,247,8,NULL,5,'1.00',NULL,NULL),(323,247,8,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(324,533,22,NULL,5,'1.00',NULL,NULL),(325,533,22,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(326,79,11,NULL,5,'1.00',NULL,NULL),(327,79,11,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(328,289,11,NULL,5,'1.00',NULL,NULL),(329,289,11,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(330,412,11,NULL,5,'10.00',NULL,NULL),(331,412,11,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(332,102,36,NULL,5,'10.00',NULL,NULL),(333,102,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(334,611,36,NULL,5,'10.00',NULL,NULL),(335,611,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(336,618,36,NULL,5,'10.00',NULL,NULL),(337,618,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(338,627,36,NULL,5,'10.00',NULL,NULL),(339,627,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(340,638,36,NULL,5,'10.00',NULL,NULL),(341,638,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(342,655,36,NULL,5,'10.00',NULL,NULL),(343,655,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(344,671,36,NULL,5,'1.00',NULL,NULL),(345,671,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(346,710,36,NULL,5,'10.00',NULL,NULL),(347,710,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(348,719,36,NULL,5,'1.00',NULL,NULL),(349,719,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(350,752,36,NULL,5,'10.00',NULL,NULL),(351,752,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(352,753,36,NULL,5,'10.00',NULL,NULL),(353,753,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(354,765,36,NULL,5,'1.00',NULL,NULL),(355,765,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(356,812,36,NULL,5,'10.00',NULL,NULL),(357,812,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(358,819,36,NULL,5,'10.00',NULL,NULL),(359,819,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(360,823,36,NULL,5,'10.00',NULL,NULL),(361,823,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(362,825,36,NULL,5,'10.00',NULL,NULL),(363,825,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(364,834,36,NULL,5,'10.00',NULL,NULL),(365,834,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(366,849,36,NULL,5,'10.00',NULL,NULL),(367,849,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(368,853,36,NULL,5,'10.00',NULL,NULL),(369,853,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(370,873,36,NULL,5,'10.00',NULL,NULL),(371,873,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(372,880,36,NULL,5,'10.00',NULL,NULL),(373,880,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(374,893,36,NULL,5,'10.00',NULL,NULL),(375,893,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(376,911,36,NULL,5,'10.00',NULL,NULL),(377,911,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(378,934,36,NULL,5,'10.00',NULL,NULL),(379,934,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(380,943,36,NULL,5,'10.00',NULL,NULL),(381,943,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(382,953,36,NULL,5,'10.00',NULL,NULL),(383,953,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(384,954,36,NULL,5,'10.00',NULL,NULL),(385,954,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(386,957,36,NULL,5,'10.00',NULL,NULL),(387,957,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(388,976,36,NULL,5,'10.00',NULL,NULL),(389,976,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(390,977,36,NULL,5,'10.00',NULL,NULL),(391,977,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(392,995,36,NULL,5,'10.00',NULL,NULL),(393,995,36,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(394,1003,36,NULL,5,'10.00',NULL,NULL),(395,1003,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(396,1005,36,NULL,5,'10.00',NULL,NULL),(397,1005,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(398,1017,36,NULL,5,'10.00',NULL,NULL),(399,1017,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(400,1023,36,NULL,5,'10.00',NULL,NULL),(401,1023,36,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(402,658,37,NULL,5,'10.00',NULL,NULL),(403,658,37,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(404,730,22,NULL,5,'1.00',NULL,NULL),(405,730,22,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(406,769,22,NULL,5,'1.00',NULL,NULL),(407,769,22,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(408,820,22,NULL,5,'1.00',NULL,NULL),(409,820,22,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(410,848,22,NULL,5,'1.00',NULL,NULL),(411,848,22,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(412,894,22,NULL,5,'1.00',NULL,NULL),(413,894,22,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(414,925,22,NULL,5,'1.00',NULL,NULL),(415,925,22,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(416,1015,22,NULL,5,'1.00',NULL,NULL),(417,1015,22,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(418,730,8,NULL,5,'1.00',NULL,NULL),(419,730,8,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(420,769,8,NULL,5,'1.00',NULL,NULL),(421,769,8,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(422,820,8,NULL,5,'1.00',NULL,NULL),(423,820,8,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(424,848,8,NULL,5,'1.00',NULL,NULL),(425,848,8,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(426,894,8,NULL,5,'1.00',NULL,NULL),(427,894,8,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(428,925,8,NULL,5,'1.00',NULL,NULL),(429,925,8,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(430,1015,8,NULL,5,'1.00',NULL,NULL),(431,1015,8,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(432,907,38,NULL,5,'1.00',NULL,NULL),(433,907,38,'PoliticianIssueDetail',1,'5.00','BillCoSponsor',111),(434,932,38,NULL,5,'10.00',NULL,NULL),(435,932,38,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(436,719,3,NULL,5,'1.00',NULL,NULL),(437,719,3,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(438,719,39,NULL,5,'1.00',NULL,NULL),(439,719,39,'PoliticianIssueDetail',1,'5.00','BillSponsor',111),(440,719,40,NULL,5,'1.00',NULL,NULL),(441,719,40,'PoliticianIssueDetail',1,'5.00','BillSponsor',111);
/*!40000 ALTER TABLE `politician_issues` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) collate utf8_bin NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('1'),('2'),('3'),('4');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-03-31 15:59:55
