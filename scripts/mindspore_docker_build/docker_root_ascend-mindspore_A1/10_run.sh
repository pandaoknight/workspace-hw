
#!/bin/bash

# Variable
CONTAINER_ID="container-id-ap10"
IMAGE_TAG=$(cat ./IMAGE):$(cat ./TAG)
# NOT Change
DEVICES="2"

docker run -it --name ${CONTAINER_ID} \
	-e ASCEND_VISIBLE_DEVICES=${DEVICES} \
	-v /data/szl1160710/src/samples/:/home/HwHiAiUser/samples/ \
	${IMAGE_TAG} /bin/bash
