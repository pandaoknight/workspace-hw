
#!/bin/bash

# Variable
CONTAINER_ID="container-id-ap13"
IMAGE="ascendhub.huawei.com/public-ascendhub/ascend-pytorch:23.0.0-A2-1.11.0-ubuntu18.04"
# NOT Change

docker run -u root -it --name ${CONTAINER_ID} \
	-v /data/szl1160710/src/samples/:/home/HwHiAiUser/samples/ \
	${IMAGE} /bin/bash
