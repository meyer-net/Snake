USE mysql;
/* ******************************************************************************* */
DROP DATABASE IF EXISTS $project_name_log_1;
CREATE DATABASE $project_name_log_1 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
use $project_name_log_1;
/* 通信交互信息表 */
CREATE TABLE sys_logs
(
    id VARCHAR(36) NOT NULL DEFAULT 'NOTSET' COMMENT '标识列',
    uri VARCHAR(100) NOT NULL COMMENT '请求地址信息',
    host VARCHAR(15) NOT NULL COMMENT '请求host信息',
    level INT NOT NULL COMMENT '日志等级',
    content VARCHAR(2048) NOT NULL COMMENT '正文内容',
    `from` VARCHAR(256) NOT NULL COMMENT '来自于模块',
    project VARCHAR(36) NOT NULL COMMENT '来自于项目',
    create_date DATE NOT NULL COMMENT '按月分表字段',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
  	gid int DEFAULT 1 COMMENT '群id，mysql分区字段',
    PRIMARY KEY (`id`, `gid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
PARTITION BY KEY(`gid`) 
PARTITIONS 31;

DELIMITER //
CREATE PROCEDURE p_create_dbs(dbn INT)
BEGIN
  DECLARE creator_sql VARCHAR(5000);
  DECLARE I INT;
  SET I=2;
  WHILE I<=dbn 
  DO
    SET @creator_sql=CONCAT("CREATE DATABASE IF NOT EXISTS $project_name_log_", I, " DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;");
    PREPARE stmt FROM @creator_sql;
    EXECUTE stmt;

    SET @creator_sql=CONCAT("CREATE TABLE IF NOT EXISTS $project_name_log_", I, ".sys_logs LIKE $project_name_log_1.sys_logs;");
    PREPARE stmt FROM @creator_sql;
    EXECUTE stmt;

    SET @creator_sql=CONCAT("DB_", I, " Was Created");
    SELECT @creator_sql;

    SET I=I+1;
    DEALLOCATE PREPARE stmt; 
  END WHILE;
END
//
DELIMITER ;

/* ******************************************************************************* */
CALL p_create_dbs(36);
-- 反向SHELL操作
-- for db in `find /clouddisk/data/mariadb/exch_io_log_* -type d | awk -F'/' '{print $NF}'`;do  mysql -uroot -pdbsys_1lcl^all -e"DROP DATABASE $db;" ;done
/* ******************************************************************************* */
DROP PROCEDURE IF EXISTS p_create_dbs;
/* ******************************************************************************* */