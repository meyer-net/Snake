#!/bin/sh
#------------------------------------------------
#      Centos7 Or Project Env InitScript
#      copyright https://oshit.thiszw.com/
#      email: meyer_net@foxmail.com
#------------------------------------------------
# http://blog.csdn.net/u010861514/article/details/51028220

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

# ret, err, code = run_cmd(check_java_cmd)
# def run_cmd(cmd):
#     result_str = ""
#     errors = ""
#     process = sub.Popen(cmd, stdout=sub.PIPE, shell=True)
#     # result_str, err = process.communicate()
#     p_result = process.stdout
#     p_error = process.stderr
    
#     code = process.returncode
#     process.wait()
#     if p_error:
#         errors = p_error.read().strip()
#         p_error.close()
#         if errors:
#             return "", errors, code

#     if p_result:
#         result_str = p_result.read().strip()
#         p_result.close()

#     return result_str, errors, code

#随机数
#参数1：需要设置的变量名
#参数2：最小值
#参数3：最大值
#调用：$(rand_val 1000 2000)
function rand_val(){
	if [ $? -ne 0 ]; then
		return $?
	fi
	local TMP_VAR_NAME=$1

    local MIN_PORT=$2 
    local MAX_PORT=$(($3-$MIN_PORT+1))  
    local CURR_NUM=$(cat /proc/sys/kernel/random/uuid | cksum | awk -F ' ' '{print $1}')

    eval ${1}=$(($CURR_NUM%$MAX_PORT+$MIN_PORT))

	return $?
}

#安装软件基础
#参数1：软件安装名称
#参数2：软件安装需调用的函数
function setup_soft_basic()
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	local TMP_SOFT_SETUP_NAME=$1
	local TMP_SOFT_SETUP_FUNC=$2

	local TMP_SOFT_SETUP_NAME_LEN=${#TMP_SOFT_SETUP_NAME}
	local TMP_VAR_SPLITER=""
	#TMP_SOFT_

	fill_right "TMP_VAR_SPLITER" "-" $((TMP_SOFT_SETUP_NAME_LEN+20))
	echo $TMP_VAR_SPLITER
	echo "Start To Install ${green}$TMP_SOFT_SETUP_NAME${reset}"
	echo $TMP_VAR_SPLITER
	
	if [ -n "$TMP_SOFT_SETUP_FUNC" ]; then
		cd $DOWN_DIR
		$TMP_SOFT_SETUP_FUNC
	fi

	echo $TMP_VAR_SPLITER
	echo "Install ${green}$TMP_SOFT_SETUP_NAME${reset} Completed"
	echo $TMP_VAR_SPLITER

	cd $WORK_PATH

	return $?
}

#路径不存在执行
#参数1：检测路径
#参数2：执行函数名称
#参数3：路径存在时输出信息
function path_not_exits_action() 
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	TMP_NOT_EXITS_PATH=$1
	TMP_NOT_EXITS_PATH_FUNC=$2
    ls -d $TMP_NOT_EXITS_PATH   #ps -fe | grep $TMP_SOFT_WGET_NAME | grep -v grep
	if [ $? -ne 0 ]; then
		$TMP_NOT_EXITS_PATH_FUNC
	else
		echo $3
	fi

	return $?
}

