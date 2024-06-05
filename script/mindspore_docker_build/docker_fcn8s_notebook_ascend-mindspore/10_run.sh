
#!/bin/bash

ROOT_PATH="/data/szl1160710/scripts/mindspore_docker_build/"

# Variable
_tag=$(cat TAG)
CONTAINER_ID="container-id-ap1"
IMAGE="unionbigdata/notebook_ascend-mindspore:${_tag}"
# NOT Change
#RUNTIME="io.containerd.runtime.v1.linux" # default runtime already setted.
DEVICES="2"

#docker run -u root -it --name ${CONTAINER_ID} \
docker run -it --name ${CONTAINER_ID} \
        -p 30081:30081 \
	-e ASCEND_VISIBLE_DEVICES=${DEVICES} \
	${IMAGE}
