
.PHONY: all build check test test_makefile

DOCKER_TAG?=local
DOCKER_CONTAINER?=golang_dev:$(DOCKER_TAG)
TEST_PROJECT:=$(PWD)/sample_golang_proj
TEST_PACKAGE:=github.com/samsung-cnct/golang-tools/sample

all: check test test_makefile


build: 
	docker build -t "$(DOCKER_CONTAINER)" -f Dockerfile ./

check: build
	docker run -v "$(TEST_PROJECT):/go/src/$(TEST_PACKAGE)" --rm -it $(DOCKER_CONTAINER) check

test: build
	docker run -v "$(TEST_PROJECT):/go/src/$(TEST_PACKAGE)" --rm -it $(DOCKER_CONTAINER) test


test_makefile: build
	docker run -v "$(TEST_PROJECT):/go/src/$(TEST_PACKAGE)" --rm -it $(DOCKER_CONTAINER) make -f Makefile.inside test