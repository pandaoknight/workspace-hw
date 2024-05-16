#!/bin/bash

# Define color codes
YELLOW='\x1b[1;33m'
RED='\x1b[0;31m'
NC='\x1b[0m' # No Color

# Fetch the list of pods in the specified namespace
PODS=$(kubectl get pods -n icaplat-sit-estimate-model -o custom-columns=:metadata.name)

# Convert PODS to an array
POD_ARRAY=($PODS)

# Check the number of pods
NUM_PODS=${#POD_ARRAY[@]}

if [[ $NUM_PODS -eq 0 ]]; then
    # No pods found, display error message
    echo -e "${RED}Error: No pods found in the namespace 'icaplat-sit-estimate-model'.${NC}"
elif [[ $NUM_PODS -eq 1 ]]; then
    # Only one pod found, display its logs
    echo "Displaying logs for the pod: ${POD_ARRAY[0]}"
    kubectl logs ${POD_ARRAY[0]} -n icaplat-sit-estimate-model
else
    # More than one pod found, display warning and logs for the first pod
    echo -e "${YELLOW}Warning: More than one pod found. Displaying logs for only the first pod.${NC}"
    echo "Pods found:"
    for pod in "${POD_ARRAY[@]}"; do
        echo $pod
    done
    echo "Displaying logs for the pod: ${POD_ARRAY[0]}"
    kubectl logs ${POD_ARRAY[0]} -n icaplat-sit-estimate-model
fi