#安装软件下载模式
#参数1：软件下载地址
#参数2：软件下载后，需移动的文件夹名
#参数3：目标文件夹
#参数4：解包后执行脚本
function wget_unpack_dist() 
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	TMP_WGET_UNPACK_DIST_PWD=`pwd`
	TMP_WGET_UNPACK_DIST_URL=$1
	TMP_WGET_UNPACK_DIST_SOURCE=$2
	TMP_WGET_UNPACK_DIST_PATH=$3
	TMP_WGET_UNPACK_DIST_SCRIPT=$4

	TMP_WGET_UNPACK_FILE_NAME=`echo "$TMP_WGET_UNPACK_DIST_URL" | awk -F'/' '{print $NF}'`

	cd $DOWN_DIR

	if [ ! -f "$TMP_WGET_UNPACK_FILE_NAME" ]; then
		wget $TMP_WGET_UNPACK_DIST_URL
	fi

	TMP_WGET_UNPACK_DIST_FILE_EXT=`echo ${TMP_WGET_UNPACK_FILE_NAME##*.}`
	if [ "$TMP_WGET_UNPACK_DIST_FILE_EXT" = "zip" ]; then
		TMP_WGET_PACK_DIR_LINE=`unzip -v $TMP_WGET_UNPACK_FILE_NAME | awk '/----/{print NR}' | awk 'NR==1{print}'`
		TMP_WGET_UNPACK_FILE_NAME_NO_EXTS=`unzip -v $TMP_WGET_UNPACK_FILE_NAME | awk 'NR==LINE{print $NF}' LINE=$((TMP_WGET_PACK_DIR_LINE+1)) | sed s@/@""@g`
		if [ ! -d "$TMP_WGET_UNPACK_FILE_NAME_NO_EXTS" ]; then
			unzip -o $TMP_WGET_UNPACK_FILE_NAME
		fi
	else
		TMP_WGET_UNPACK_FILE_NAME_NO_EXTS=`tar -tf $TMP_WGET_UNPACK_FILE_NAME | awk 'NR==1{print}' | sed s@/@""@g`
		if [ ! -d "$TMP_WGET_UNPACK_FILE_NAME_NO_EXTS" ]; then
			tar -xvf $TMP_WGET_UNPACK_FILE_NAME
		fi
	fi

	cd $TMP_WGET_UNPACK_FILE_NAME_NO_EXTS

	exec_check_action "$TMP_WGET_UNPACK_DIST_SCRIPT"

	cp -rf $TMP_WGET_UNPACK_DIST_SOURCE $TMP_WGET_UNPACK_DIST_PATH

	#rm -rf $DOWN_DIR/$TMP_WGET_UNPACK_FILE_NAME
	cd $TMP_WGET_UNPACK_DIST_PWD

	return $?
}

#无限循环重试下载
#参数1：软件下载地址
#参数2：软件下载后执行函数名称
function while_wget()
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	local TMP_SOFT_WGET_URL=$1
	local TMP_SOFT_WGET_SCRIPT=$2
	
	TMP_SOFT_WGET_FILE_NAME=`echo "$TMP_SOFT_WGET_URL" | awk -F'/' '{print $NF}'`
	if [ "$TMP_SOFT_WGET_FILE_NAME" == "download.rpm" ]; then
		TMP_SOFT_WGET_FILE_NAME=`echo "$TMP_SOFT_WGET_URL" | awk -F'/' '{print $(NF-1)}'`
	fi

	while [ ! -f "$TMP_SOFT_WGET_FILE_NAME" ]; do
		wget -t1 -T30 $TMP_SOFT_WGET_URL
	done

	if [ -n "$TMP_SOFT_WGET_SCRIPT" ]; then
		eval "$TMP_SOFT_WGET_SCRIPT"
	fi

	return $?
}

