#!/bin/bash

# Variable
CONTAINER_ID="container-id-ap1"

IMAGE=$(cat ./IMAGE)
TAG=$(cat ./TAG)

# NOT Change

docker run -it --network=host --name=${CONTAINER_ID} --privileged \
  --device=/dev/kfd --device=/dev/dri --ipc=host --shm-size=32G -v /opt/hyhal:/opt/hyhal \
  --group-add video --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
  --ulimit stack=-1:-1 --ulimit memlock=-1:-1 \
  -p 8888:8888 \
  ${IMAGE}:${TAG}
