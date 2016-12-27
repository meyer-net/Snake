/*
Navicat MySQL Data Transfer

Source Server         : LnxSvr.Dev176
Source Server Version : 50629
Source Host           : 192.168.1.176:8066
Source Database       : db_lor_logs

Target Server Type    : MYSQL
Target Server Version : 50629
File Encoding         : 65001

Date: 2016-11-21 08:58:11
*/

----------------------------------------------------------------------------------------

SET FOREIGN_KEY_CHECKS=0;
DROP TABLE IF EXISTS MYCAT_SEQUENCE;  
CREATE TABLE MYCAT_SEQUENCE (  name VARCHAR(50) NOT NULL,  current_value INT NOT NULL,  increment INT NOT NULL DEFAULT 100, PRIMARY KEY (name) ) ENGINE=InnoDB;

-- ----------------------------
-- Function structure for `mycat_seq_currval`
-- ----------------------------
DROP FUNCTION IF EXISTS `mycat_seq_currval`;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `mycat_seq_currval`(seq_name VARCHAR(50)) RETURNS varchar(64) CHARSET latin1
    DETERMINISTIC
BEGIN
    DECLARE retval VARCHAR(64);
    SET retval="-1,0";
    SELECT concat(CAST(current_value AS CHAR),",",CAST(increment AS CHAR) ) INTO retval FROM MYCAT_SEQUENCE  WHERE name = seq_name;
    RETURN retval ;
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for `mycat_seq_nextval`
-- ----------------------------
DROP FUNCTION IF EXISTS `mycat_seq_nextval`;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `mycat_seq_nextval`(seq_name VARCHAR(50)) RETURNS varchar(64) CHARSET latin1
    DETERMINISTIC
BEGIN
    DECLARE retval VARCHAR(64);
    DECLARE val BIGINT;
    DECLARE inc INT;
    DECLARE seq_lock INT;
    set val = -1;
    set inc = 0;
    SET seq_lock = -1;
    SELECT GET_LOCK(seq_name, 15) into seq_lock;
    if seq_lock = 1 then
      SELECT current_value + increment, increment INTO val, inc FROM MYCAT_SEQUENCE WHERE name = seq_name for update;
      if val != -1 then
          UPDATE MYCAT_SEQUENCE SET current_value = val WHERE name = seq_name;
      end if;
      SELECT RELEASE_LOCK(seq_name) into seq_lock;
    end if;
    SELECT concat(CAST((val - inc + 1) as CHAR),",",CAST(inc as CHAR)) INTO retval;
    RETURN retval;
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for `mycat_seq_setval`
-- ----------------------------
DROP FUNCTION IF EXISTS `mycat_seq_setval`;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `mycat_seq_setval`(seq_name VARCHAR(50), value INTEGER) RETURNS varchar(64) CHARSET latin1
    DETERMINISTIC
BEGIN
    DECLARE retval VARCHAR(64);
    DECLARE inc INT;
    SET inc = 0;
    SELECT increment INTO inc FROM MYCAT_SEQUENCE WHERE name = seq_name;
    UPDATE MYCAT_SEQUENCE SET current_value = value WHERE name = seq_name;
    SELECT concat(CAST(value as CHAR),",",CAST(inc as CHAR)) INTO retval;
    RETURN retval;
END
;;
DELIMITER ;

GRANT ALL PRIVILEGES ON *.* TO ROOT@"%" IDENTIFIED BY ".";
FLUSH PRIVILEGES;

INSERT INTO MYCAT_SEQUENCE VALUES ('GLOBAL', 0, 100);
-- SELECT MYCAT_SEQ_SETVAL('GLOBAL', 1);
-- SELECT MYCAT_SEQ_CURRVAL('GLOBAL');
-- SELECT MYCAT_SEQ_NEXTVAL('GLOBAL');