#安装软件下载模式
#参数1：软件安装名称
#参数2：软件下载地址
#参数3：软件下载后执行函数名称
function setup_soft_wget() 
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	TMP_SOFT_WGET_NAME=$1
	TMP_SOFT_WGET_URL=$2
	TMP_SOFT_WGET_SETUP_FUNC=$3
	
	typeset -l TMP_SOFT_LOWER_NAME
	TMP_SOFT_LOWER_NAME=$TMP_SOFT_WGET_NAME

	TMP_SOFT_SETUP_PATH=$SETUP_DIR/$TMP_SOFT_LOWER_NAME

    ls -d $TMP_SOFT_SETUP_PATH   #ps -fe | grep $TMP_SOFT_WGET_NAME | grep -v grep
	if [ $? -ne 0 ]; then
		TMP_SOFT_WGET_FILE_NAME=`echo "$TMP_SOFT_WGET_URL" | awk -F'/' '{print $NF}'`

		cd $DOWN_DIR
		if [ ! -f "$TMP_SOFT_WGET_FILE_NAME" ]; then
			wget $TMP_SOFT_WGET_URL
		fi

		TMP_SOFT_WGET_UNPACK_FILE_EXT=`echo ${TMP_SOFT_WGET_FILE_NAME##*.}`
		if [ "$TMP_SOFT_WGET_UNPACK_FILE_EXT" = "zip" ]; then
			TMP_SOFT_WGET_PACK_DIR_LINE=`unzip -v $TMP_SOFT_WGET_FILE_NAME | awk '/----/{print NR}' | awk 'NR==1{print}'`
			TMP_SOFT_WGET_FILE_NAME_NO_EXTS=`unzip -v $TMP_SOFT_WGET_FILE_NAME | awk 'NR==LINE{print $NF}' LINE=$((TMP_SOFT_WGET_PACK_DIR_LINE+1)) | sed s@/.*@""@g`
			if [ ! -d "$TMP_SOFT_WGET_FILE_NAME_NO_EXTS" ]; then
				unzip -o $TMP_SOFT_WGET_FILE_NAME
			fi
		else
			TMP_SOFT_WGET_FILE_NAME_NO_EXTS=`tar -tf $TMP_SOFT_WGET_FILE_NAME | awk 'NR==1{print}' | sed s@/.*@""@g`
			if [ ! -d "$TMP_SOFT_WGET_FILE_NAME_NO_EXTS" ]; then
				tar -xvf $TMP_SOFT_WGET_FILE_NAME
			fi
		fi
		
		cd $TMP_SOFT_WGET_FILE_NAME_NO_EXTS

		#安装函数调用
		$TMP_SOFT_WGET_SETUP_FUNC "$TMP_SOFT_SETUP_PATH"
	fi

	return $?
}

#安装软件下载模式
#参数1：软件安装名称
#参数2：软件下载地址
#参数3：软件下载后执行函数名称
function setup_soft_git() 
{	
	if [ $? -ne 0 ]; then
		return $?
	fi

	local TMP_SOFT_GIT_NAME=$1
	local TMP_SOFT_GIT_URL=$2
	local TMP_SOFT_GIT_SETUP_FUNC=$3
	
	typeset -l TMP_SOFT_LOWER_NAME
	local TMP_SOFT_LOWER_NAME=$TMP_SOFT_GIT_NAME

	local TMP_SOFT_SETUP_PATH=$SETUP_DIR/$TMP_SOFT_LOWER_NAME

    ls -d $TMP_SOFT_SETUP_PATH   #ps -fe | grep $TMP_SOFT_GIT_NAME | grep -v grep
	if [ $? -ne 0 ]; then
		local TMP_SOFT_GIT_FOLDER_NAME=`echo "$TMP_SOFT_GIT_URL" | awk -F'/' '{print $NF}'`

		cd $DOWN_DIR
		if [ ! -f "$TMP_SOFT_GIT_FOLDER_NAME" ]; then
			git clone $TMP_SOFT_GIT_URL
		fi
		
		cd $TMP_SOFT_GIT_FOLDER_NAME

		#安装函数调用
		$TMP_SOFT_GIT_SETUP_FUNC "$TMP_SOFT_SETUP_PATH"
	fi

	return $?
}

#安装软件下载模式
#参数1：软件安装名称
#参数2：软件下载后执行函数名称
#参数3：软件配置函数
function setup_soft_pip() 
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	TMP_SOFT_PIP_NAME=$1
	TMP_SOFT_PIP_SETUP_FUNC=$2
	TMP_SOFT_PIP_SET_FUNC=$3

	TMP_SOFT_SETUP_PATH=/usr/lib/python2.7/site-packages/$TMP_SOFT_PIP_NAME* #$SETUP_DIR/python/lib/python2.7/site-packages/$TMP_SOFT_PIP_NAME*

    ls -d $TMP_SOFT_SETUP_PATH   #ps -fe | grep $TMP_SOFT_PIP_NAME | grep -v grep
	if [ $? -ne 0 ]; then
		if [ -n "$TMP_SOFT_PIP_SET_FUNC" ]; then
			$TMP_SOFT_PIP_SET_FUNC
		fi

		easy_install pip

		echo "Pip start to install $TMP_SOFT_PIP_NAME"
		pip install $TMP_SOFT_PIP_NAME
		echo "Pip installed $TMP_SOFT_PIP_NAME"

		#安装后配置函数
		$TMP_SOFT_PIP_SETUP_FUNC
	fi

	return $?
}

