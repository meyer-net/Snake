CREATE DATABASE db_odta_logs_201611 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201612 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201701 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201702 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201703 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201704 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201705 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201706 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201707 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201708 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201709 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201710 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201711 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201712 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201801 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201802 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201803 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201804 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201805 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201806 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201807 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201808 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201809 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201810 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201811 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE DATABASE db_odta_logs_201812 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

use db_odta_logs_201611;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT 1 COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201612;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201701;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201702;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201703;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201704;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201705;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201706;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201707;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201708;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201709;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201710;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201711;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201712;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201801;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201802;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201803;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201804;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201805;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201806;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201807;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201808;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201809;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201810;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201811;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

use db_odta_logs_201812;
CREATE TABLE `flow_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '自增列',
  `gid` bigint(20) DEFAULT NULL COMMENT '群id，mysql分区字段',
  `shunt` varchar(32) NOT NULL COMMENT '分流依据',
  `source` varchar(32) NOT NULL COMMENT '来源',
  `medium` varchar(32) DEFAULT NULL COMMENT '媒介',
  `data` varchar(8000) NOT NULL COMMENT '传递数据',
  `client_host` varchar(32) NOT NULL COMMENT '客户端IP',
  `calculate_time` int(11) DEFAULT NULL COMMENT '计算时间',
  `buffer_time` int(11) NOT NULL COMMENT '缓冲时间',
  `create_date` int(8) DEFAULT NULL COMMENT '按月分表字段，不能为空。',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`gid`),
  KEY `IX_CREATE_DATE` (`create_date`) USING BTREE,
  KEY `IX_SHUNT` (`shunt`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;