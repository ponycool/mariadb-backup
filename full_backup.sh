#!/usr/bin/env bash
echo "HAS_FALL_BACK=" >/.backTemp
cd $(dirname "$0")
. ./common.sh

check_has_other_task

# 输出备份信息
echo $(date_time)"start exec full back script"

# 压缩上传前一天的备份
echo $(date_time)"compress the backup data of the last time"
cd "$BACKUP_DIR"
tar -zcf "$YESTERDAY".tar.gz ./full/ ./incr/
# 如果设置了备份语句，执行备份语句
if [ -n "$BACKUP_SCRIPTS" ]; then
  echo $(date_time)"start exec backup script: $BACKUP_SCRIPTS"
  bash -c "$BACKUP_SCRIPTS"
  if [ $? = 0 ]; then
    echo $(date_time)"exec backup script success"
  else
    echo $(date_time)"exec backup script failed"
  fi
fi

rm -rf "$FULL_BACKUP_DIR" "$INCR_BACKUP_DIR"
echo $(date_time)"start exec $BACKUP_EX --backup $BACKUP_OPTIONS --target-dir=$FULL_BACKUP_DIR > $TMP_FILE 2>&1"

$BACKUP_EX --backup $(echo "$BACKUP_OPTIONS") --target-dir="$FULL_BACKUP_DIR" >"$TMP_FILE" 2>&1

if [ -z "$(tail -1 "$TMP_FILE" | grep 'completed OK!')" ]; then
  echo "$BACKUP_EX failed:"
  echo
  echo "---------- ERROR OUTPUT from $BACKUP_EX ----------"
  cat "$TMP_FILE"
  rm -f "$TMP_FILE"
  error "backup data failed"
fi

# 这里获取这次备份的目录
THIS_BACKUP=$(awk -- "/Backup created in directory/ { split( \$0, p, \"'\" ) ; print p[2] }"" $TMPFI"LE)
echo "THIS_BACKUP=$THIS_BACKUP"
rm -f "$TMP_FILE"
echo
echo "Databases backed up successfully to: $THIS_BACKUP"

# Cleanup
echo "delete tar files of 10 days ago"
find "$BACKUP_DIR"/ -mtime +10 -name "*.tar.gz" -exec rm -rf {} \;

echo
echo "completed: $(date '+%Y-%m-%d %H:%M:%S')"
echo "HAS_FALL_BACK=true" >/.backTemp
echo '' >~/.run
exit 0
