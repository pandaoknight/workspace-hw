
#!/bin/bash

# Variable
CONTAINER_ID="container-id-ap10"
#IMAGE="ascendhub.huawei.com/public-ascendhub/ascend-pytorch:23.0.RC3-1.11.0-ubuntu18.04"
IMAGE=$(cat IMAGE)
# NOT Change
#RUNTIME="io.containerd.runtime.v1.linux" # default runtime already setted.
DEVICES="2"

#docker run -u root -it --name ${CONTAINER_ID} -e ASCEND_VISIBLE_DEVICES=${DEVICES} ${IMAGE} /bin/bash
#docker run -u root -it --name ${CONTAINER_ID} \
docker run -it --name ${CONTAINER_ID} \
	-e ASCEND_VISIBLE_DEVICES=${DEVICES} \
	-v /data/szl1160710/src/samples/:/home/HwHiAiUser/samples/ \
	${IMAGE} /bin/bash
