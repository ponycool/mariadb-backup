# MariaDB Backup

## 描述（Description）

MariaDB定时热备

1. [MariaDB Backup 使用参考](https://mariadb.com/kb/en/mariabackup-overview/)
2. [MariaDB Backup仓库的设置及使用参考](https://mariadb.com/kb/en/mariadb-package-repository-setup-and-usage/)

## 安装（Installation）

镜像TAG必须与MariaDB版本一致

```
docker pull ponycool/mariadb-backup:latest
```

## 使用（Usage）

```
docker run -it --name mariadb-backup \
--privileged \
-e USER=root \
-e PASSWORD=123456 \
-e HOST=127.0.0.1 \
-e PORT=3306 \
-e BACKUP_DIR=/mnt/backup \
-v /var/lib/mysql:/var/lib/mysql \
ponycool/mariadb-backup:latest
```

参数说明：

- BACKUP_DIR: 备份文件存放目录
- HOST MariaDB连接地址
- PORT 端口
- USER 用户名
- PASSWORD 密码
- BACKUP_OPTIONS MariaDB连接参数-H IP地址 -P 端口号 -u 用户名 -p 密码，和上面的连接参数二选其一
- BACKUP_SCRIPTS 自定义备份脚本

**必须挂载MariaDB的数据目录**

备份规则为：

- 每周三和周六凌晨三点全量备份， 其余时间每隔两小时做一次增量更新，
- 每次全量更新的时候，会把之前的全量与增量备份数据压缩后存放在BACKUP_DIR目录下，
- 保留最近10天的备份数据，也就是最多三个全备数据

## 支持的Tags

- 10.4
- 10.5
- 10.6
- 10.9

## 编译 (Build)

手动编译

```shell
# 使用Make
make build [version=latest]

# 使用sh
./build.sh ${version}
```

## 推送到DockerHub镜像仓库

```shell
# 使用Make
make push [version=latest]

# 使用sh
docker push ponycool/mariadb-backup:${version}
```

## 帮助支持（Support）

Blog: [https://www.mayanpeng.cn](https://www.mayanpeng.cn)

Email: pony#ponycool.com(将#替换为@)

Git: [https://github.com/PonyCool](https://www.mayanpeng.cn)

DockerHub：[https://hub.docker.com/u/ponycool](https://www.mayanpeng.cn)

## License

MIT license.
