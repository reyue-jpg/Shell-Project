#!/bin/bash

# 监控磁盘使用情况

# 指定要监控的目录
dir1="/dev/vda1"
dir2="/dev/vdb2"

# 循环查看每个目录的磁盘使用情况
#for dir in $dir1 $dir2; do
#    echo -e "\n监控目录：$dir"
#    df -h $dir
#done

dir1_output=$(df -h | grep $dir1 | awk '{ print $4 " " $5 " " $1 " " $2 }')
echo $dir1_output

dir2_output=$(df -h | grep "$dir2" | awk '{ print $4 " " $5 " " $1 " " $2 }')
echo $dir2_output

# dir1 变量保存
dir1_usep=$(echo $dir1_output | awk '{ print $2}' | cut -d'%' -f1)
echo $dir1_usep
  
# 通过 awk 获取剩余可用空间
dir1_availablep=$(echo $dir1_output | awk '{ print $1 }')

# 获取磁盘总容量
dir1_disk_size1=$(echo $dir1_output | awk '{ print $4 }')

# 获取文件路径
dir1_partition=$(echo $dir1_output | awk '{ print $3 }')

# 判断剩余内存大小以及可用空间是否低于指定值
if [ $dir1_usep -ge 90 ] || [ `echo "${dir1_availablep%?} <= 5" | bc` -eq 1 ]; then
  dir1_percent_residue="<font color=#EE0000>$dir1_usep%</font>"    # 红色
  dir1_available_space="<font color=#EE0000>$dir1_availablep</font>"
  dir1_disk_size2="<font color=#EE0000>/$dir1_disk_size1</font>"
  dir1_anchor=1
else
  dir1_percent_residue="<font color=#00ee00>$dir1_usep%</font>"    # 绿色
  dir1_available_space="<font color=#00ee00>$dir1_availablep</font>"
  dir1_disk_size2="<font color=#00ee00>/$dir1_disk_size1</font>"
  dir1_anchor=0
fi

# =========================================================================

# dir2 变量保存 
dir2_usep=$( echo $dir2_output | awk '{ print $2}' | cut -d'%' -f1 )
echo $dir2_usep  

# 通过 awk 获取剩余可用空间
dir2_availablep=$(echo $dir2_output | awk '{ print $1 }' )

# 获取磁盘总容量
dir2_disk_size1=$(echo $dir2_output | awk '{ print $4 }')
echo ${disk_size}

# 获取文件路径
dir2_partition=$(echo $dir2_output | awk '{ print $3 }' )

# 判断剩余内存大小以及可用空间是否低于指定值
if [ $dir2_usep -ge 90 ] || [ `echo "${dir2_availablep%?} <= 5" | bc` -eq 1 ]; then
  dir2_percent_residue="<font color=#EE0000>$dir2_usep%</font>"    # 红色
  dir2_available_space="<font color=#EE0000>$dir2_availablep</font>"
  dir2_disk_size2="<font color=#EE0000>/$dir2_disk_size1</font>"
  dir2_anchor=1
else
  dir2_percent_residue="<font color=#00ee00>$dir2_usep%</font>"    # 绿色
  dir2_available_space="<font color=#00ee00>$dir2_availablep</font>"
  dir2_disk_size2="<font color=#00ee00>/$dir2_disk_size1</font>"
  dir2_anchor=0
fi


# 获取当前时间
t=`date "+%Y-%m-%d %H:%M:%S"`

if [ $dir1_anchor -eq 1 ] && [ $dir2_anchor -eq 1 ]; then
text="---
- 环境：$(hostname)
- 时间：${t}
---
- 文件路径：${dir1_partition}
- 剩余空间：${dir1_available_space}${dir1_disk_size2}
- 当前已用: ${dir1_percent_residue}
---
- 文件路径：${dir2_partition}
- 剩余空间：${dir2_available_space}${dir2_disk_size2}
- 当前已用: ${dir2_percent_residue}
"
elif [ $dir1_anchor -eq 1 ]; then
text="---
- 环境：$(hostname)
- 时间：${t}
- 文件路径：${dir1_partition}
- 剩余空间：${dir1_available_space}${dir1_disk_size2}
- 当前已用: ${dir1_percent_residue}
"
elif [ $dir2_anchor -eq 1 ]; then
text="---
- 环境：$(hostname)
- 时间：${t}
- 文件路径：${dir2_partition}
- 剩余空间：${dir2_available_space}${dir2_disk_size2}
- 当前已用: ${dir2_percent_residue}
"
fi


if [ ! ${text} ]; then
echo "text为空，磁盘状态正常！"
else
curl -i -X POST \
'https://oapi.dingtalk.com/robot/send?access_token=736728e4f0a8223b517a3d537c5f3312d72530d8a2a87f5befc16491af90672e' \
-H 'Content-type':'application/json' \
-d "
{
	'msgtype': 'markdown',
	'markdown': {
		'title': '磁盘监控告警',
		'text': '# 磁盘监控告警
${text}'
	},
	'at':{
		'isAtAll':false
	}
}"
fi
