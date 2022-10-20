FROM ubuntu:20.04
LABEL maintainer="MariaDB Backup DOCKER MAINTAINER <pony@ponycool.com>"

ARG MARIADB_VERSION=10.9

ENV MARIADB_VERSION=${MARIADB_VERSION}
ENV USER=root
ENV PASSWORD=mysql
ENV PORT=3306
ENV HOST=127.0.0.1
ENV BACKUP_OPTIONS=""
ENV BACKUP_SCRIPTS=""
ENV BACKUP_DIR=/mnt/backup

ARG CMD_DIR=/var/backup-cmd

COPY init.sh common.sh full_backup.sh incr_backup.sh ${CMD_DIR}/

RUN apt update -y \
    && apt install -y  ca-certificates \
    # 修改镜像源
    && sed -i "s@http://.*security.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list \
    && sed -i "s@http://.*archive.ubuntu.com@https://mirrors.tuna.tsinghua.edu.cn@g" /etc/apt/sources.list \
    && apt update -y && apt upgrade -y \
    && apt install -y tzdata curl cron \
    # 修改时区
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    # 安装 mariadb-backup
    && curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | \
    bash -s -- --mariadb-server-version="mariadb-${MARIADB_VERSION}" \
    && apt update -y \
    && apt install -y mariadb-backup \
    && chmod a+x ${CMD_DIR}/*.sh \
    && mkdir ${BACKUP_DIR} \
    # 清除缓存
    && apt clean \
    && rm -rf /var/log/* \
    && rm -rf /var/lib/apt/lists/*

VOLUME ${BACKUP_DIR}

WORKDIR ${BACKUP_DIR}

ENTRYPOINT ["/var/backup-cmd/init.sh"]

CMD [ "init" ]