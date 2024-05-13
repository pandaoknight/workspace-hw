#!/bin/bash

IMAGE=$(cat ./IMAGE)
TAG=$(cat ./TAG)

docker build -t ${IMAGE}:${TAG} .

