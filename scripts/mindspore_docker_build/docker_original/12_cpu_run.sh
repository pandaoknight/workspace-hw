
#!/bin/bash

# Variable
CONTAINER_ID="container-id-ap12"
IMAGE=$(cat IMAGE)
# NOT Change

docker run -it --name ${CONTAINER_ID} \
	-v /data/szl1160710/src/samples/:/home/HwHiAiUser/samples/ \
	${IMAGE} /bin/bash