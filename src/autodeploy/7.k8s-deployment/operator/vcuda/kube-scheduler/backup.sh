#!/bin/bash

# Define color codes
YELLOW="\033[1;33m"
RED="\033[1;31m"
NO_COLOR="\033[0m"

INDENT="  "

# Define backup directory
BACKUP_DIR="/etc/kubernetes/manifests-backup"

# Check if the script has at least one argument
if [ "$#" -lt 1 ]; then
  echo -e "${RED}Usage: $0 SERVER_1 [SERVER_2 ...]${NO_COLOR}"
  exit 1
fi

# Get the server list from the arguments
SERVER_LIST=("$@")

# Function to backup kube-scheduler configuration
backup_kube_scheduler_config() {
  local server="$1"
  local timestamp=$(date +"%Y%m%d%H%M%S")
  local current_version
  local new_version

  # Check and create backup directory
  create_backup_dir "$server"

  # Find the current maximum version number in the backup directory
  current_version=$(ssh -o BatchMode=yes -o ConnectTimeout=5 "$server" "ls ${BACKUP_DIR}/kube-scheduler.v*.yaml -v 2>/dev/null | tail -n 1 | grep -oP '(?<=kube-scheduler.v)\d+(?=\.)'")

  # Check if current_version is empty and notify user
  if [[ -z "$current_version" ]]; then
    new_version=1
    echo "${INDENT}No existing backup found. Creating the first backup version as kube-scheduler.v${new_version}."
  else
    new_version=$((current_version+1))
    echo "${INDENT}Found current maximum version: kube-scheduler.v${current_version}. Creating next version: kube-scheduler.v${new_version}."
  fi

  # Backup the kube-scheduler configuration
  echo "${INDENT}Backing up kube-scheduler configuration on ${server}..."
  if ssh -o BatchMode=yes -o ConnectTimeout=5 "$server" "cp /etc/kubernetes/manifests/kube-scheduler.yaml ${BACKUP_DIR}/kube-scheduler.v${new_version}.${timestamp}.yaml"; then
    echo "${INDENT}Successfully backed up kube-scheduler configuration on ${server}."
    ((success_count++))
  else
    echo "${INDENT}Failed to backup kube-scheduler configuration on ${server}."
    ((fail_count++))
  fi
}

# Function to create backup directory if it doesn't exist
create_backup_dir() {
  local server="$1"
  echo "${INDENT}Creating backup directory on ${server} if it doesn't exist..."
  ssh -o BatchMode=yes -o ConnectTimeout=5 "$server" "mkdir -p ${BACKUP_DIR}"
}

# Initialize success and fail counters
success_count=0
fail_count=0

# Iterate over each server and perform backup
for server in "${SERVER_LIST[@]}"; do
  echo -e "${INDENT}${YELLOW}Processing ${server}...${NO_COLOR}"

  # Check SSH connection
  if ssh -o BatchMode=yes -o ConnectTimeout=5 "$server" exit; then
    backup_kube_scheduler_config "$server"
  else
    echo -e "${INDENT}${RED}Cannot establish SSH connection to ${server}. Skipping backup.${NO_COLOR}"
    ((fail_count++))
  fi
done

# Print summary
echo -e "${INDENT}${YELLOW}Backup summary: ${success_count} succeeded, ${fail_count} failed.${NO_COLOR}"
