#!/bin/bash -x

cat /etc/systemd/system/kubelet.service

cat /etc/systemd/system/kubelet.service.d/*

cat /etc/sysconfig/kubelet

systemctl status kubelet --no-pager -l
#systemctl show kubelet --no-pager
