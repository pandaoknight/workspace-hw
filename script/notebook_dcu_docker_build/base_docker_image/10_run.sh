#!/bin/bash

ROOT_PATH="/data/szl1160710/script/mindspore_docker_build/"

# Variable
CONTAINER_ID="container-id-ap10"
IMAGE="image.sourcefind.cn:5000/dcu/admin/base/pytorch:1.10.0-centos7.6-dtk-22.10-py38-latest"

# NOT Change
#        -p 30080:30080 \
#docker run -u root -it --name ${CONTAINER_ID} \
docker run -it --name ${CONTAINER_ID} \
	${IMAGE} /bin/bash
