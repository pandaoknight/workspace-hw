#!/bin/bash

# Variables
CONTAINER_ID="container-id-ap1"
NAMESPACE="k8s.io"

# Function to check an item
check_item() {
    local item=$1
    local description=$2
    echo -e "\033[0;36mChecking: $description\033[0m"  # Cyan color output
    #ctr -n ${NAMESPACE} task exec -t --exec-id check-${RANDOM} ${CONTAINER_ID} /bin/bash -c "[ -e $item ] && echo 'Exists: $item' || echo 'Missing: $item'" 2>/dev/null
    ctr -n ${NAMESPACE} task exec -t --exec-id check-${RANDOM} ${CONTAINER_ID} /bin/bash -c "ls -al $item" 2>/dev/null
}

# Check /dev/davinciX devices
#for i in $(seq 0 9); do
for i in $(seq 2 2); do
    check_item "/dev/davinci$i" "NPU device /dev/davinci$i"
done

# Check other device files
check_item "/dev/davinci_manager" "Management device /dev/davinci_manager"
check_item "/dev/devmm_svm" "Management device /dev/devmm_svm"
check_item "/dev/hisi_hdc" "Management device /dev/hisi_hdc"

# Check directories and files
check_item "/usr/local/Ascend/driver/lib64" "Driver directory /usr/local/Ascend/driver/lib64"
check_item "/usr/local/Ascend/driver/include" "Driver directory /usr/local/Ascend/driver/include"
check_item "/usr/local/Ascend/driver/tools" "Driver directory /usr/local/Ascend/driver/tools"
check_item "/usr/local/dcmi" "DCMI directory /usr/local/dcmi"
check_item "/usr/local/bin/npu-smi" "npu-smi tool /usr/local/bin/npu-smi"

echo -e "\033[0;32mAll checks complete.\033[0m"  # Green color indicating completion

