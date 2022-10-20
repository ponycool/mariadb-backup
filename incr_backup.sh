#!/usr/bin/env bash

cd $(dirname $0)
. ./common.sh

if [ -f /.backTemp ]; then
  . /.backTemp
fi

if [ ! "$HAS_FALL_BACK" ]; then
  error "未全量备份，跳过本次增量备份"
fi

# 输出备份信息
echo $(date_time)"start exec incr back script"

# 查找最近的全备目录
LATEST_FULL=$(find "$FULL_BACKUP_DIR" -mindepth 1 -maxdepth 1 -type d -printf "%P\n")
echo $(date_time)"最近的全备目录为: $LATEST_FULL"

# 如果最近的全备仍然可用执行增量备份
# 创建增量备份的目录
TMP_INCR_DIR=$INCR_BACKUP_DIR/$LATEST_FULL
mkdir -p "$TMP_INCR_DIR"

# 获取最近的增量备份目录
LATEST_INCR=$(find "$TMP_INCR_DIR" -mindepth 1 -maxdepth 1 -type d | sort -nr | head -1)
echo "最近的增量备份目录为: $LATEST_INCR"
# 如果是首次增量备份，那么BackupDir则选择全备目录，否则选择最近一次的增量备份目录
if [ ! "$LATEST_INCR" ]; then
  INCR_BASE_DIR=$FULL_BACKUP_DIR/$LATEST_FULL
else
  INCR_BASE_DIR=$LATEST_INCR
fi
echo "Running new incremental backup using $INCR_BASE_DIR as base."
echo "start exec $BACKUP_EX $BACKUP_OPTIONS --incremental $TMP_INCR_DIR --incremental-basedir $INCR_BASE_DIR > $TMP_FILE 2>&1"

$BACKUP_EX $(echo "$BACKUP_OPTIONS") --incremental "$TMP_INCR_DIR" --incremental-basedir "$INCR_BASE_DIR" >"$TMP_FILE" 2>&1

if [ -z "$(tail -1 "$TMP_FILE" | grep 'completed OK!')" ]; then
  echo "$BACKUP_EX failed:"
  echo
  echo "---------- ERROR OUTPUT from $BACKUP_EX ----------"
  error "incr backup failed"
fi

# 这里获取这次备份的目录
THIS_BACKUP=$(awk -- "/Backup created in directory/ { split( \$0, p, \"'\" ) ; print p[2] }" "$TMP_FILE")
echo "THIS_BACKUP=$THIS_BACKUP"
rm -f "$TMP_FILE"
echo
echo "Databases backed up successfully to: $THIS_BACKUP"

echo
echo "incremental completed: $(date '+%Y-%m-%d %H:%M:%S')"
exit 0
