#!/bin/bash
#------------------------------------------------
#      Centos7 Project Env InstallScript
#      copyright https://echat.oshit.com/
#      email: meyer_net@foxmail.com
#------------------------------------------------
# 纯拿来作为测试的脚本

WORK_PATH=`pwd`
source ./common.sh

TEST=
# exec_while_read "TEST" "Please ender ${red}test-values${reset}" "\""
# #默认选第一个
# OUTPUT=`echo $TEST | sed 's@\"@@g' | awk -F',' '{print $1}'`
# echo $OUTPUT

function item_format() 
{
    echo $1
}
exec_repeat_funcs "TEST" "a,b,c" "item_format"