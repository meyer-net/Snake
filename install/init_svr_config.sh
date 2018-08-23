#!/bin/sh
#------------------------------------------------
#      Centos7 Or Project Env InitScript
#      copyright https://oshit.thiszw.com/
#      email: meyer_net@foxmail.com
#------------------------------------------------
# http://blog.csdn.net/u010861514/article/details/51028220

echo "------------------------------------------------"
echo "Initial project server config of '${red}$PROJECT_NAME${reset}'"
echo "------------------------------------------------"

RESOLVERS=""
PROCESSOR_COUNT=`cat /proc/cpuinfo | grep "processor"| wc -l`
sed -i "s@\$processor_count@$PROCESSOR_COUNT@g" conf/nginx-master.conf

LIMIT_MAX=`ulimit -n`
LIMIT_NOFILE=$(($LIMIT_MAX/$PROCESSOR_COUNT))
sed -i "s@\$limit_nofile@$LIMIT_NOFILE@g" conf/nginx-master.conf

#最大支持8核数
if [ $PROCESSOR_COUNT -gt 8 ]; then
    PROCESSOR_COUNT=8
fi
for i in $(seq $PROCESSOR_COUNT);
do
    if [ $i -ne 8 ]; then
        TMP_ZERO_STR_LEFT=`eval printf %.s'0' {1..$((8-$i))}`
    fi
    if [ $i -ne 1 ]; then
        TMP_ZERO_STR_RIGTH=`eval printf %.s'0' {1..$(($i-1))}`
    fi

    CPU_AFFINITY="$CPU_AFFINITY$TMP_ZERO_STR_LEFT"1"$TMP_ZERO_STR_RIGTH "
    TMP_ZERO_STR_LEFT=""
    TMP_ZERO_STR_RIGTH=""
done
sed -i "s@\$cpu_affinity@$CPU_AFFINITY@g" conf/nginx-master.conf

function set_resolver_type_default()
{
    RESOLVERS="223.5.5.5 223.6.6.6"
    return $?
}
function set_resolver_type_alibaba()
{
    RESOLVERS="100.100.2.136 100.100.2.138"
    return $?
}
function set_resolver_type_tencent()
{
    RESOLVERS="10.225.30.181 10.225.30.223"
    return $?
}

set_if_choice "TMP_SET_RESOLVER_TYPE" "[$PROJECT_NAME]DNS: Please ender ${red}resolver address type${reset}" "default,alibaba,tencent" "" "set_resolver_type_"
sed -i "s@\$resolvers@$RESOLVERS@g" conf/nginx-master.conf

#添加开机启动
ATT_DIR=/clouddisk/attach
SUPERVISOR_CONFIG_ROOT=$ATT_DIR/supervisor
START_SCRIPT="sh start.sh master"
echo_startup_config "$PROJECT_NAME" "$WORK_PATH" "$START_SCRIPT"
echo "------------------------------------------------"
echo "Project server config of '${red}$PROJECT_NAME${reset}' was initialed。"
echo "------------------------------------------------"

$START_SCRIPT