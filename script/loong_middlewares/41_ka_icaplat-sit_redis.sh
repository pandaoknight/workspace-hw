#!/bin/bash

# Define color codes
CYAN="\x1b[36m"          # Cyan for the prompt
BRIGHT_WHITE="\x1b[97m"  # Bright white for the header
BLUE="\x1b[1;36m"        # Blue for USSD levels
RED="\x1b[31m"           # Red for errors
NC="\x1b[0m"             # No color (reset to default)

NAMESPACE="icaplat-sit"

#
echo -e "${CYAN}Apply redis and its clusterIP nodePort ...${NC}"
kubectl apply -n ${NAMESPACE} -f ./yaml_redis/redis.yaml
kubectl apply -n ${NAMESPACE} -f ./yaml_redis/redis_nodeport.yaml

echo -e "${CYAN}Get resources ...${NC}"
kubectl get -n ${NAMESPACE} -f ./yaml_redis/redis.yaml
kubectl get -n ${NAMESPACE} -f ./yaml_redis/redis_nodeport.yaml


# Check Redis PING from within the Pod
echo -e "${CYAN}Checking Redis PING from within the Pod...${NC}"
POD=$(kubectl get pod -n ${NAMESPACE} -l app=redis -o jsonpath='{.items[0].metadata.name}')

if [ -z "$POD" ]; then
  echo -e "${RED}No Redis pod found${NC}"
  exit 1
fi

echo -e "${BRIGHT_WHITE}Selected Pod: ${POD}${NC}"

PING_RESULT=$(kubectl exec -it -n ${NAMESPACE} ${POD} -- redis-cli -a 'UnionBigData_123.' PING)
if [[ $PING_RESULT == *"PONG"* ]]; then
  echo -e "${BRIGHT_WHITE}Redis PING successful from within the Pod.${NC}"
else
  echo -e "${RED}Redis PING failed from within the Pod.${NC}"
  exit 1
fi

# Check connection to service/redis on port 6379
echo -e "${CYAN}Checking connection to service/redis on port 6379...${NC}"
CLUSTER_IP=$(kubectl get svc redis -n ${NAMESPACE} -o jsonpath='{.spec.clusterIP}')

if nc -zv $CLUSTER_IP 6379; then
  echo -e "${BRIGHT_WHITE}Connection to service/redis on port 6379 successful.${NC}"
else
  echo -e "${RED}Connection to service/redis on port 6379 failed.${NC}"
  exit 1
fi

# Check connection to service/redis-nodeport on port 31004
echo -e "${CYAN}Checking connection to service/redis-nodeport on port 31004...${NC}"
NODE_PORT=$(kubectl get svc redis-nodeport -n ${NAMESPACE} -o jsonpath='{.spec.ports[0].nodePort}')
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')

if nc -zv $NODE_IP $NODE_PORT; then
  echo -e "${BRIGHT_WHITE}Connection to service/redis-nodeport on port 31004 successful.${NC}"
else
  echo -e "${RED}Connection to service/redis-nodeport on port 31004 failed.${NC}"
  exit 1
fi

# Check Redis PING from the host machine
echo -e "${CYAN}Checking Redis PING from the host machine...${NC}"
HOST_PING_RESULT=$(redis-cli -h $NODE_IP -p $NODE_PORT -a 'UnionBigData_123.' PING)
if [[ $HOST_PING_RESULT == *"PONG"* ]]; then
  echo -e "${BRIGHT_WHITE}Redis PING successful from the host machine.${NC}"
else
  echo -e "${RED}Redis PING failed from the host machine.${NC}"
  exit 1
fi

echo -e "${BRIGHT_WHITE}All checks passed successfully.${NC}"
