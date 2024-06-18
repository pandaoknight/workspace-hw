#!/bin/bash

# vcuda/install.sh

# Define color codes
BLUE="\033[1;34m"
RED="\033[1;31m"
NO_COLOR="\033[0m"

INDENT="  "

# Variables for installation
GPU_MANAGER_IMAGE=""
CONTAINER_RUNTIME=""
CONTAINER_RUNTIME_ENDPOINT=""
GPU_ADMISSION_IMAGE=""
KUBE_SCHEDULER_IMAGE=""
K8S_SERVER_VERSION=""

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo -e "${RED}This script must be run as root${NO_COLOR}" 1>&2
   exit 1
fi

# Define VCUDA_ROOT and AUTODEPLOY_ROOT
VCUDA_ROOT=$(dirname "$(realpath "$0")")
AUTODEPLOY_ROOT=$(realpath "$VCUDA_ROOT/../../../")
CONFIG_FILE="${AUTODEPLOY_ROOT}/0.conf/icaplat-config.properties"

cd "${VCUDA_ROOT}"

# Print top-level variables
echo -e "${BLUE}VCUDA_ROOT: ${VCUDA_ROOT}${NO_COLOR}"
echo -e "${BLUE}AUTODEPLOY_ROOT: ${AUTODEPLOY_ROOT}${NO_COLOR}"
echo -e "${BLUE}CONFIG_FILE: ${CONFIG_FILE}${NO_COLOR}"


# Define hosts varibles at the top level for better readability
CONTROL_PLANE_HOSTS=()
NODE_INFO=()

# Function to check SSH accessibility for each control-plane host
check_ssh_accessibility() {
    for server in "${CONTROL_PLANE_HOSTS[@]}"; do
        echo -e "${INDENT}${BLUE}Checking SSH accessibility for ${server}...${NO_COLOR}"
        if ssh -o BatchMode=yes -o ConnectTimeout=5 "$server" exit 2>/dev/null; then
            echo -e "${INDENT}SSH to ${server} is accessible.${NO_COLOR}"
        else
            echo -e "${INDENT}${RED}Warning: SSH to ${server} is not accessible. Continuing without this host.${NO_COLOR}"
        fi
    done
}

