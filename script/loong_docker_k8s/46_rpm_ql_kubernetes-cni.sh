#!/bin/bash

NC='\x1b[0m' # No Color
CYAN='\x1b[0;36m'

## 
echo -e "${CYAN}Files in rpm kubernetes-cni ${NC}"
rpm -ql -p downloads/kubernetes-cni-1.3.0-0.loongarch64.rpm
