FROM ubuntu:20.04
LABEL maintainer="MariaDB Backup DOCKER MAINTAINER <pony@ponycool.com>"

ENV USER=root
ENV PASSWORD=mysql
ENV PORT=3306
ENV HOST=127.0.0.1
ENV BACKUP_DIR=/mnt/backup

ARG CMD_DIR=/var/backup-cmd

COPY  install.sh init.sh common.sh full_backup.sh incr_backup.sh ${CMD_DIR}/

RUN apt update -y \
    && apt install -y  ca-certificates \
    # 修改镜像源
    && sed -i "s@http://.*security.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list \
    && sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list \
    && apt update -y && apt upgrade -y \
    # 修改时区
    && apt install -y tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && chmod a+x ${CMD_DIR}/*.sh \
    && sh ${CMD_DIR}/install.sh \
    && mkdir ${BACKUP_DIR} \
    && rm -rf ${CMD_DIR}/install.sh

VOLUME /mnt/backup

ENTRYPOINT ["/var/backup-cmd/init.sh"]

CMD [ "init" ]