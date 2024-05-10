
#!/bin/bash

# Variable
CONTAINER_ID="container-id-ap10"
IMAGE="ascendhub.huawei.com/public-ascendhub/ascend-mindspore:23.0.0-A1-ubuntu18.04"
# NOT Change
DEVICES="2"

docker run -it --name ${CONTAINER_ID} \
	-e ASCEND_VISIBLE_DEVICES=${DEVICES} \
	-v /data/szl1160710/src/samples/:/home/HwHiAiUser/samples/ \
	${IMAGE} /bin/bash
