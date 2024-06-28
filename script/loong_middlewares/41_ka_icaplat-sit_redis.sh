#!/bin/bash

# Define color codes
CYAN="\x1b[36m"          # Cyan for the prompt
BRIGHT_WHITE="\x1b[97m"  # Bright white for the header
BLUE="\x1b[1;36m"        # Blue for USSD levels
NC="\x1b[0m"             # No color (reset to default)

NAMESPACE="icaplat-sit"

#
echo -e "${CYAN}Apply redis and its clusterIP nodePort ...${NC}"
kubectl apply -n ${NAMESPACE} -f ./yaml_redis/redis.yaml
kubectl apply -n ${NAMESPACE} -f ./yaml_redis/redis_nodeport.yaml

echo -e "${CYAN}Get resources ...${NC}"
kubectl get -n ${NAMESPACE} -f ./yaml_redis/redis.yaml
kubectl get -n ${NAMESPACE} -f ./yaml_redis/redis_nodeport.yaml
