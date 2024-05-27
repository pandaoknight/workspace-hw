#!/bin/bash
ls -al|grep " docker_"
cat */TAG
grep -h FROM */Dockerfile
docker images unionbigdata/notebook_dcu-pytorch

