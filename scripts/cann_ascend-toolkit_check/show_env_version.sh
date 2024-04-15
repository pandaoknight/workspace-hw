#!/bin/bash

# Define cyan color for prompts
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Displaying environment variables that contain "ASCEND"
echo -e "${CYAN}Displaying environment variables that contain 'ASCEND':${NC}"
env | grep ASCEND
echo

# Displaying the content of version.info file
echo -e "${CYAN}Displaying the content of version.info file in /usr/local/Ascend/ascend-toolkit/latest/fwkacllib:${NC}"
cat /usr/local/Ascend/ascend-toolkit/latest/fwkacllib/version.info
echo

# Displaying the directory structure of /usr/local/Ascend/ascend-toolkit/
echo -e "${CYAN}Displaying the directory structure of /usr/local/Ascend/ascend-toolkit/:${NC}"
tree -L 2 /usr/local/Ascend/ascend-toolkit/
echo
