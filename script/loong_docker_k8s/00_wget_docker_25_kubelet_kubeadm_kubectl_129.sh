#!/bin/bash -x

mkdir -p ./downloads
cd ./downloads

#
wget -c http://cloud.loongnix.cn/releases/loongarch64/docker/docker-seccomp-25.0.2-abi2.0-static-all-bin.tar.gz

#
wget -c http://cloud.loongnix.cn/releases/loongarch64/kubernetes/kubernetes/v1.29.0/kubelet
wget -c http://cloud.loongnix.cn/releases/loongarch64/kubernetes/kubernetes/v1.29.0/kubeadm
wget -c http://cloud.loongnix.cn/releases/loongarch64/kubernetes/kubernetes/v1.29.0/kubectl
chmod +x kubelet
chmod +x kubeadm
chmod +x kubectl
