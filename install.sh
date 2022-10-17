#!/usr/bin/env bash

# 修改镜像源
sudo sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list
sudo sed -i "s@http://.*security.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list

apt update -y && apt upgrade -y

# 修改时区

timedatectl set-timezone Aisa/Shanghai
timedatectl

apt install -y --no-install-recommends cron wget

# shellcheck disable=SC2046
wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb

# shellcheck disable=SC2046
sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
percona-release enable-only tools release
apt update
sudo apt install percona-xtrabackup-80
sudo apt install qpress

apt clean
rm -rf /var/log/*
rm -rf /var/lib/apt/lists/*
# shellcheck disable=SC2046
#rm -rf percona-release_latest.$(lsb_release -sc)_all.deb