# Function to get control-plane hosts
get_control_plane_hosts() {
    echo -e "${BLUE}Attempting to get control-plane node IPs...${NO_COLOR}"
    CONTROL_PLANE_HOSTS=($(kubectl get nodes -l 'node-role.kubernetes.io/control-plane=' -o=jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}'))

    # If no control-plane IPs are found, try to get master IPs
    if [ ${#CONTROL_PLANE_HOSTS[@]} -eq 0 ]; then
        echo -e "${BLUE}Attempting to get master node IPs...${NO_COLOR}"
        CONTROL_PLANE_HOSTS=($(kubectl get nodes -l 'node-role.kubernetes.io/master=' -o=jsonpath='{.items[*].status.addresses[?(@.type=="InternalIP")].address}'))
    fi

    # Check if we got any IP addresses
    if [ ${#CONTROL_PLANE_HOSTS[@]} -eq 0 ]; then
      echo -e "${RED}No control-plane or master IPs found. Exiting.${NO_COLOR}"
      exit 1
    fi

    # Print out the IPs for verification
    echo -e "${BLUE}Control-plane IPs found:${NO_COLOR}"
    printf '%s\n' "${CONTROL_PLANE_HOSTS[@]}"
}

check_config_variables() {
    echo -e "${INDENT}Checking for necessary configuration variables..."
    if [ ! -f "$CONFIG_FILE" ]; then
        echo -e "${INDENT}${RED}Configuration file does not exist: $CONFIG_FILE${NO_COLOR}" 1>&2
        exit 1
    fi

    # Define configuration variable names
    CONFIG_VARS=(
        "ICAPLAT_K8S_IMAGE_VCUDA_GPU_MANAGER"
        "ICAPLAT_K8S_IMAGE_VCUDA_GPU_ADMISSION"
        "ICAPLAT_K8S_IMAGE_VCUDA_KUBE_SCHEDULER"
    )

    # Check for each config variable in the config file and print it
    for VAR_NAME in "${CONFIG_VARS[@]}"; do
        VAR_VALUE=$(grep "^${VAR_NAME}=" "$CONFIG_FILE" | cut -d'=' -f2)
        if [ -z "$VAR_VALUE" ]; then
            echo -e "${INDENT}${RED}Configuration variable not set: ${VAR_NAME}${NO_COLOR}" 1>&2
            exit 1
        else
            echo -e "${INDENT}${VAR_NAME}=${VAR_VALUE}"
            # Assign values to the variables
            case $VAR_NAME in
                "ICAPLAT_K8S_IMAGE_VCUDA_GPU_MANAGER")
                    GPU_MANAGER_IMAGE=$VAR_VALUE
                    ;;
                "ICAPLAT_K8S_IMAGE_VCUDA_GPU_ADMISSION")
                    GPU_ADMISSION_IMAGE=$VAR_VALUE
                    ;;
                "ICAPLAT_K8S_IMAGE_VCUDA_KUBE_SCHEDULER")
                    KUBE_SCHEDULER_IMAGE=$VAR_VALUE
                    ;;
            esac
        fi
    done
    local full_image_name="${KUBE_SCHEDULER_IMAGE##*/}"
    
    # Split the image name by ':' to separate the name and the version
    IFS=':' read -ra ADDR <<< "$full_image_name"
    
    # Check if the version is provided
    if [ "${#ADDR[@]}" -eq 2 ]; then
        local image_version="${ADDR[1]}"
    else
        local image_version="latest"
    fi
    
    # Compare the versions and print the result
    if [ "${image_version}" == "${K8S_SERVER_VERSION}" ]; then
        echo -e "Version comparison passed: Docker image version is ${image_version}${NO_COLOR}"
    else
        echo -e "${RED}Version comparison failed: kube-scheduler's docker image version is ${image_version}, but K8S_SERVER_VERSION is expected to be ${K8S_SERVER_VERSION}${NO_COLOR}"
    fi
}

# Function to check Kubernetes version
check_k8s_version() {
    K8S_VERSION_INFO=$(kubectl version --output=json)
    K8S_SERVER_VERSION=$(echo "$K8S_VERSION_INFO" | python -c "import sys, json; print(json.load(sys.stdin)['serverVersion']['gitVersion'])")
    K8S_CLIENT_VERSION=$(echo "$K8S_VERSION_INFO" | python -c "import sys, json; print(json.load(sys.stdin)['clientVersion']['gitVersion'])")

    # Extract major and minor version components
    SERVER_VERSION_MAJOR=$(echo "$K8S_SERVER_VERSION" | cut -d. -f1 | sed 's/v//')
    SERVER_VERSION_MINOR=$(echo "$K8S_SERVER_VERSION" | cut -d. -f2)

    # Perform version check
    if [[ "$SERVER_VERSION_MAJOR" -ne 1 ]] || [[ "$SERVER_VERSION_MINOR" -lt 23 ]] || [[ "$SERVER_VERSION_MINOR" -gt 24 ]]; then
        echo -e "${RED}Unsupported Kubernetes server version: $K8S_SERVER_VERSION. Please use a version between 1.23 and 1.24 inclusive.${NO_COLOR}" 1>&2
        exit 1
    fi

    # Print version information
    echo -e "${INDENT}Kubernetes API server version: ${K8S_SERVER_VERSION}"
    echo -e "${INDENT}Kubernetes client version: ${K8S_CLIENT_VERSION}"
    if [[ "${K8S_SERVER_VERSION}" != "${K8S_CLIENT_VERSION}" ]]; then
        echo -e "${INDENT}${RED}Warning: Kubernetes client version does not match API server version..${NO_COLOR}"
    fi

    # Get kube-scheduler and kube-controller-manager versions
    SCHEDULER_VERSION=$(kubectl get pod -n kube-system -l component=kube-scheduler -o=jsonpath='{$.items[0].spec.containers[:1].image}' | sed 's/.*://')
    CONTROLLER_MANAGER_VERSION=$(kubectl get pod -n kube-system -l component=kube-controller-manager -o=jsonpath='{$.items[0].spec.containers[:1].image}' | sed 's/.*://')

    echo -e "${INDENT}kube-scheduler version: ${SCHEDULER_VERSION}"
    if [[ "${K8S_SERVER_VERSION}" != "${SCHEDULER_VERSION}" ]]; then
        echo -e "${INDENT}${RED}Warning: kube-scheduler version does not match API server version..${NO_COLOR}"
    fi
    echo -e "${INDENT}kube-controller-manager version: ${CONTROLLER_MANAGER_VERSION}"
    if [[ "${K8S_SERVER_VERSION}" != "${CONTROLLER_MANAGER_VERSION}" ]]; then
        echo -e "${INDENT}${RED}Warning: kube-controller-manager version does not match API server version..${NO_COLOR}"
    fi
}

# Function to determine container runtime used by Kubernetes
get_container_runtime() {
    CONTAINER_RUNTIME_ENDPOINT=$(ps -ef | grep kubelet | grep -Eo -- '--container-runtime-endpoint=\S+' | cut -d= -f2)

    if [[ -z "$CONTAINER_RUNTIME_ENDPOINT" ]]; then
        echo -e "${INDENT}${RED}Unable to determine the container runtime endpoint used by Kubernetes. Exiting.${NO_COLOR}" 1>&2
        exit 1
    fi

    echo -e "${INDENT}Container runtime endpoint: $CONTAINER_RUNTIME_ENDPOINT"

    # Determine if the container runtime is Docker based on the endpoint
    if [[ "$CONTAINER_RUNTIME_ENDPOINT" == *"cri-dockerd.sock"* ]]; then
        CONTAINER_RUNTIME="docker"
    # Determine if the container runtime is containerd based on the endpoint
    elif [[ "$CONTAINER_RUNTIME_ENDPOINT" == *"containerd.sock"* ]]; then
        CONTAINER_RUNTIME="ctr"
    else
        echo -e "${INDENT}${RED}Unrecognized container runtime endpoint: $CONTAINER_RUNTIME_ENDPOINT.${NO_COLOR}" 1>&2
        exit 1
    fi

    echo -e "${INDENT}Container runtime determined: $CONTAINER_RUNTIME"
}

# Function to retrieve all node IPs and names
get_all_node_ips_and_names() {
    echo -e "Retrieving IP addresses and names of all nodes..."
    # Read all node IPs and names into an array
    readarray -t NODE_INFO < <(kubectl get nodes -o=jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address}{" "}{.metadata.name}{"\n"}{end}')
    #NODE_INFO=($(kubectl get nodes -o=jsonpath='{range .items[*]}{.status.addresses[?(@.type=="InternalIP")].address}{" "}{.metadata.name}{"\n"}{end}'))
    
    # Print out the IPs and names for verification
    echo "All node IPs and Names:"
    for node_pair in "${NODE_INFO[@]}"; do
        echo "$node_pair"
    done
}

# Function to label nodes with GPUs
label_gpu_nodes() {
    local failed_count=0
    local gpu_node_count=0
    local non_gpu_node_count=0

    echo -e "Checking for available GPUs on all nodes..."

    for node_pair in "${NODE_INFO[@]}"; do
        # Split the node pair into IP and name
        local node_ip=$(echo "$node_pair" | cut -d' ' -f1)
        local node_name=$(echo "$node_pair" | cut -d' ' -f2)
        
        echo -e "  Checking node: $node_name ($node_ip)"

        # Check SSH connection
        if ! ssh -o BatchMode=yes -o ConnectTimeout=5 "$node_ip" exit 2>/dev/null; then
            echo -e "  Cannot establish SSH connection to $node_name ($node_ip). Skipping GPU check on this node."
            ((failed_count++))
            continue
        fi

        # Check for GPUs using nvidia-smi command
        local gpu_info
        gpu_info=$(ssh "$node_ip" 'nvidia-smi --query-gpu=gpu_name --format=csv,noheader' 2>/dev/null)

        # Act based on the presence of GPUs
        if [[ -z "$gpu_info" ]]; then
            echo -e "  No GPUs found on $node_name."
            ((non_gpu_node_count++))
        else
            echo -e "  GPUs found on $node_name:"
            echo -e "  $gpu_info"
            # Label the node with GPUs
            if kubectl label nodes "$node_name" nvidia-device-enable=enable --overwrite; then
                echo -e "  Labeled $node_name with nvidia-device-enable=enable"
                ((gpu_node_count++))
            else
                echo -e "  Failed to label $node_name with nvidia-device-enable=enable"
            fi
        fi
    done

    # Print summary
    echo -e "Summary:"
    echo -e "  Failed SSH connections: $failed_count"
    echo -e "  GPU nodes labeled: $gpu_node_count"
    echo -e "  Non-GPU nodes: $non_gpu_node_count"
}

# Function to install gpu-manager
install_gpu_manager() {
    cd gpu-manager || exit
    CONTAINER_RUNTIME_ENDPOINT="$(echo "$CONTAINER_RUNTIME_ENDPOINT" | tail -n1)"
    bash ./install.sh $GPU_MANAGER_IMAGE $CONTAINER_RUNTIME $CONTAINER_RUNTIME_ENDPOINT
    cd ..
}

# Function to install gpu-admission
install_gpu_admission() {
    cd gpu-admission || exit
    bash ./install.sh $GPU_ADMISSION_IMAGE "${CONTROL_PLANE_HOSTS[@]}"
    cd ..
}

# Function to install kube-scheduler
install_kube_scheduler() {
    cd kube-scheduler || exit
    bash ./install.sh $KUBE_SCHEDULER_IMAGE "${CONTROL_PLANE_HOSTS[@]}"
    cd ..
}

# Main installation process
echo -e "${BLUE}(1/8) Checking Kubernetes version...${NO_COLOR}"
check_k8s_version

echo -e "${BLUE}(2/8) Checking for necessary configuration variables...${NO_COLOR}"
check_config_variables

echo -e "${BLUE}(3/8) Determining container runtime...${NO_COLOR}"
get_container_runtime

echo -e "${BLUE}(4/8) Getting and checking access to control plane hosts...${NO_COLOR}"
get_control_plane_hosts
check_ssh_accessibility

echo -e "${BLUE}(5/8) Checking and labeling gpu nodes ...${NO_COLOR}"
get_all_node_ips_and_names
label_gpu_nodes

echo -e "${BLUE}(4/8) Installing gpu-manager...${NO_COLOR}"
install_gpu_manager

echo -e "${BLUE}(7/8) Installing gpu-admission...${NO_COLOR}"
install_gpu_admission

echo -e "${BLUE}(8/8) Updating kube-scheduler...${NO_COLOR}"
install_kube_scheduler

echo -e "${BLUE}vcuda components have been installed.${NO_COLOR}"

