#!/bin/bash

# Define color codes
CYAN="\x1b[36m"          # Cyan for the prompt
BRIGHT_WHITE="\x1b[97m"  # Bright white for the header
BLUE="\x1b[1;36m"        # Blue for USSD levels
NC="\x1b[0m"             # No color (reset to default)

#
echo -e "${CYAN}Pull and history lcr redis ...${NC}"
docker pull lcr.loongnix.cn/library/redis:7.0-alpine

docker history lcr.loongnix.cn/library/redis:7.0-alpine

echo -e "${CYAN}os-release of lcr redis ...${NC}"
docker run -it --rm lcr.loongnix.cn/library/redis:7.0-alpine cat /etc/os-release

#
echo -e "${CYAN}Original redis.yaml and export/redis.yaml ...${NC}"
ls -al /home/workspace-hw/src/autodeploy/7.k8s-deployment/component/redis.yaml
ls -al /home/workspace-hw/src/autodeploy/7.k8s-deployment/component/export/redis.yaml

#
echo -e "${CYAN}Loong redis.yaml and export/redis.yaml ...${NC}"
ls -al ./yaml_redis
grep image --color=always -r ./yaml_redis
