.PHONY: build
build:
	./build.sh

.PHONY: push
push:
	docker push ponycool/alpine-3.16:latest
