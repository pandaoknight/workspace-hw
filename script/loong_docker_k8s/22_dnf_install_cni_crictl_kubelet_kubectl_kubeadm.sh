#!/bin/bash

# Define directories
DOWNLOAD_DIR="downloads"
cd $DOWNLOAD_DIR

##
dnf install cri-tools-1.29.0-0.loongarch64.rpm
dnf install kubelet-1.29.0-0.loongarch64.rpm

##
dnf install kubectl-1.29.0-0.loongarch64.rpm
dnf install kubernetes-cni-1.3.0-0.loongarch64.rpm
dnf install kubeadm-1.29.0-0.loongarch64.rpm

