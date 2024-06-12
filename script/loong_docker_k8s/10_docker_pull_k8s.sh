#!/bin/bash -x

docker pull lcr.loongnix.cn/kubernetes/coredns:v1.11.1
docker pull lcr.loongnix.cn/kubernetes/etcd:3.5.10-0
docker pull lcr.loongnix.cn/kubernetes/kube-apiserver:v1.29.0
docker pull lcr.loongnix.cn/kubernetes/kube-controller-manager:v1.29.0
docker pull lcr.loongnix.cn/kubernetes/kube-proxy:v1.29.0
docker pull lcr.loongnix.cn/kubernetes/kube-scheduler:v1.29.0
docker pull lcr.loongnix.cn/kubernetes/pause:3.9
