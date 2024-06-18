#!/bin/bash

# Define color codes
YELLOW="\033[1;33m"
RED="\033[1;31m"
GREEN="\033[1;32m"
NO_COLOR="\033[0m"

INDENT="  "

# Define backup directory
BACKUP_DIR="/etc/kubernetes/manifests-backup"

# Usage function
usage() {
  echo -e "${YELLOW}Usage: $0 [-v VERSION] SERVER_1 [SERVER_2 ...]${NO_COLOR}"
  echo -e "${YELLOW}If no version is specified, the oldest backup will be restored.${NO_COLOR}"
}

# Parse options for version
VERSION=""
while getopts ":v:" opt; do
  case ${opt} in
    v)
      VERSION=${OPTARG}
      ;;
    \?)
      echo -e "${RED}Invalid option: -$OPTARG${NO_COLOR}" >&2
      usage
      exit 1
      ;;
    :)
      echo -e "${RED}Option -$OPTARG requires an argument.${NO_COLOR}" >&2
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Check if the script has at least one argument
if [ "$#" -lt 1 ]; then
  echo -e "${RED}Error: At least one server is required.${NO_COLOR}"
  usage
  exit 1
fi

# Get the server list from the arguments
SERVER_LIST=("$@")

# Function to reset kube-scheduler configuration
reset_kube_scheduler_config() {
  local server="$1"
  local backup_file

  if [[ -z "$VERSION" ]]; then
    # If no version was specified, find the oldest backup version
    backup_file=$(ssh -o BatchMode=yes -o ConnectTimeout=5 "$server" "find ${BACKUP_DIR} -name 'kube-scheduler.v*.yaml' -printf '%T+ %p\n' | sort | head -n 1 | cut -d' ' -f2-")
  else
    # Find the backup file with the specified version
    backup_file=$(ssh -o BatchMode=yes -o ConnectTimeout=5 "$server" "find ${BACKUP_DIR} -name 'kube-scheduler.v${VERSION}.*.yaml' | sort | head -n 1")
  fi

  # Check if backup file is found
  if [[ -z "$backup_file" ]]; then
    echo -e "${INDENT}${RED}No backup file found for version ${VERSION} on server ${server}.${NO_COLOR}"
    ((fail_count++))
    return
  fi

  # Reset the kube-scheduler configuration using the backup file
  echo -e "${INDENT}${YELLOW}Restoring kube-scheduler configuration from ${backup_file} on server ${server}...${NO_COLOR}"
  if ssh -o BatchMode=yes -o ConnectTimeout=5 "$server" "cp ${backup_file} /etc/kubernetes/manifests/kube-scheduler.yaml"; then
    echo -e "${INDENT}${GREEN}Successfully restored kube-scheduler configuration on server ${server}.${NO_COLOR}"
    ((success_count++))
  else
    echo -e "${INDENT}${RED}Failed to restore kube-scheduler configuration on server ${server}.${NO_COLOR}"
    ((fail_count++))
  fi
}

# Initialize success and fail counters
success_count=0
fail_count=0

# Perform the reset operation on each server
for server in "${SERVER_LIST[@]}"; do
  echo -e "${YELLOW}Processing server ${server}...${NO_COLOR}"

  # Check SSH connection
  if ssh -o BatchMode=yes -o ConnectTimeout=5 "$server" exit; then
    reset_kube_scheduler_config "$server"
  else
    echo -e "${INDENT}${RED}Cannot establish SSH connection to server ${server}. Skipping reset.${NO_COLOR}"
    ((fail_count++))
  fi
done

# Print summary
echo -e "${INDENT}${YELLOW}Reset summary: ${success_count} succeeded, ${fail_count} failed.${NO_COLOR}"

