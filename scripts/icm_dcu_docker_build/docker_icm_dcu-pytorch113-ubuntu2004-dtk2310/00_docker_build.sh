#!/bin/bash

IMAGE=$(cat ./IMAGE)
TAG=$(cat ./TAG)

cp ../notebooks -r .

docker build -t ${IMAGE}:${TAG} .

rm ./notebooks -rf
