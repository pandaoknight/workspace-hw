#!/bin/bash

NC='\x1b[0m' # No Color
CYAN='\x1b[0;36m'

## 
echo -e "${CYAN}Services in rpm kubelet${NC}"
rpm -ql -p downloads/kubelet-1.29.0-0.loongarch64.rpm|grep --color=always -a10 systemd
echo -e "${CYAN}Services in rpm kubeadm${NC}"
rpm -ql -p downloads/kubeadm-1.29.0-0.loongarch64.rpm|grep --color=always -a10 systemd

##
echo ""
echo -e "${CYAN}Diff kubelet.service${NC}"
diff /etc/systemd/system/kubelet.service \
    /usr/lib/systemd/system/kubelet.service
echo -e "${CYAN}Diff kubelet.service.d/10-kubeadm.conf${NC}"
diff /etc/systemd/system/kubelet.service.d/10-kubeadm.conf \
    /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf
