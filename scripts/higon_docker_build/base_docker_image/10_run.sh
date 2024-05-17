
#!/bin/bash

ROOT_PATH="/data/szl1160710/scripts/mindspore_docker_build/"

# Variable
CONTAINER_ID="container-id-ap1"
IMAGE="image.sourcefind.cn:5000/dcu/admin/base/pytorch:1.10.0-centos7.6-dtk-22.10-py38-latest"
# NOT Change
#RUNTIME="io.containerd.runtime.v1.linux" # default runtime already setted.
DEVICES="2"

#docker run -u root -it --name ${CONTAINER_ID} \
docker run -it --name ${CONTAINER_ID} \
        -p 30081:30081 \
	-e ASCEND_VISIBLE_DEVICES=${DEVICES} \
	-v ${ROOT_PATH}/volumes/samples/:/home/HwHiAiUser/samples/ \
	-v ${ROOT_PATH}/volumes/mindspore_fcn8s/:/home/HwHiAiUser/mindspore_fcn8s/ \
	${IMAGE}
	#${IMAGE} /bin/bash
