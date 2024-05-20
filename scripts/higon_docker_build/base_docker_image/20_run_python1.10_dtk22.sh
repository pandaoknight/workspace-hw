#!/bin/bash

CONTAINER_ID="container-id-ap20"
IMAGE="image.sourcefind.cn:5000/dcu/admin/base/pytorch:1.10.0-centos7.6-dtk-22.10-py38-latest"

docker run -dit --network=host --name=${CONTAINER_ID} --privileged \
  --device=/dev/kfd --device=/dev/dri --ipc=host --shm-size=32G -v /opt/hyhal:/opt/hyhal \
  --group-add video --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
  -u root \
  --ulimit stack=-1:-1 --ulimit memlock=-1:-1 \
  ${IMAGE}
