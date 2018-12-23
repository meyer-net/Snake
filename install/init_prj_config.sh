#!/bin/sh
#------------------------------------------------
#      Centos7 Project Env InstallScript
#      copyright https://echat.oshit.com/
#      email: meyer_net@foxmail.com
#------------------------------------------------

# Default config:
LOR_PORT=5555
BIZ_PORT=$LOR_PORT
WAF_PORT=7777
API_PORT=9999

DB_HOST='127.0.0.1'
DB_PORT=3306
DB_UNAME='root'
DB_UPWD='123456'

CHE_TYPE='nginx'
CHE_MODE='sys_default'
RAM_REDIS_HOST='127.0.0.1'
RAM_REDIS_PORT=6379
RAM_NGINX_ATTACH=''

RAM_NGINX_SETED=false
RAM_REDIS_SETED=false
RAM_KAFKA_SETED=false

BUFFER_TYPE='nginx'
BUFFER_MODE='default'
BUFFER_HOST='127.0.0.1'
BUFFER_PORT=9092
BUFFER_CLUSTER='{}'

PROJECT_NAME=`cat $WORK_PATH/conf/vhosts/sys.conf | awk '/"project_name"/' | awk -F'\"' '{print $4}'`
if [ "$PROJECT_NAME" != "\$project_name" ]; then
	echo "Project of '${red}$PROJECT_NAME${reset}' was inited, script exit"
	exit 1
else
	PROJECT_NAME='lor-sys'
fi
RAM_REDIS_HPWD=$PROJECT_NAME

# 将项目输出到启动项
# echo_startup_config $supervisorConfigRoot "$PROJECT_NAME" "$WORK_PATH" "bash start.sh master"

echo "------------------------------------------------"
echo "Initial project config of '${red}$PROJECT_NAME${reset}'"
echo "------------------------------------------------"
function set_project_config()
{
	TMP_NAME=$PROJECT_NAME
	input_if_empty "PROJECT_NAME" "Init: Please ender ${red}project name${reset}"
	FMT_PROJECT_NAME=`echo "$PROJECT_NAME" | sed 's@\.@_@g'`
	sed -i "s@\$TMP_NAME@$FMT_PROJECT_NAME@g" conf/vhosts/sys.conf
	sed -i "s@\$project_name@$FMT_PROJECT_NAME@g" conf/vhosts/sys.conf
	sed -i "s@\$project_db_name@$FMT_PROJECT_NAME@g" conf/vhosts/sys.conf
	mv conf/vhosts/sys/$TMP_NAME.conf conf/vhosts/sys/$PROJECT_NAME.conf
	RAM_REDIS_HPWD=$TMP_NAME

	sed -i "s@\$project_name@$FMT_PROJECT_NAME@g" conf/vhosts/sys/$PROJECT_NAME.conf
	
	input_if_empty "LOR_PORT" "Init: Please ender the ${red}lor-port${reset} of Project '${red}$PROJECT_NAME${reset}'"
	sed -i "s@\$lor_port@$LOR_PORT@g" conf/vhosts/sys/$PROJECT_NAME.conf

	input_if_empty "WAF_PORT" "Init: Please ender the ${red}waf-port${reset} of Project '${red}$PROJECT_NAME${reset}'"
	sed -i "s@\$waf_port@$WAF_PORT@g" conf/vhosts/sys/$PROJECT_NAME.conf

	input_if_empty "API_PORT" "Init: Please ender the ${red}api-port${reset} of Project '${red}$PROJECT_NAME${reset}'"
	sed -i "s@\$api_port@$API_PORT@g" conf/vhosts/sys/$PROJECT_NAME.conf

	input_if_empty "BIZ_PORT" "Init: Please ender the ${red}biz-port${reset} of Project '${red}$PROJECT_NAME${reset}'"
	sed -i "s@\$biz_port@$BIZ_PORT@g" conf/vhosts/sys/$PROJECT_NAME.conf

	local LOCAL_FREE_PORT=9000
	rand_val "LOCAL_FREE_PORT" 9000 10000
	sed -i "s@\$plugins_alias_port@$LOCAL_FREE_PORT@g" conf/vhosts/sys.conf
	sed -i "s@\$plugins_alias_port@$LOCAL_FREE_PORT@g" conf/vhosts/sys/plugins/alias.conf

	return $?
}

