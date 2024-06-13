#!/bin/bash

# Define directories
DOWNLOAD_DIR="downloads"
INSTALL_DIR="/usr/local/bin"

# Install kubelet
echo -e "\x1b[36mInstalling kubelet...\x1b[0m"
sudo install -o root -g root -m 0755 "$DOWNLOAD_DIR/kubelet" "$INSTALL_DIR/kubelet"
kubelet --version

# Install kubeadm
echo -e "\x1b[36mInstalling kubeadm...\x1b[0m"
sudo install -o root -g root -m 0755 "$DOWNLOAD_DIR/kubeadm" "$INSTALL_DIR/kubeadm"
kubeadm version

# Install kubectl
echo -e "\x1b[36mInstalling kubectl...\x1b[0m"
sudo install -o root -g root -m 0755 "$DOWNLOAD_DIR/kubectl" "$INSTALL_DIR/kubectl"
kubectl version --client
