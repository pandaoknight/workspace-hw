#!/bin/bash

#
docker pull lcr.loongnix.cn/library/redis:7.0-alpine

docker history lcr.loongnix.cn/library/redis:7.0-alpine

docker run -it --rm lcr.loongnix.cn/library/redis:7.0-alpine cat /etc/os-release
