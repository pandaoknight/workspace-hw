#!/bin/bash

CONTAINER_ID="container-id-ap19"
IMAGE="harbor.xnunion.com/icm_alg/icm_runtime:0.0.8"

docker run -it --network=host --name=${CONTAINER_ID} --privileged \
  --device=/dev/kfd --device=/dev/dri --ipc=host --shm-size=32G -v /opt/hyhal:/opt/hyhal \
  --group-add video --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
  -u root \
  --ulimit stack=-1:-1 --ulimit memlock=-1:-1 \
  ${IMAGE} pip list
