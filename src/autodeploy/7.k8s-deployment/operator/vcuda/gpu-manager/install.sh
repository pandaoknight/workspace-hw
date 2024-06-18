#!/bin/bash

# Define GM_ROOT
GM_ROOT=$(dirname "$(realpath "$0")")

# Define color codes
CYAN="\033[1;36m"
NO_COLOR="\033[0m"

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo -e "${CYAN}This script must be run as root${NO_COLOR}" 1>&2
   exit 1
fi

# USAGE message
USAGE="Usage: $0 <gpu-manager-image> <container-runtime> <container-runtime-endpoint>\nExample:\n\n  $0 harbor.xnunion.com/cpyfreg/utils/cx/gpu-manager:1.1.4-vcuda-1.0.4.2 docker /var/run/containerd/containerd.sock\n"

# Check if all required parameters are provided
if [ "$#" -ne 3 ]; then
    echo -e "${CYAN}${USAGE}${NO_COLOR}" 1>&2
    exit 1
fi

# Load variables from the previous script or environment
ICAPLAT_K8S_IMAGE_VCUDA_GPU_MANAGER="$1"
CONTAINER_RUNTIME="$2"
CONTAINER_RUNTIME_ENDPOINT="$(echo "$3" | tail -n1)"
CONTAINER_RUNTIME_ENDPOINT="${CONTAINER_RUNTIME_ENDPOINT#unix://}"

# Step 1: Print iamge and runtime information
echo -e "${CYAN}GM-INSTALL(1/7) Container runtime: $CONTAINER_RUNTIME${NO_COLOR}"
echo -e "  Gpu-manager image: $ICAPLAT_K8S_IMAGE_VCUDA_GPU_MANAGER${NO_COLOR}"
echo -e "  Container runtime: $CONTAINER_RUNTIME${NO_COLOR}"
echo -e "  Container runtime endpoint: $CONTAINER_RUNTIME_ENDPOINT${NO_COLOR}"

# Step 2: Call uninstall script to clean up previous installations
echo -e "${CYAN}GM-INSTALL(2/7) Running uninstall script...${NO_COLOR}"
bash ./uninstall.sh

# Step 3: Call script to create service account and clusterrolebinding
echo -e "${CYAN}GM-INSTALL(3/7) Creating service account and clusterrolebinding...${NO_COLOR}"
bash ./create_sa.sh

# Step 4: Prepare the DaemonSet yaml by substituting the placeholders with the actual values
echo -e "${CYAN}GM-INSTALL(4/7) Preparing gpu-manager DaemonSet yaml...${NO_COLOR}"
DAEMONSET_YAML=$(cat gpu-manager.template.yaml | \
    sed "s|ICAPLAT_K8S_IMAGE_VCUDA_GPU_MANAGER|$ICAPLAT_K8S_IMAGE_VCUDA_GPU_MANAGER|g" | \
    sed "s|CONTAINER_RUNTIME_ENDPOINT|$CONTAINER_RUNTIME_ENDPOINT|g")

# Step 4: Apply the DaemonSet to the Kubernetes cluster
echo -e "${CYAN}GM-INSTALL(4/7) Applying gpu-manager DaemonSet...${NO_COLOR}"
echo "$DAEMONSET_YAML" | kubectl create -f -

# Step 5: Start the gpu-manager service
echo -e "${CYAN}GM-INSTALL(5/7) Starting gpu-manager service...${NO_COLOR}"
kubectl create -f gpu-manager-svc.yaml

# Step 6: Check the status of the ServiceAccount
echo -e "${CYAN}GM-INSTALL(6/7) Checking ServiceAccount status...${NO_COLOR}"
kubectl get sa gpu-manager -n kube-system

# Step 7: Check the status of the DaemonSet and Service
echo -e "${CYAN}GM-INSTALL(7/7) Checking DaemonSet and Service status...${NO_COLOR}"
kubectl get -f gpu-manager.template.yaml
kubectl get -f gpu-manager-svc.yaml

echo -e "${CYAN}gpu-manager installation completed.${NO_COLOR}"
echo -e "${CYAN}You can use following command to check the state of gpu-manager:${NO_COLOR}"
echo ""
echo "  kubectl get -f ${GM_ROOT}/gpu-manager.template.yaml"
echo ""

echo -e "${CYAN}AFTER RUNNING A VCUDA POD. You can use following command to check response of the service for prometheus:${NO_COLOR}"
echo ""
echo "  kubectl proxy & PROXY_PID=\$!; sleep 2; curl -s http://127.0.0.1:8001/api/v1/namespaces/kube-system/services/gpu-manager-metric:5678/proxy/metric; kill \$PROXY_PID"
echo ""