# #循环执行
# #参数1：提示标题
# #参数2：函数名称
# function cycle_exec()
# {
# 	if [ $? -ne 0 ]; then
# 		return $?
# 	fi

# 	return $?
# }

#设置变量值函数如果为空
#参数1：需要设置的变量名
#参数2：需要设置的变量值
function set_if_empty()
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	TMP_VAR_NAME=$1
	TMP_VAR_VAL=$2

	TMP_DFT=`eval echo '$'$TMP_VAR_NAME`

	if [ -n "$TMP_VAR_VAL" ]; then
		eval ${1}=`echo '$TMP_DFT'`
	fi

	return $?
}

#是否类型的弹出动态设置变量值函数
#参数1：需要设置的变量名
#参数2：提示信息
function input_if_empty()
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	local TMP_VAR_NAME=$1
	local TMP_NOTICE=$2
	local INPUT_CURRENT=""

	TMP_DFT=`eval echo '$'$TMP_VAR_NAME`
	echo "$TMP_NOTICE, default '${red}$TMP_DFT${reset}'"
	read -e INPUT_CURRENT
	echo ""

	if [ -n "$INPUT_CURRENT" ]; then
		eval ${1}='$INPUT_CURRENT'
	fi

	return $?
}

#填充右处
#参数1：需要设置的变量名
#参数2：填充字符
#参数3：总长度
function fill_right()
{
	TMP_VAR_NAME=$1
	TMP_VAR_VAL=`eval echo '$'$TMP_VAR_NAME`
	TMP_FILL_CHR=$2
	TMP_TOTAL_LEN=$3

	TMP_ITEM_LEN=${#TMP_VAR_VAL}
	TMP_OUTPUT_SPACE_COUNT=$((TMP_TOTAL_LEN-TMP_ITEM_LEN))	
	TMP_SPACE_STR=`eval printf %.s'$TMP_FILL_CHR' {1..$TMP_OUTPUT_SPACE_COUNT}`
	
	eval $TMP_VAR_NAME='$'TMP_VAR_VAL'$'TMP_SPACE_STR
	
	# eval $TMP_VAR_NAME='$'TMP_VAR_VAL'$'TMP_SPACE_STR
	return $?
}

#填充并输出
#参数1：需要填充的实际值
#参数2：填充字符
#参数3：总长度
#参数4：格式化字符
function echo_fill_right()
{
	TMP_VAR_FILL_RIGHT=$1
	fill_right "TMP_VAR_FILL_RIGHT" $2 $3

	if [ -n "$4" ]; then
		echo "$4" | sed s@%@"$TMP_VAR_FILL_RIGHT"@g
		return $?
	fi

	echo $TMP_VAR_FILL_RIGHT
	return $?
}

#按键选择类型的弹出动态设置变量值函数
#参数1：需要设置的变量名
#参数2：提示信息
#参数3：选项参数
#参数4：自定义的Spliter
function set_if_choice()
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	TMP_VAR_NAME=$1
	TMP_NOTICE=$2
	TMP_CHOICE=$3

	#参数4：函数调用
	#TMP_PREFIX=$4 
	
	TMP_CHOICE_SPLITER="-------------------------------------------------"
	set_if_empty "TMP_CHOICE_SPLITER" "$4"
	TMP_CHOICE_SPLITER_LEN=${#TMP_CHOICE_SPLITER}
	
	echo $TMP_CHOICE_SPLITER
	arr=(${TMP_CHOICE//,/ })
	for I in ${!arr[@]};  
	do
		# TMP_ITEM_LEN=${#arr[$I]}
		# TMP_OUTPUT_SPACE_COUNT=$((TMP_CHOICE_SPLITER_LEN-TMP_ITEM_LEN-10))	
		# TMP_SPACE_STR=`eval printf %.s'' {1..$TMP_OUTPUT_SPACE_COUNT}`

		TMP_COLOR="${red}"
		if [ $(($I%2)) -eq 0 ]; then
			TMP_COLOR="${green}"
		fi

		# echo "|     $((I+1)). ${TMP_COLOR}${arr[$I]}${reset}$TMP_SPACE_STR|"
		TMP_SIGN=$((I+1))
		TMP_SPACE=""
		if [ $TMP_SIGN -ge 10 ]; then
			TMP_SPACE=""
		fi

		TMP_SET_IF_CHOICE_ITEM=${arr[$I]}
		if [ `echo "$TMP_SET_IF_CHOICE_ITEM" | tr 'A-Z' 'a-z'` = "exit" ]; then
			echo $TMP_CHOICE_SPLITER
			TMP_SIGN="x"
		fi

		echo_fill_right "$TMP_SET_IF_CHOICE_ITEM" "" $((TMP_CHOICE_SPLITER_LEN-13)) "|     [$TMP_SIGN].$TMP_SPACE${TMP_COLOR}%${reset}|"
	done
	echo $TMP_CHOICE_SPLITER
	if [ -n "$TMP_NOTICE" ]; then
		echo "$TMP_NOTICE, by above keys"
	fi
	read -n 1 KEY
	echo
	
	typeset -l NEW_VAL
	NEW_VAL=${arr[$((KEY-1))]}
	eval ${1}='$NEW_VAL'
	echo "Choice of '$NEW_VAL' checked"

	# if [ -n "$TMP_PREFIX" ]; then
	# 	if [ "$NEW_VAL" = "exit" ]; then
	# 		exit 1
	# 	fi
	# 	$TMP_PREFIX$NEW_VAL
	# fi

	return $?
}

#按键选择类型的弹出动态设置变量值函数
#参数1：需要设置的变量名
#参数2：提示信息
#参数3：选项参数
#参数4：自定义的Spliter
#参数5：脚本路径/前缀
function setup_if_choice()
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	set_if_choice "$1" "$2" "$3" "$4"

	NEW_VAL=`eval echo '$'$1`
	if [ -n "$NEW_VAL" ]; then
		if [ "$NEW_VAL" = "exit" ]; then
			exit 1
		fi

		if [ "$NEW_VAL" = "..." ]; then
			return $?
		fi

		if [ -n "$5" ]; then
			TMP_SETUP_IF_CHOICE_SCRIPT_FILE=$5/$NEW_VAL.sh
			if [ ! -f "$TMP_SETUP_IF_CHOICE_SCRIPT_FILE" ];then
				exec_check_action "$5$NEW_VAL"
			else
				source $TMP_SETUP_IF_CHOICE_SCRIPT_FILE
			fi
		else
			exec_check_action "$NEW_VAL"
		fi
		
		RETURN=$?
		#返回非0，跳出循环，指导后续请求不再进行
		if [ $RETURN != 0 ]; then
			return $RETURN
		fi

		if [ "$NEW_VAL" != "..." ]; then
			read -n 1 -p "Press <Enter> go on..."
		fi

		setup_if_choice "$1" "$2" "$3" "$4" "$5"
	fi


	return $?
}

#检测并执行指令
#要执行的函数/脚本名称
function exec_check_action() {
	if [ "$(type -t $1)" = "function" ] ; then
		$1
	else
		eval "$1"
	fi

	return $?
}

#执行需要判断的Y/N逻辑函数
#参数1：并行逻辑执行参数/脚本
#参数2：提示信息
function exec_yn_action()
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	TMP_FUNCS_ON_Y=$1
	TMP_NOTICE=$2
	echo "$TMP_NOTICE, by follow key ('${red}yes(y) or enter key/no(n) or else${reset}')?"
	read -n 1 Y_N
	echo ""

	case $Y_N in
		"y" | "Y" | "")
		;;
		*)
		return 1
	esac

	arr=(${TMP_FUNCS_ON_Y//,/ })
	#echo ${#arr[@]} 
	for TMP_FUNC_ON_Y in ${arr[@]};  
	do
		exec_check_action "$TMP_FUNC_ON_Y"
		RETURN=$?
		#返回非0，跳出循环，指导后续请求不再进行
		if [ $RETURN != 0 ]; then
			return $RETURN
		fi
	done

	return $?
}

#检测是否值
function check_yn_action() {
	TMP_VAR_NAME=$1
	YN_VAL=`eval expr '$'$TMP_VAR_NAME`
	
	if [ "$YN_VAL" = false ] || [ "$YN_VAL" = 0 ]; then
		return $?
	fi

	return 1
}


#按数组循环执行函数
#参数1：需要针对存放的变量名
#参数2：循环数组
#参数3：循环执行脚本函数
function exec_repeat_funcs()
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	TMP_VAR_NAME=$1
	TMP_ARRAY_STR=$2
	TMP_FORMAT_FUNC=$3
	
	arr=(${TMP_ARRAY_STR//,/ })
	for I in ${!arr[@]};  
	do
		TMP_OUTPUT=`$TMP_FORMAT_FUNC "${arr[$I]}"`

		if [ $I -gt 0 ]; then
			eval ${1}=`eval expr '$'$TMP_VAR_NAME,$TMP_OUTPUT`
		else
			eval ${1}='$TMP_OUTPUT'
		fi
	done

	return $?
}

#执行文本格式化
#参数1：需要格式化的变量名
#参数2：格式化字符串规格
function exec_text_format()
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	TMP_EXEC_TEXT_FORMAT_VAR_NAME=$1
	TMP_EXEC_TEXT_FORMAT_VAR_VAL=`eval echo '$'$TMP_EXEC_TEXT_FORMAT_VAR_NAME`
	TMP_EXEC_TEXT_FORMAT_VAR_FORMAT=$2

	if [ -n "$TMP_EXEC_TEXT_FORMAT_VAR_FORMAT" ]; then
		eval ${1}=`echo "$TMP_EXEC_TEXT_FORMAT_VAR_FORMAT" | sed s@%@"$TMP_EXEC_TEXT_FORMAT_VAR_VAL"@g`
	fi

	return $?
}

#循环读取值
#参数1：需要设置的变量名
#参数2：提示信息
#参数3：格式化字符串
#参数4：需执行的脚本
function exec_while_read() 
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	TMP_EXEC_WHILE_READ_VAR_NAME=$1
	TMP_EXEC_WHILE_READ_NOTICE=$2
	TMP_EXEC_WHILE_READ_FORMAT=$3
	TMP_EXEC_WHILE_READ_SCRIPTS=$4
	TMP_EXEC_WHILE_READ_DFT=`eval echo '$'$TMP_EXEC_WHILE_READ_VAR_NAME`

	I=1
	for I in $(seq 99);
	do
		TMP_EXEC_WHILE_READ_CURRENT_NOTICE=`eval echo "$TMP_EXEC_WHILE_READ_NOTICE"`
		echo "$TMP_EXEC_WHILE_READ_CURRENT_NOTICE Or '${red}enter key${reset}' To Quit"
		read -e CURRENT

		echo "Item of '${red}$CURRENT${reset}' inputed"
		
		if [ ! -n "$CURRENT" ]; then
			if [ $I -eq 1 ] && [ -n "$TMP_EXEC_WHILE_READ_DFT" ]; then
				echo "No input, set value to default '$TMP_EXEC_WHILE_READ_DFT'"
				CURRENT="$TMP_EXEC_WHILE_READ_DFT"
			else
				TMP_EXEC_WHILE_READ_BREAK_ACTION=true
			fi
		fi

		TMP_EXEC_WHILE_READ_FORMAT_CURRENT="$CURRENT"
		exec_text_format "TMP_EXEC_WHILE_READ_FORMAT_CURRENT" "$TMP_EXEC_WHILE_READ_FORMAT"

		if [ -n "$CURRENT" ]; then
			if [ $I -gt 1 ]; then
				eval ${TMP_EXEC_WHILE_READ_VAR_NAME}=`eval echo '$'$TMP_EXEC_WHILE_READ_VAR_NAME,$TMP_EXEC_WHILE_READ_FORMAT_CURRENT`
			else
				eval ${TMP_EXEC_WHILE_READ_VAR_NAME}="$TMP_EXEC_WHILE_READ_FORMAT_CURRENT"
			fi
			
			exec_check_action "$TMP_EXEC_WHILE_READ_SCRIPTS"
			echo
		fi

		if [ $TMP_EXEC_WHILE_READ_BREAK_ACTION ]; then
			break
		fi
	done

	# TMP_FORMAT_VAL="$TMP_WRAP_CHAR$CURRENT$TMP_WRAP_CHAR"
	NEW_VAL=`eval echo '$'$TMP_EXEC_WHILE_READ_VAR_NAME`
	NEW_VAL=`echo "$NEW_VAL" | sed "s/^[,]\{1,\}//g;s/[,]\{1,\}$//g"`
	eval ${1}='$NEW_VAL'
	
	if [ -z "$NEW_VAL" ]; then
		echo "${red}Items not set, script exit${reset}"
		exit 1
	fi

	# eval ${1}=`echo "${1}" | sed "s/^[,]\{1,\}//g;s/[,]\{1,\}$//g"`
	echo "Final value is '$NEW_VAL'"
}

