#!/bin/bash

#
docker pull lcr.loongnix.cn/library/python:3.9.18-sid

docker history lcr.loongnix.cn/library/python:3.9.18-sid

docker run -it --rm lcr.loongnix.cn/library/python:3.9.18-sid /bin/sh
