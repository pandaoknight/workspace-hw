
#!/bin/bash

# Variable
CONTAINER_ID="container-id-ap12"
IMAGE_TAG=$(cat ./IMAGE):$(cat ./TAG)
# NOT Change
DEVICES="2"

#docker run -it --name ${CONTAINER_ID} \
#	-v /data/szl1160710/src/samples/:/home/HwHiAiUser/samples/ \
#	-v /data/szl1160710/scripts/mindspore_docker_build/docker_root_ascend-mindspore_A1/resnet50/:/home/HwHiAiUser/resnet50/ \
#	${IMAGE_TAG} /bin/bash
docker run -it --name ${CONTAINER_ID} \
	-e ASCEND_VISIBLE_DEVICES=${DEVICES} \
	-v /data/szl1160710/src/samples/:/home/HwHiAiUser/samples/ \
	-v /data/szl1160710/scripts/mindspore_docker_build/docker_root_ascend-mindspore_A1/resnet50/:/home/HwHiAiUser/resnet50/ \
	${IMAGE_TAG} /bin/bash
