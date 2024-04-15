
#!/bin/bash

# Variable
CONTAINER_ID="container-id-ap1"
IMAGE="docker.io/hyperdl/ascend-pytorch:23.0.RC1-ubuntu18.04"
# NOT Change
#RUNTIME="io.containerd.runtime.v1.linux" # default runtime already setted.
DEVICES="2"

docker run -u root -it --name ${CONTAINER_ID} -e ASCEND_VISIBLE_DEVICES=${DEVICES} ${IMAGE} /bin/bash
#docker run -it --name ${CONTAINER_ID} -e ASCEND_VISIBLE_DEVICES=${DEVICES} ${IMAGE} /bin/bash
