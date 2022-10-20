# 默认版本
version = latest

.PHONY: build
build:
	./build.sh ${version}

.PHONY: push
push:
	docker push ponycool/mariadb-backup:latest
