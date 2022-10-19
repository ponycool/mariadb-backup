#!/usr/bin/env bash

CMD_DIR=/var/backup-cmd

# 如果用户未设置BACKUP_DIR，备份会保存在VOLUME中，防止备份丢失
if [ "$BACKUP_DIR" = "" ]; then
  export BACKUP_DIR=/mnt/backup
fi

# 将环境变量写入到文件中，方便定时任务在执行时获取
export BACKUP_SCRIPTS="$BACKUP_SCRIPTS"
export BACKUP_DIR="$BACKUP_DIR"
# 备份选项
if [ "$BACKUP_OPTIONS" = "" ]; then
  BACKUP_OPTIONS="--host=$HOST --port=$PORT --user=$USER --password=$PASSWORD"
fi

export BACKUP_OPTIONS="$BACKUP_OPTIONS"

if [ "$1" == "init" ]; then
  # 初始化执行环境
  /etc/init.d/cron start
  echo "0 3 * * 3,6 root ${CMD_DIR}/full_backup.sh > /var/log/mariadb_backup.log 2>&1" >>/etc/crontab
  # shellcheck disable=SC2016
  echo "0 */2 * * * root ${CMD_DIR}/incr_backup.sh >> /var/log/mariadb_backup.log 2>&1" >>/etc/crontab
  ${CMD_DIR}/full_backup.sh >/var/log/mariadb_backup.log 2>&1
  tail -f /var/log/mariadb_backup.log
else
  # 透传待执行的命令
  exec "$@"
fi
