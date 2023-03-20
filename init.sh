#!/bin/bash

# 安装tress
sudo yum install -y epel-release

# 安装vim
sudo yum install -y vim

# 安装wget
sudo yum install -y wget

# 安装net-tools
sudo yum install -y net-tools

# 安装stress
sudo yum install -y stress

# 安装iotop
sudo yum install -y iotop

# 安装htop
sudo yum install -y htop

# 安装sysstat
sudo yum install -y sysstat   

# 安装snap
sudo yum install -y snapd




# 安装后操作
sudo systemctl enable snapd
sudo systemctl restart snapd
sudo systemctl is-enabled snapd

