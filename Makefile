#!make
include .env
export $(shell sed 's/=.*//' .env)
NAME		:= $$REPO/$$PROJECT
TAG			:= $$(git rev-parse --short HEAD)
IMG			:= ${NAME}:${TAG}
LATEST	:= ${NAME}:latest

build:
	git rev-parse --short HEAD > ./app/git-rev.txt
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

push: build
	@docker push ${NAME}

login:
	@docker log -u ${DOCKER_USER} -p ${DOCKER_PASS}
