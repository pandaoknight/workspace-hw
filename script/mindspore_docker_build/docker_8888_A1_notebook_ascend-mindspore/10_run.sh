
#!/bin/bash

ROOT_PATH="/data/szl1160710/script/mindspore_docker_build/"

# Variable
IMAGE=$(cat ./IMAGE)
TAG=$(cat ./TAG)
CONTAINER_ID="container-id-ap10"
# NOT Change
DEVICES="2"

#docker run -u root -it --name ${CONTAINER_ID} \
docker run -it --name ${CONTAINER_ID} \
	-e ASCEND_VISIBLE_DEVICES=${DEVICES} \
        -p 8888:30080 \
	${IMAGE}:${TAG}