/*

1：修改/opt/programs/mycat/conf/rule.xml，替换添加如下节点
<mycat:rule xmlns:mycat="http://io.mycat/">
  <!--分区配置，按照自然月进行分区，分区字段是create_date-->
  <tableRule name="sharding-by-month"> 
    <rule>
      <columns>create_date</columns>
      <algorithm>sharding-by-month</algorithm> 
    </rule>
  </tableRule>

  <function name="sharding-by-month" class="io.mycat.route.function.PartitionByMonth">
    <property name="dateFormat">yyyyMMdd</property> 
    <property name="sBeginDate">20161201</property> <!--开始日期-->
    <property name="sPartionDay">1</property>  <!--每分片天数-->
  </function>
</mycat:rule>

2：修改 conf/server.xml，添加如下用户及访问结构设定
  <user name="root">
    <property name="password">123456</property>
    <property name="schemas">db_test,db_lor_logs</property>
  </user>

3：修改 conf/schema.xml，替换为如下内容
  <mycat:schema xmlns:mycat="http://io.mycat/">
    <schema name="db_test" checkSQLschema="false" sqlMaxLimit="100" dataNode="dn_default" />
    <!-- sqlMaxLimit设置limit防止错误sql查询大量数据 -->
    <schema name="db_lor_logs" checkSQLschema="false" sqlMaxLimit="100" >
      <table name="lor_log" primaryKey="create_date" dataNode="dn_lor_logs_201611,dn_lor_logs_201612,dn_lor_logs_201701,dn_lor_logs_201702,dn_lor_logs_201703,dn_lor_logs_201704,dn_lor_logs_201705,dn_lor_logs_201706,dn_lor_logs_201707,dn_lor_logs_201708,dn_lor_logs_201709,dn_lor_logs_201710,dn_lor_logs_201711,dn_lor_logs_201712,dn_lor_logs_201801,dn_lor_logs_201802,dn_lor_logs_201803,dn_lor_logs_201804,dn_lor_logs_201805,dn_lor_logs_201806,dn_lor_logs_201807,dn_lor_logs_201808,dn_lor_logs_201809,dn_lor_logs_201810,dn_lor_logs_201811,dn_lor_logs_201812" rule="sharding-by-month" />
    </schema>
  
    <dataNode name="dn_default" dataHost="localhost1" database="mycatdb" />
  
      <!--按照月份进行拆分，一次做好二年的数据库。同时数据库中，可以根据实际情况在做mysql分区。-->
    <dataNode name="dn_lor_logs_201612" dataHost="localhost1" database="db_lor_logs_201612" />
    <dataNode name="dn_lor_logs_201701" dataHost="localhost1" database="db_lor_logs_201701" />
    <dataNode name="dn_lor_logs_201702" dataHost="localhost1" database="db_lor_logs_201702" />
    <dataNode name="dn_lor_logs_201703" dataHost="localhost1" database="db_lor_logs_201703" />
    <dataNode name="dn_lor_logs_201704" dataHost="localhost1" database="db_lor_logs_201704" />
    <dataNode name="dn_lor_logs_201705" dataHost="localhost1" database="db_lor_logs_201705" />
    <dataNode name="dn_lor_logs_201706" dataHost="localhost1" database="db_lor_logs_201706" />
    <dataNode name="dn_lor_logs_201707" dataHost="localhost1" database="db_lor_logs_201707" />
    <dataNode name="dn_lor_logs_201708" dataHost="localhost1" database="db_lor_logs_201708" />
    <dataNode name="dn_lor_logs_201709" dataHost="localhost1" database="db_lor_logs_201709" />
    <dataNode name="dn_lor_logs_201710" dataHost="localhost1" database="db_lor_logs_201710" />
    <dataNode name="dn_lor_logs_201711" dataHost="localhost1" database="db_lor_logs_201711" />
    <dataNode name="dn_lor_logs_201712" dataHost="localhost1" database="db_lor_logs_201712" />
    <dataNode name="dn_lor_logs_201801" dataHost="localhost1" database="db_lor_logs_201801" />
    <dataNode name="dn_lor_logs_201802" dataHost="localhost1" database="db_lor_logs_201802" />
    <dataNode name="dn_lor_logs_201803" dataHost="localhost1" database="db_lor_logs_201803" />
    <dataNode name="dn_lor_logs_201804" dataHost="localhost1" database="db_lor_logs_201804" />
    <dataNode name="dn_lor_logs_201805" dataHost="localhost1" database="db_lor_logs_201805" />
    <dataNode name="dn_lor_logs_201806" dataHost="localhost1" database="db_lor_logs_201806" />
    <dataNode name="dn_lor_logs_201807" dataHost="localhost1" database="db_lor_logs_201807" />
    <dataNode name="dn_lor_logs_201808" dataHost="localhost1" database="db_lor_logs_201808" />
    <dataNode name="dn_lor_logs_201809" dataHost="localhost1" database="db_lor_logs_201809" />
    <dataNode name="dn_lor_logs_201810" dataHost="localhost1" database="db_lor_logs_201810" />
    <dataNode name="dn_lor_logs_201811" dataHost="localhost1" database="db_lor_logs_201811" />
    <dataNode name="dn_lor_logs_201812" dataHost="localhost1" database="db_lor_logs_201812" />
    <!-- 可以一直按月分区下去。 -->
  
    <dataHost name="localhost1" maxCon="1000" minCon="10" balance="1"
      writeType="0" dbType="mysql" dbDriver="native" switchType="2"  slaveThreshold="100">
      <heartbeat>select user()</heartbeat>
      <!-- can have multi write hosts -->
      <writeHost host="hostM1" url="localhost:3306" user="root" password="dbrootdev@svr.1-176">
        <!-- can have multi read hosts -->
        <readHost host="hostS2" url="localhost:3306" user="root" password="dbrootdev@svr.1-176" />
      </writeHost>
      <!-- <writeHost host="hostS1" url="localhost:3306" user="root" password=""/> -->
    </dataHost>
  </mycat:schema>
*/