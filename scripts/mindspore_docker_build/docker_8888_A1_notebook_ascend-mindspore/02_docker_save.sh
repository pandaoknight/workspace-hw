#!/bin/bash

IMAGE=$(cat ./IMAGE)
TAG=$(cat ./TAG)

#docker save ${IMAGE}:${TAG} -o ${IMAGE//\//_}_${TAG}.tar
docker save ${IMAGE}:${TAG} | pv > ${IMAGE//\//_}_${TAG}.tar