#循环读取JSON值
#参数1：需要设置的变量名
#参数2：提示信息
#参数3：选项参数
function exec_while_read_json() 
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	TMP_VAR_NAME=$1
	TMP_NOTICE=$2
	TMP_ITEMS=$3

	arr=(${TMP_ITEMS//,/ })
	TMP_ITEM_LEN=${#arr[@]}
	for i in $(seq 99);
	do
		echo "Please Sure You Will Input Items By '${red}yes(y) or enter key/no(n)${reset}'"
		read -n 1 Y_N
		echo ""

		case $Y_N in
			"y" | "Y" | "")
			;;
			*)
			break
		esac

		TMP_ITEM="$TMP_ITEM{ "
		for I in ${!arr[@]};
		do
			TMP_KEY=${arr[$I]}
			echo $TMP_NOTICE | sed 's@\$i@'$i'@g' | sed 's@\$@'\'$TMP_KEY\''@g'
			read -e CURRENT

			TMP_ITEM="$TMP_ITEM\"$TMP_KEY\": \"$CURRENT\""
			if [ $((I+1)) -ne $TMP_ITEM_LEN ]; then
				TMP_ITEM="$TMP_ITEM, "
			fi
		done
		TMP_ITEM="$TMP_ITEM }"

		eval ${1}='$TMP_ITEM'
		echo "Item of '${red}$TMP_ITEM${reset}' inputed"
	done

	NEW_VAL=`echo "$TMP_ITEM" | sed 's@}{@}, {@g'`
	eval ${1}='$NEW_VAL'
	
	if [ -z "$NEW_VAL" ]; then
		echo "${red}Items not set, script exit${reset}"
		exit 1
	fi

	# eval ${1}=`echo "${1}" | sed "s/^[,]\{1,\}//g;s/[,]\{1,\}$//g"`
	echo "Final value is '$NEW_VAL'"
}

