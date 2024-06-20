#!/bin/bash

# Define color codes
CYAN="\x1b[36m"          # Cyan for the prompt
BRIGHT_WHITE="\x1b[97m"  # Bright white for the value
NC="\x1b[0m"             # No color (reset to default)

# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
PROJECT_ROOT=$SCRIPT_DIR
echo -e "${CYAN}PROJECT_ROOT:${BRIGHT_WHITE} $PROJECT_ROOT${NC}"
WORKSPACE_ROOT=$(realpath "$SCRIPT_DIR/../..")
echo -e "${CYAN}WORKSPACE_ROOT:${BRIGHT_WHITE} $WORKSPACE_ROOT${NC}"

#
grep MYSQL -A1 --color=always -r "${WORKSPACE_ROOT}/src/autodeploy"