function set_mysql_config() {
	input_if_empty "DB_HOST" "[$PROJECT_NAME]Mysql: Please ender mysql server ${red}address${reset}"
	input_if_empty "DB_PORT" "[$PROJECT_NAME]Mysql: Please ender mysql server ${red}port${reset} of '${red}$DB_HOST${reset}'"
	input_if_empty "DB_UNAME" "[$PROJECT_NAME]Mysql: Please ender mysql ${red}username${reset} of '${red}$DB_HOST${reset}'"
	input_if_empty "DB_UPWD" "[$PROJECT_NAME]Mysql: Please ender mysql ${red}password${reset} of '${red}$DB_HOST${reset}(${red}$DB_UNAME${reset})'"

	sed -i "s@\$db_host@$DB_HOST@g" $WORK_PATH/conf/vhosts/sys.conf
	sed -i "s@\$db_port@$DB_PORT@g" $WORK_PATH/conf/vhosts/sys.conf
	sed -i "s@\$db_uname@$DB_UNAME@g" $WORK_PATH/conf/vhosts/sys.conf
	sed -i "s@\$db_upwd@$DB_UPWD@g" $WORK_PATH/conf/vhosts/sys.conf	

	sed -i "s@\$project_name@$FMT_PROJECT_NAME@g" $WORK_PATH/install/sys-db-v0.0.1.sql
	sed -i "s@\$project_name@$FMT_PROJECT_NAME@g" $WORK_PATH/install/sys-mysql-log-v0.0.1.sql
	sed -i "s@\$project_name@$FMT_PROJECT_NAME@g" $WORK_PATH/install/sys-mysql-plugin-v0.0.1.sql
	sed -i "s@\$project_name@$FMT_PROJECT_NAME@g" $WORK_PATH/install/sys-mysql-user-v0.0.1.sql
	echo "Data init of '${red}$PROJECT_NAME${reset}' will execute, please wait"
	mysql -u$DB_UNAME -p$DB_UPWD -e"
	source $WORK_PATH/install/sys-mysql-log-v0.0.1.sql
	source $WORK_PATH/install/sys-mysql-plugin-v0.0.1.sql
	source $WORK_PATH/install/sys-mysql-user-v0.0.1.sql
	exit"

	sed -i "s@\$project_name@$FMT_PROJECT_NAME@g" $WORK_PATH/install/sys-clickhouse-log-v0.0.1.sh
	DB_UNAME=default
	DB_PORT=8123
	input_if_empty "DB_HOST" "[$PROJECT_NAME]Clickhouse: Please ender clickhouse server ${red}address${reset}"
	input_if_empty "DB_PORT" "[$PROJECT_NAME]Clickhouse: Please ender clickhouse server ${red}port${reset} of '${red}$DB_HOST${reset}'"
	input_if_empty "DB_UPWD" "[$PROJECT_NAME]Clickhouse: Please ender clickhouse ${red}password${reset} of '${red}$DB_HOST${reset}(${red}$DB_UNAME${reset})'"
	sed -i "s@\$db_host@$DB_HOST@g" $WORK_PATH/install/sys-clickhouse-log-v0.0.1.sh
	sed -i "s@\$db_port@$DB_PORT@g" $WORK_PATH/install/sys-clickhouse-log-v0.0.1.sh
	sed -i "s@\$db_upwd@$DB_UPWD@g" $WORK_PATH/install/sys-clickhouse-log-v0.0.1.sh	

	echo "Data init script of '${red}$PROJECT_NAME${reset}' was inited"

	return $?
}

function append_lua_shared_dict()
{
	sed -i "2alua_shared_dict $1 16m;" conf/vhosts/sys/$PROJECT_NAME.conf
	return $?
}

function set_ram_config_nginx() {
	check_yn_action "RAM_NGINX_SETED"
	exec_while_read "RAM_NGINX_ATTACH" "[$PROJECT_NAME]$CHE_TYPE: Please ender nginx cache ${red}keys${reset}" "\""
	#默认选第一个
	CHE_MODE=`echo $RAM_NGINX_ATTACH | sed 's@\"@@g' | awk -F',' '{print $1}'`

	#输出至配置文件
	exec_repeat_funcs "" "$RAM_NGINX_ATTACH" "append_lua_shared_dict"

	RAM_NGINX_ATTACH=",$RAM_NGINX_ATTACH"
	RAM_NGINX_SETED=true
	return 1
}

