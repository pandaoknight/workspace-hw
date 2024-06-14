#!/bin/bash

echo "Show /etc/systemd/system/kubelet.service"
ll /etc/systemd/system/kubelet.service*

systemctl stop kubelet
echo "Stopped kubelet service"

systemctl disable kubelet
echo "Disabled kubelet service"


rm -f /etc/systemd/system/kubelet.service
echo "Deleted /etc/systemd/system/kubelet.service"

rm -rf /etc/systemd/system/kubelet.service.d
echo "Deleted /etc/systemd/system/kubelet.service.d/10-kubeadm.conf"

systemctl daemon-reload
echo "Reloaded systemd daemon"

