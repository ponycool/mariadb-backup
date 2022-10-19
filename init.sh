#!/usr/bin/env bash

CMD_DIR=/var/backup-cmd

# 如果用户未设置BACKUP_DIR，备份会保存在VOLUME中，防止备份丢失
if [ "$BACKUP_DIR" = "" ]; then
  export BACKUP_DIR=/mnt/backup
fi

# 将环境变量写入到文件中，方便定时任务在执行时获取，要不定时任务获取不到Docker设置的环境变量
echo "export BACKUP_SCRIPTS='$BACKUP_SCRIPTS'" >$BACKUP_DIR/env
echo "export BACKUP_DIR='$BACKUP_DIR'" >>$BACKUP_DIR/env
# 备份选项
echo "export BACKUP_OPTIONS=-H$HOST -P$PORT -u$USER -p$PASSWORD" >>$BACKUP_DIR/env
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
