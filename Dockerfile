FROM ubuntu:20.04
LABEL maintainer="MariaDB Backup DOCKER MAINTAINER <pony@ponycool.com>"

ARG CMD_DIR=/var/backup-cmd

COPY  install.sh init.sh common.sh fullbak.sh incrbak.sh ${CMD_DIR}

RUN sh ${CMD_DIR}/install.sh && \
    rm -rf ${CMD_DIR}/install.sh \
    && chmod a+x ${CMD_DIR}/*.sh

#COPY init.sh /root/
#RUN chmod a+x /root/*.sh

VOLUME /mnt/backup

ENTRYPOINT ["/var/backup-cmd/init.sh"]

CMD [ "init" ]