function set_ram_config_redis() {
	check_yn_action "RAM_REDIS_SETED"
	setup_if_choice "CHE_MODE" "[$PROJECT_NAME]$CHE_TYPE: Please ender connect ${red}mode${reset}" "default,custom" "" "set_ram_config_redis_"
	#不改变模式值
	CHE_MODE="default"

	RAM_REDIS_SETED=true
	return 1
}

function set_ram_config_redis_default() {
	return 1
}

function set_ram_config_redis_custom() {
	input_if_empty "RAM_REDIS_HOST" "[$PROJECT_NAME]$CHE_TYPE: Please ender server ${red}address${reset}"
	input_if_empty "RAM_REDIS_PORT" "[$PROJECT_NAME]$CHE_TYPE: Please ender server ${red}port${reset} of '$RAM_REDIS_HOST'"

	input_if_empty "RAM_REDIS_HPWD" "[$PROJECT_NAME]$CHE_TYPE: Please ender ${red}password${reset} of $RAM_REDIS_HOST"

	return 1
}

function set_ram_config_kafka() {
	check_yn_action "RAM_KAFKA_SETED"
	setup_if_choice "BUFFER_MODE" "[$PROJECT_NAME]$CHE_TYPE: Please ender buffer ${red}mode${reset}" "default,cluster" "" "set_ram_config_kafka_"

	RAM_KAFKA_SETED=true
	return 1
}

function set_ram_config_kafka_default() {
	return 1
}

function set_ram_config_kafka_cluster() {
	exec_while_read_json "BUFFER_CLUSTER" "[$PROJECT_NAME]$BUFFER_TYPE: Please ender buffer config item\$i of ${red}\$${reset}" "host,port"
	
	return 1
}

#遵循选中了就配置，未选中，全部赋默认值。
#nginx,redis在配置上已进行公用，简单的项目配置，后续可按要求自行添加配置扩展。
function set_cache_config() {
	setup_if_choice "CHE_TYPE" "[$PROJECT_NAME]${red}Cache${reset}: Please ender ${red}type${reset}" "nginx,redis" "" "set_ram_config_"
	sed -i "s@\$che_type@$CHE_TYPE@g" $WORK_PATH/conf/vhosts/sys.conf
	sed -i "s@\$ram_nginx_attach@$RAM_NGINX_ATTACH@g" $WORK_PATH/conf/vhosts/sys.conf
	sed -i "s@\$che_mode@$CHE_MODE@g" $WORK_PATH/conf/vhosts/sys.conf
	sed -i "s@\$ram_redis_host@$RAM_REDIS_HOST@g" $WORK_PATH/conf/vhosts/sys.conf
	sed -i "s@\$ram_redis_port@$RAM_REDIS_PORT@g" $WORK_PATH/conf/vhosts/sys.conf
	sed -i "s@\$ram_redis_hpwd@$RAM_REDIS_HPWD@g" $WORK_PATH/conf/vhosts/sys.conf

	setup_if_choice "BUFFER_TYPE" "[$PROJECT_NAME]${red}Buffer${reset}: Please ender ${red}type${reset}" "nginx,redis,kafka" "" "set_ram_config_"
	sed -i "s@\$buffer_type@$BUFFER_TYPE@g" $WORK_PATH/conf/vhosts/sys.conf
	sed -i "s@\$buffer_mode@$BUFFER_MODE@g" $WORK_PATH/conf/vhosts/sys.conf
	sed -i "s@\$buffer_host@$BUFFER_HOST@g" $WORK_PATH/conf/vhosts/sys.conf
	sed -i "s@\$buffer_port@$BUFFER_PORT@g" $WORK_PATH/conf/vhosts/sys.conf
	sed -i "s@\$buffer_cluster@$BUFFER_CLUSTER@g" $WORK_PATH/conf/vhosts/sys.conf

	return $?
}

cd $WORK_PATH
exec_yn_action "set_project_config,set_mysql_config,set_cache_config" "Please sure your init script path is '${red}$WORK_PATH${reset}'"
sed -i "s@\$project_name@$PROJECT_NAME@g" $WORK_PATH/conf/vhosts/sys.conf

echo "------------------------------------------------"
echo "Project config of '${red}$PROJECT_NAME${reset}' was initialed。"
echo "------------------------------------------------"