#!/bin/bash

# Define color codes
CYAN="\x1b[36m"          # Cyan for the prompt
BRIGHT_WHITE="\x1b[97m"  # Bright white for the header
BLUE="\x1b[1;36m"        # Blue for USSD levels
NC="\x1b[0m"             # No color (reset to default)

NAMESPACE="icaplat-sit"

#
echo -e "${CYAN}Check pod ...${NC}"
POD=$(kubectl get pod -n ${NAMESPACE} -l app=redis -o jsonpath='{.items[0].metadata.name}')

if [ -z "$POD" ]; then
  echo -e "${CYAN}No Redis pod found${NC}"
  exit 1
fi

echo -e "${BRIGHT_WHITE}Selected Pod: ${POD}${NC}"

#
echo -e "${CYAN}Exec redis-cli ...${NC}"
kubectl exec -it -n ${NAMESPACE} ${POD} -- redis-cli -a 'UnionBigData_123.'
