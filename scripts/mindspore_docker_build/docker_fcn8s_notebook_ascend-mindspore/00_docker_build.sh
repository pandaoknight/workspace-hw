#!/bin/bash

_tag=$(cat ./TAG)

rm -rf mindspore_fcn8s
cp -r /data/szl1160710/scripts/mindspore_docker_build/volumes/mindspore_fcn8s mindspore_fcn8s
docker build -t unionbigdata/notebook_ascend-mindspore:${_tag} .
