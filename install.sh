#!/usr/bin/env bash

XTRA_DIR=/var/xtrabackup
XTRA_VERSION=8.0.26-18

apt install -y --no-install-recommends cron wget

mkdir ${XTRA_DIR} && cd ${XTRA_DIR}
wget wget --no-check-certificate -O percona-xtrabackup-${XTRA_VERSION}.deb \
  https://downloads.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-${XTRA_VERSION}/binary/debian/focal/x86_64/percona-xtrabackup-80_${XTRA_VERSION}-1.focal_amd64.deb

dpkg -i percona-xtrabackup-${XTRA_VERSION}.deb
apt update -y && apt upgrade -y

apt install -y libaio1
apt --fix-broken install -y

apt clean
rm -rf /var/log/*
rm -rf /var/lib/apt/lists/*
rm -rf ${XTRA_DIR}
