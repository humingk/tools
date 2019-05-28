#!/bin/bash
set -e

wgets_url="$1"
wgets_name="`echo $wgets_url|awk -F '/' '{print $NF}'`"
wgets_config="/home/${USER}/.wgetsrc"

if [ ! -f "$wgets_config" ]
then
	echo "欢迎使用 wgets ~"
	echo "-------------------------------------------------------------------------------------------------"
	read -p "请输入服务器地址或域名:" wgets_server
	if [ -z "$wgets_server" ]
	then
		echo "error 服务器地址不能为空！"
		exit 0
	fi
	read -p "请输入服务器用户名(回车默认root):" wgets_user
	if [ -z "$wgets_user" ]
	then
		wgets_user="root"
	fi
	read -p "请输入服务器SSH端口(回车默认22):" wgets_port
	if [ -z "$wgets_port" ]
	then
		wgets_port=22
	fi
	echo "wgets_server=${wgets_server}" > "$wgets_config"
	echo "wgets_user=${wgets_user}" >> "$wgets_config"
	echo "wgets_port=${wgets_port}" >> "$wgets_config"
else
	if [ "$wget_url" == '' ]
	then
		echo "使用方式: wgets {{下载链接}}"
		exit 0
	else

		source $wgets_config
		echo ""
		echo "文件名称: $wgets_name"
		echo "-------------------------------------------------------------------------------------------------"
		echo "正在下载到代理服务器..."
		ssh -p ${wgets_port} ${wgets_user}@${wgets_server} "wget -nv -O ${wgets_name} ${wgets_url} && exit"
		echo "已成功下载到代理服务器..."
		echo "正在下载到本地..."
		scp -P ${wgets_port} ${wgets_user}@${wgets_server}:/home/${wgets_user}/${wgets_name} .
		if [ $? -eq 0 ]
		then
			echo "已成功下载到本地..."
		else
			echo "本地下载失败..."
		fi
		echo "正在删除临时文件..."
		ssh -p ${wgets_port} ${wgets_user}@${wgets_server} "rm ${wgets_name} && exit"
		echo "已成功删除临时文件..."
		echo "下载已完成..."
	fi
fi
exit 0
