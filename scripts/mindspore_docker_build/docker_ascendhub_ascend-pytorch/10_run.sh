
#!/bin/bash

ROOT_PATH="/data/szl1160710/scripts/mindspore_docker_build/"

# Variable
CONTAINER_ID="container-id-ap1"
#IMAGE="ascendhub.huawei.com/public-ascendhub/ascend-pytorch:23.0.RC3-1.11.0-ubuntu18.04"
IMAGE="ascendhub.huawei.com/public-ascendhub/ascend-pytorch:23.0.0-A2-1.11.0-ubuntu18.04"
# NOT Change
#RUNTIME="io.containerd.runtime.v1.linux" # default runtime already setted.
DEVICES="2"

#docker run -it --name ${CONTAINER_ID} \
docker run -u root -it --name ${CONTAINER_ID} \
	-e ASCEND_VISIBLE_DEVICES=${DEVICES} \
	-v ${ROOT_PATH}/volumes/samples/:/home/HwHiAiUser/samples/ \
	-v ${ROOT_PATH}/volumes/mindspore_fcn8s/:/home/HwHiAiUser/mindspore_fcn8s/ \
	${IMAGE} /bin/bash
