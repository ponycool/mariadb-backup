FROM ubuntu:20.04
LABEL maintainer="MariaDB Backup DOCKER MAINTAINER <pony@ponycool.com>"

ENV BACKUP_DIR=/mnt/backup

ARG CMD_DIR=/var/backup-cmd

COPY  install.sh init.sh common.sh full_backup.sh incr_backup.sh ${CMD_DIR}/

RUN chmod a+x ${CMD_DIR}/*.sh \
    && sh ${CMD_DIR}/install.sh \
    && mkdir ${BACKUP_DIR} \
    && rm -rf ${CMD_DIR}/install.sh

VOLUME /mnt/backup

ENTRYPOINT ["/var/backup-cmd/init.sh"]

CMD [ "init" ]