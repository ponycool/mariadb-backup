.PHONY: build
build:
	./build.sh

.PHONY: push
push:
	docker push ponycool/mariadb-backup:latest
