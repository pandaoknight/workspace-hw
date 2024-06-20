#!/bin/bash

#
docker pull lcr.loongnix.cn/library/openjdk:8-sid

docker history lcr.loongnix.cn/library/openjdk:8-sid

docker run -it --rm lcr.loongnix.cn/library/openjdk:8-sid cat /etc/os-release
