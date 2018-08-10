# ************************************************************
# Sequel Pro SQL dump
# Version 4096
#
# http://www.sequelpro.com/
# http://code.google.com/p/sequel-pro/
#
# Host: 127.0.0.1 (MySQL 5.6.15)
# Database: lor_test
# Generation Time: 2018-05-03 13:00:00 +0000
# ************************************************************

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

# ------------------------------------------------------------

CREATE DATABASE IF NOT EXISTS $project_name_plugin DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE $project_name_plugin;
USE mysql;
/* ******************************************************************************* */
DROP DATABASE IF EXISTS $project_name_log_1;
CREATE DATABASE $project_name_log_1 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
use $project_name_log_1;

CREATE TABLE IF NOT EXISTS `meta` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(5000) NOT NULL DEFAULT '',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `monitor` WRITE;
INSERT INTO `meta` (`id`, `key`, `value`, `op_time`)
VALUES
    (1,'stat.enable','1', now());
INSERT INTO `meta` (`id`, `key`, `value`, `op_time`)
VALUES
    (2,'map.enable','2', now());
UNLOCK TABLES;

# ------------------------------------------------------------

DROP TABLE IF NOT EXISTS `monitor`;

CREATE TABLE `monitor` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `monitor` WRITE;
INSERT INTO `monitor` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());
UNLOCK TABLES;

/* ******************************************************************************* */

CREATE TABLE IF NOT EXISTS `ident_ctx` LIKE monitor;
LOCK TABLES `ident_ctx` WRITE;
INSERT INTO `ident_ctx` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());
UNLOCK TABLES;

CREATE TABLE IF NOT EXISTS `capture` LIKE monitor;
LOCK TABLES `capture` WRITE;
INSERT INTO `capture` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());
UNLOCK TABLES;

CREATE TABLE IF NOT EXISTS `filter` LIKE monitor;
LOCK TABLES `filter` WRITE;
INSERT INTO `filter` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());
UNLOCK TABLES;

CREATE TABLE IF NOT EXISTS `basic_auth` LIKE monitor;
LOCK TABLES `basic_auth` WRITE;
INSERT INTO `basic_auth` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());
UNLOCK TABLES;

CREATE TABLE IF NOT EXISTS `divide` LIKE monitor;
LOCK TABLES `divide` WRITE;
INSERT INTO `divide` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());
UNLOCK TABLES;

CREATE TABLE IF NOT EXISTS `key_auth` LIKE monitor;
LOCK TABLES `key_auth` WRITE;
INSERT INTO `key_auth` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());
UNLOCK TABLES;

CREATE TABLE IF NOT EXISTS `rate_limiting` LIKE monitor;
LOCK TABLES `rate_limiting` WRITE;
INSERT INTO `rate_limiting` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());
UNLOCK TABLES;

CREATE TABLE IF NOT EXISTS `property_rate_limiting` LIKE monitor;
LOCK TABLES `property_rate_limiting` WRITE;
INSERT INTO `property_rate_limiting` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());
UNLOCK TABLES;

CREATE TABLE IF NOT EXISTS `signature_auth` LIKE monitor;
LOCK TABLES `signature_auth` WRITE;
INSERT INTO `signature_auth` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());
UNLOCK TABLES;

CREATE TABLE IF NOT EXISTS `redirect` LIKE monitor;
LOCK TABLES `redirect` WRITE;
INSERT INTO `redirect` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());
UNLOCK TABLES;

CREATE TABLE IF NOT EXISTS `rewrite` LIKE monitor;
LOCK TABLES `rewrite` WRITE;
INSERT INTO `rewrite` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());
UNLOCK TABLES;

CREATE TABLE IF NOT EXISTS `waf` LIKE monitor;
LOCK TABLES `waf` WRITE;
INSERT INTO `waf` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());
UNLOCK TABLES;

CREATE TABLE IF NOT EXISTS `map` LIKE monitor;
LOCK TABLES `map` WRITE;
INSERT INTO `map` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());
UNLOCK TABLES;


/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;