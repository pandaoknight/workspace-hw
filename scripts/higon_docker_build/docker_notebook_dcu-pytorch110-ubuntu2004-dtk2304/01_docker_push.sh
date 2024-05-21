#!/bin/bash

IMAGE=$(cat ./IMAGE)
TAG=$(cat ./TAG)

docker push ${IMAGE}:${TAG}
