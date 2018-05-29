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

CREATE DATABASE $project_name_plugin DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE $project_name_plugin;

# ------------------------------------------------------------

# Dump of table ident_ctx
# ------------------------------------------------------------

DROP TABLE IF EXISTS `ident_ctx`;

CREATE TABLE `ident_ctx` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `ident_ctx` WRITE;
/*!40000 ALTER TABLE `ident_ctx` DISABLE KEYS */;

INSERT INTO `ident_ctx` (`id`, `key`, `value`, `type`, `op_time`)
VALUES 
    (1,'1','{}','meta', now());

/*!40000 ALTER TABLE `ident_ctx` ENABLE KEYS */;
UNLOCK TABLES;

# Dump of table basic_auth
# ------------------------------------------------------------

DROP TABLE IF EXISTS `basic_auth`;

CREATE TABLE `basic_auth` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `basic_auth` WRITE;
/*!40000 ALTER TABLE `basic_auth` DISABLE KEYS */;

INSERT INTO `basic_auth` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());

/*!40000 ALTER TABLE `basic_auth` ENABLE KEYS */;
UNLOCK TABLES;

# Dump of table divide
# ------------------------------------------------------------

DROP TABLE IF EXISTS `divide`;

CREATE TABLE `divide` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `divide` WRITE;
/*!40000 ALTER TABLE `divide` DISABLE KEYS */;

INSERT INTO `divide` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());

/*!40000 ALTER TABLE `divide` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table key_auth
# ------------------------------------------------------------

DROP TABLE IF EXISTS `key_auth`;

CREATE TABLE `key_auth` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `key_auth` WRITE;
/*!40000 ALTER TABLE `key_auth` DISABLE KEYS */;

INSERT INTO `key_auth` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());

/*!40000 ALTER TABLE `key_auth` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table meta
# ------------------------------------------------------------

DROP TABLE IF EXISTS `meta`;

CREATE TABLE `meta` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(5000) NOT NULL DEFAULT '',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `meta` (`id`, `key`, `value`, `op_time`)
VALUES
    (1,'ident_ctx.enable','1', now());


# Dump of table monitor
# ------------------------------------------------------------

DROP TABLE IF EXISTS `monitor`;

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
/*!40000 ALTER TABLE `monitor` DISABLE KEYS */;

INSERT INTO `monitor` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());

/*!40000 ALTER TABLE `monitor` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table rate_limiting
# ------------------------------------------------------------

DROP TABLE IF EXISTS `rate_limiting`;

CREATE TABLE `rate_limiting` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `rate_limiting` WRITE;
/*!40000 ALTER TABLE `rate_limiting` DISABLE KEYS */;

INSERT INTO `rate_limiting` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());

/*!40000 ALTER TABLE `rate_limiting` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `property_rate_limiting`;

CREATE TABLE `property_rate_limiting` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `property_rate_limiting` WRITE;
/*!40000 ALTER TABLE `property_rate_limiting` DISABLE KEYS */;

INSERT INTO `property_rate_limiting` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());

/*!40000 ALTER TABLE `property_rate_limiting` ENABLE KEYS */;
UNLOCK TABLES;

# Dump of table signature_auth
# ------------------------------------------------------------

DROP TABLE IF EXISTS `signature_auth`;

CREATE TABLE `signature_auth` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `signature_auth` WRITE;
/*!40000 ALTER TABLE `signature_auth` DISABLE KEYS */;

INSERT INTO `signature_auth` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());

/*!40000 ALTER TABLE `signature_auth` ENABLE KEYS */;
UNLOCK TABLES;

# Dump of table redirect
# ------------------------------------------------------------

DROP TABLE IF EXISTS `redirect`;

CREATE TABLE `redirect` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `redirect` WRITE;
/*!40000 ALTER TABLE `redirect` DISABLE KEYS */;

INSERT INTO `redirect` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());

/*!40000 ALTER TABLE `redirect` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table rewrite
# ------------------------------------------------------------

DROP TABLE IF EXISTS `rewrite`;

CREATE TABLE `rewrite` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `rewrite` WRITE;
/*!40000 ALTER TABLE `rewrite` DISABLE KEYS */;

INSERT INTO `rewrite` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());

/*!40000 ALTER TABLE `rewrite` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table waf
# ------------------------------------------------------------

DROP TABLE IF EXISTS `waf`;

CREATE TABLE `waf` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(2000) NOT NULL DEFAULT '',
  `type` varchar(11) DEFAULT '0',
  `op_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `waf` WRITE;
/*!40000 ALTER TABLE `waf` DISABLE KEYS */;

INSERT INTO `waf` (`id`, `key`, `value`, `type`, `op_time`)
VALUES
    (1,'1','{}','meta', now());

/*!40000 ALTER TABLE `waf` ENABLE KEYS */;
UNLOCK TABLES;


/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;