#生成启动配置文件
#参数1：程序命名
#参数2：程序启动的目录
#参数3：程序启动的命令
#参数4：程序启动的环境
#参数5：优先级序号
function echo_startup_config()
{
	if [ $? -ne 0 ]; then
		return $?
	fi
	
	set_if_empty "SUPERVISOR_CONF_ROOT" "$ATT_DIR/supervisor"

	local STARTUP_NAME="$1"
	local STARTUP_FILENAME="$STARTUP_NAME.conf"
	local STARTUP_DIR="$2"
	local STARTUP_COMMAND="$3"
	local STARTUP_ENV="$4"
	local STARTUP_PRIORITY="$5"

	SUPERVISOR_LOGS_DIR="$SUPERVISOR_CONF_ROOT/logs"
	SUPERVISOR_SCRIPTS_DIR="$SUPERVISOR_CONF_ROOT/scripts"
	SUPERVISOR_FILE_DIR="$SUPERVISOR_CONF_ROOT/conf"

	mkdir -pv $SUPERVISOR_LOGS_DIR
	mkdir -pv $SUPERVISOR_SCRIPTS_DIR
	mkdir -pv $SUPERVISOR_FILE_DIR

	SUPERVISOR_FILE_OUTPUT_PATH=${SUPERVISOR_FILE_DIR}${STARTUP_FILENAME}
	mkdir -pv $SUPERVISOR_FILE_DIR

	if [ "$STARTUP_DIR" != "" ]; then
		STARTUP_DIR="directory = $STARTUP_DIR ; 程序的启动目录"
	fi

	if [ "$STARTUP_ENV" != "" ]; then
		local EQUAL_CHECK="$(echo $STARTUP_ENV | grep '=')"
		local ENV_STRING="$EQUAL_CHECK"
		if [ -n "$EQUAL_CHECK" ]; then
			ENV_STRING="PATH=\"$STARTUP_ENV:%(ENV_PATH)s\""
		fi

		STARTUP_ENV="environment = $ENV_STRING ; 程序启动的环境变量信息"
	fi

	if [ "$STARTUP_PRIORITY" != "" ]; then
		STARTUP_PRIORITY="priority = $STARTUP_PRIORITY ; 启动优先级，默认999"
	fi
	
	cat >$SUPERVISOR_FILE_OUTPUT_PATH<<EOF
[program:$STARTUP_NAME]
command = $STARTUP_COMMAND  ; 启动命令，可以看出与手动在命令行启动的命令是一样的
autostart = true     ; 在 supervisord 启动的时候也自动启动
startsecs = 60       ; 启动 60 秒后没有异常退出，就当作已经正常启动了
autorestart = false   ; 程序异常退出后自动重启
startretries = 0     ; 启动失败自动重试次数，默认是 3
user = root          ; 用哪个用户启动
redirect_stderr = true  ; 把 stderr 重定向到 stdout，默认 false
stdout_logfile_maxbytes = 20MB  ; stdout 日志文件大小，默认 50MB
stdout_logfile_backups = 20     ; stdout 日志文件备份数
$STARTUP_PRIORITY
$STARTUP_DIR
$STARTUP_ENV

stdout_logfile = ${SUPERVISOR_LOGS_DIR}/${STARTUP_NAME}_stdout.log  ; stdout 日志文件，需要注意当指定目录不存在时无法正常启动，所以需要手动创建目录（supervisord 会自动创建日志文件）
numprocs=1           ;
EOF

	return $?
}

#新增一个授权端口
#参数1：需放开端口
#参数2：授权IP
function echo_soft_port()
{
	if [ $? -ne 0 ]; then
		return $?
	fi

	TMP_ECHO_SOFT_PORT=$1
	TMP_ECHO_SOFT_PORT_IP=$2

	if [ -n "$TMP_ECHO_SOFT_PORT_IP" ]; then
		TMP_ECHO_SOFT_PORT_IP="-s $TMP_ECHO_SOFT_PORT_IP "
	fi

	sed -i "11a-A INPUT $TMP_ECHO_SOFT_PORT_IP-p tcp -m state --state NEW -m tcp --dport $TMP_ECHO_SOFT_PORT -j ACCEPT" /etc/sysconfig/iptables

	service iptables restart

	sleep 2

	return $?
}