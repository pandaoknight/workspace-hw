#!/bin/bash

# Define color codes
YELLOW='\x1b[1;33m'
RED='\x1b[0;31m'
NC='\x1b[0m' # No Color

NAMESPACE=icaplat-sit-serving-model

# Fetch the list of pods in the specified namespace
PODS=$(kubectl get pods -n ${NAMESPACE} -o custom-columns=:metadata.name)

# Convert PODS to an array
POD_ARRAY=($PODS)

# Check the number of pods
NUM_PODS=${#POD_ARRAY[@]}

if [[ $NUM_PODS -eq 0 ]]; then
    # No pods found, display error message
    echo -e "${RED}Error: No pods found in the namespace '${NAMESPACE}'.${NC}"
    exit 1
fi
if [[ $NUM_PODS -gt 1 ]]; then
    # More than one pod found, display warning and logs for the first pod
    echo -e "${YELLOW}Warning: More than one pod found. Displaying logs for only the first pod.${NC}"
    echo "Pods found:"
    for pod in "${POD_ARRAY[@]}"; do
        echo $pod
    done
fi

echo "Exec /bin/bash for the pod: ${POD_ARRAY[0]}"
kubectl exec -it ${POD_ARRAY[0]} -n ${NAMESPACE} -- /bin/bash
