define USAGE
Super awesome hand-crafted build system ⚙️

Commands:
	setup     Install dependencies, dev included
	lock      Generate requirements.txt
	test      Run tests
	lint      Run linting tests
	run       Run docker image with --rm flag but mounted dirs.
	release   Publish docker image based on DOCKERID
	docker    Build the docker image
	tag    	  Make a git tab using poetry information
endef

export USAGE
.EXPORT_ALL_VARIABLES:
VERSION := $(shell git describe --tags)
BUILD := $(shell git rev-parse --short HEAD)
DOCKERID := $(shell echo "nuxion")
PROJECTNAME := $(shell basename "$(PWD)")
PACKAGE_DIR = $(shell basename "$(PWD)")

help:
	@echo "$$USAGE"

.PHONY: lint
lint:
	echo "Running pylint...\n"
	pylint --disable=R,C,W $(PACKAGE_DIR)
	# echo "Running isort...\n"
	# isort --check $(PACKAGE_DIR)
	# echo "Running mypy...\n"
	# mypy $(PACKAGE_DIR)

.PHONY: test
test:
	PYTHONPATH=$(PWD) pytest tests/

.PHONY: setup
setup:
	poetry install 

.PHONY: run
run:
	docker run --rm -p 127.0.0.1:8000:8000 ${DOCKERID}/${PROJECTNAME}

lock:
	poetry export -f requirements.txt --output requirements.txt --without-hashes

.PHONY: docker
docker: 
	docker build -t ${DOCKERID}/${PROJECTNAME} .


.PHONY: release
release: 
	docker tag ${DOCKERID}/${PROJECTNAME} ${DOCKERID}/${PROJECTNAME}:$(VERSION) 
	docker push ${DOCKERID}/$(PROJECTNAME):$(VERSION)

.PHONY: tag
tag:
	#poetry version prealese
	git tag -a $(shell poetry version --short) -m "$(shell git log -1 --pretty=%B | head -n 1)"
