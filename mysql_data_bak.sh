#!/bin/bash

mysql_user="root"
#数据库密码，注意自行修改
mysql_password="123456"
mysql_host="localhost"
mysql_port="3306"
mysql_charset="utf8mb4"
#备份文件存放的目录，自己创建位置
mkdir -p /usr/local/mysql.bak/
backup_location=/usr/local/mysql.bak/

expire_backup_delete="ON"
#备份文件存放的天数
expire_days=15
backup_time=`date +%Y-%m-%d-%H-%M`
backup_dir=$backup_location
#指定忽略的表
#--ignore-table=tablename
docker exec -i mysql mysqldump -h$mysql_host -P$mysql_port -u$mysql_user -p$mysql_password -B dcc | gzip> $backup_dir/mysql_backup_dcc_$backup_time.sql.gz

#定时清理15天前的备份
if [ "$expire_backup_delete" == "ON" -a  "$backup_location" != "" ];then
        `find $backup_location/ -type f -mtime +$expire_days | xargs rm -rf`
        echo -e "\033[32m #### MySQL数据库已备份 $expire_days天前的备份已删除 #### \033[0m" #green
fi
