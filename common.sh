#!/usr/bin/env bash

# docker需要判断环境变量文件是否存在
if [ -f /dockerenv ]; then
  . /dockerenv
  env
fi

#############################################################################
# 打印错误信息并退出
#############################################################################
error() {
  echo '' >~/.run
  echo "$1" 1>&2
  exit 1
}

#############################################################################
# 判断有没有正在运行的任务，有的话就停止执行本次任务
#############################################################################
check_has_other_task() {
  if [ ! -x ~/.run ]; then
    touch ~/.run
  fi
  last=$(cat ~/.run)
  now=$(date +%Y%m%d)
  if [ "$last" = "$now" ]; then
    error "has task is running, stop this task"
  fi
  echo "$now" >~/.run
}

date_time() {
  echo $(date +"%Y-%m-%d %H:%M:%S")": "
}

INNOBACKUPEXFULL=/usr/bin/mariabackup
# 脱敏备份选项，用于日志
BACKUP_OPTIONS_DS="--host=$HOST --port=$PORT --user=$USER --password=******"
# 备份选项
BACKUP_OPTIONS="--host=$HOST --port=$PORT --user=$USER --password=$PASSWORD"
TODAY=$(date +%Y%m%d%H%M)
YESTERDAY=$(date -d "yesterday" +%Y%m%d%H%M)
FULLBACKUPDIR=$BACKUP_DIR/full             # 全库备份的目录
INCRBACKUPDIR=$BACKUP_DIR/incr             # 增量备份的目录
TMPFILEDIR=$BACKUP_DIR/logs                # 日志目录
TMPFILE="$TMPFILEDIR/backup_$TODAY.$$.log" # 日志文件

# 开始备份前检查相关的参数
if [ ! -x $INNOBACKUPEXFULL ]; then
  error "$INNOBACKUPEXFULL does not exist."
fi

if [ ! -d "$BACKUP_DIR" ]; then
  error "Backup destination folder: $BACKUP_DIR does not exist."
fi

# 如果备份目录不存在则创建相应的全备增备目录
for i in $FULLBACKUPDIR $INCRBACKUPDIR $TMPFILEDIR; do
  if [ ! -d "$i" ]; then
    mkdir -pv "$i"
  fi
done
