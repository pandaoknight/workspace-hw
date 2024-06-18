#!/bin/bash

# Define GA_ROOT
GA_ROOT=$(dirname "$(realpath "$0")")

# Define color codes
YELLOW="\033[1;33m"
RED="\033[1;31m"
CYAN="\033[1;36m"
NO_COLOR="\033[0m"

# Check if the script has at least two arguments
if [ "$#" -lt 2 ]; then
  echo -e "${RED}Usage: $0 GPU_ADMISSION_IMAGE SERVER_1 [SERVER_2 ...]${NO_COLOR}"
  exit 1
fi

# Get the image and server list from the arguments
GPU_ADMISSION_IMAGE="$1"
shift
SERVER_LIST=("$@")

# Function to uninstall the current gpu-admission
uninstall_gpu_admission() {
  local success_count=0
  local fail_count=0
  local skipped_count=0

  for server in "${SERVER_LIST[@]}"; do
    echo -e "  ${YELLOW}Uninstalling static-gpu-admission on ${server}...${NO_COLOR}"

    # Check SSH connection
    if ! ssh -o BatchMode=yes -o ConnectTimeout=5 "$server" exit; then
      echo -e "  ${RED}Cannot establish SSH connection to ${server}. Failed uninstallation.${NO_COLOR}"
      ((failed_count++))
      continue
    fi

    # Check if the static pod manifest exists
    if ! ssh "$server" "[ -f /etc/kubernetes/manifests/static-gpu-admission.yaml ]"; then
      echo -e "  No static-gpu-admission manifest found on ${server}. Skipping."
      ((skipped_count++))
      continue
    fi

    # Remove the static pod manifest
    if ssh "$server" "rm -f /etc/kubernetes/manifests/static-gpu-admission.yaml"; then
      echo -e "  Removed static-gpu-admission from ${server}."
      ((success_count++))
    else
      echo -e "  ${RED}Failed to remove static-gpu-admission from ${server}.${NO_COLOR}"
      ((fail_count++))
    fi
  done

  echo -e "${YELLOW}Uninstallation summary: ${success_count} succeeded, ${fail_count} failed, ${skipped_count} skipped.${NO_COLOR}"
}

# Function to install gpu-admission
install_gpu_admission() {
  local success_count=0
  local fail_count=0
  local current_timestamp=$(date +%Y-%m-%dT%H-%M-%SZ)

  for server in "${SERVER_LIST[@]}"; do
    echo -e "  ${CYAN}Installing static-gpu-admission on ${server}...${NO_COLOR}"

    # Replace the image in the yaml file with the provided GPU_ADMISSION_IMAGE
    sed -e "s|GPU_ADMISSION_IMAGE|${GPU_ADMISSION_IMAGE}|g" \
        -e "s|CREATED_AT|${current_timestamp}|g" \
        static-gpu-admission.yaml > "static-gpu-admission-${server}.yaml"

    # Copy the modified yaml file to the server
    if scp -o BatchMode=yes "static-gpu-admission-${server}.yaml" "${server}:/etc/kubernetes/manifests/static-gpu-admission.yaml"; then
      echo -e "  Installed static-gpu-admission on ${server}."
      ((success_count++))
    else
      echo -e "  ${RED}Failed to install static-gpu-admission on ${server}.${NO_COLOR}"
      ((fail_count++))
    fi

    # Clean up the temporary yaml file
    rm -f "static-gpu-admission-${server}.yaml"
  done

  echo -e "${CYAN}Installation summary: ${success_count} succeeded, ${fail_count} failed.${NO_COLOR}"
}

# Execution starts here
echo -e "${YELLOW}GA-UNINSTALL(1/1) Uninstalling existing gpu-admission static pods${NO_COLOR}"
uninstall_gpu_admission

echo -e "${CYAN}GA-INSTALL(1/1) Installing gpu-admission static pods${NO_COLOR}"
install_gpu_admission

# Display the status of the static pods as a phase action
echo -e "${CYAN}Displaying the status of static-gpu-admission pods:${NO_COLOR}"
kubectl get pods -n kube-system -l app=static-gpu-admission

echo -e "${CYAN}gpu-admission installation completed.${NO_COLOR}"
echo -e "${CYAN}You can use following command to check the state of gpu-admission:${NO_COLOR}"
echo ""
echo "  kubectl get pods -n kube-system -l app=static-gpu-admission"
echo ""


