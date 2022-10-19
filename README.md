# MariaDB Backup

## 描述（Description）

[MariaDB Backup 使用参考](https://mariadb.com/kb/en/mariabackup-overview/)
[MariaDB Backup仓库的设置及使用参考](https://mariadb.com/kb/en/mariadb-package-repository-setup-and-usage/)

感谢[fanxcv](https://github.com/fanxcv/xtrabackup-docker)

## 安装（Installation）

镜像TAG必须与MariaDB版本一致

```
docker pull ponycool/mariadb-backup:latest
```

## 使用（Usage）

```
docker run -it --name mariadb-backup \
-e USER=root
-e PASSWORD=123456 \
-e HOST=127.0.0.1 \
-e PORT=3306 \
-v 
ponycool/mariadb-backup:latest
```

## 编译 (Build)

## 帮助支持（Support）

Blog: [https://www.mayanpeng.cn](https://www.mayanpeng.cn)

Email: pony#ponycool.com(将#替换为@)

Git: [https://github.com/PonyCool](https://www.mayanpeng.cn)

DockerHub：[https://hub.docker.com/u/ponycool](https://www.mayanpeng.cn)

## License

MIT license.
