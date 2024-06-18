#!/bin/bash

# Define color codes
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
RED="\033[1;31m"
NO_COLOR="\033[0m"

INDENT="  "

# Define scheduler config and manifest directories
SCHEDULER_CONFIG_DIR="/etc/kubernetes/scheduler-config"
MANIFESTS_DIR="/etc/kubernetes/manifests"

# Initialize success and fail counters
success_count=0
fail_count=0

# Usage function
usage() {
  echo -e "${YELLOW}Usage: $0 KUBE_SCHEDULER_IMAGE [SERVER_1] [SERVER_2] ...${NO_COLOR}"
}

# Check for the required image argument and at least one server
if [ "$#" -lt 2 ]; then
  echo -e "${RED}Error: KUBE_SCHEDULER_IMAGE and at least one server are required.${NO_COLOR}"
  usage
  exit 1
fi

# First argument is the image, the rest are the servers
KUBE_SCHEDULER_IMAGE="$1"
shift
SERVER_LIST=("$@")

# Function to setup kube-scheduler on all servers
setup_kube_scheduler() {
  local server="$1"

  echo "${INDENT}Checking SSH access to ${server}..."
  # Check SSH connection
  if ! ssh -o BatchMode=yes -o ConnectTimeout=5 "$server" exit; then
    echo -e "${RED}Cannot establish SSH connection to ${server}. Skipping this server.${NO_COLOR}"
    ((fail_count++))
    return
  fi

  echo "${INDENT}Creating scheduler config directory on ${server}..."
  # Create scheduler-config directory if it doesn't exist
  if ! ssh "$server" "mkdir -p ${SCHEDULER_CONFIG_DIR}"; then
    echo -e "${RED}Failed to create scheduler-config directory on ${server}. Skipping this server.${NO_COLOR}"
    ((fail_count++))
    return
  fi

  echo "${INDENT}Copying scheduler config to ${server}..."
  # Copy the scheduler config file to the server
  if ! scp kubescheduler-config_v1beta3.yaml "$server:${SCHEDULER_CONFIG_DIR}/kubescheduler-config_v1beta3.yaml"; then
    echo -e "${RED}Failed to copy scheduler config to ${server}. Skipping this server.${NO_COLOR}"
    ((fail_count++))
    return
  fi

  echo "${INDENT}Deploying kube-scheduler static pod on ${server}..."
  # Replace the KUBE_SCHEDULER_IMAGE placeholder and deploy the kube-scheduler static pod
  if ! sed "s|KUBE_SCHEDULER_IMAGE|$KUBE_SCHEDULER_IMAGE|g" kube-scheduler_v1beta3.yaml | \
     ssh "$server" "cat > ${MANIFESTS_DIR}/kube-scheduler.yaml"; then
    echo -e "${RED}Failed to deploy kube-scheduler on ${server}. Skipping this server.${NO_COLOR}"
    ((fail_count++))
    return
  fi

  echo "${INDENT}Kube-scheduler deployed successfully on ${server}."
  ((success_count++))
}

# Start the backup process
echo -e "${YELLOW}KS-BACKUP(1/3) Backing up existing kube-scheduler configuration...${NO_COLOR}"
bash ./backup.sh "${SERVER_LIST[@]}" # Assuming backup.sh is in the same directory and executable

# Setup kube-scheduler on all servers
for server in "${SERVER_LIST[@]}"; do
  echo -e "${CYAN}KS-INSTALL(2/3) Setting up kube-scheduler on ${server}...${NO_COLOR}"
  setup_kube_scheduler "$server"
done

# Print summary
echo -e "${CYAN}Deployment summary: ${success_count} succeeded, ${fail_count} failed.${NO_COLOR}"

echo -e "${CYAN}kube-scheduler update completed.${NO_COLOR}"
echo -e "${CYAN}You can use following command to check the state of kube-scheduler:${NO_COLOR}"
echo ""
echo "  kubectl get pod -n kube-system -l component=kube-scheduler"
echo ""

