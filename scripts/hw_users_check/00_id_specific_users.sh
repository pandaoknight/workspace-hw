#!/bin/bash

# Use ANSI color code for cyan and dark gray
CYAN='\033[0;36m'
DARK_GRAY='\033[1;30m'
NC='\033[0m' # No Color

# Check if specific UIDs and GIDs are free
echo -e "${CYAN}Checking if UID and GID 1000 is free for HwHiAiUser...${NC}"
getent passwd 1000
getent group 1000
echo -e "${CYAN}Checking if UID and GID 1001 is free for HwHiAiUser...${NC}"
getent passwd 1001
getent group 1001
echo -e "${CYAN}Checking if UID and GID 9000 is free for hwMindX...${NC}"
getent passwd 9000
getent group 9000
echo -e "${DARK_GRAY}===============================================================${NC}"

# Check if specific users exist
echo -e "${CYAN}Checking if user HwHiAiUser exists...${NC}"
id HwHiAiUser
echo -e "${CYAN}Checking if user ascend exists...${NC}"
id ascend
echo -e "${CYAN}Checking if user hwMindX exists...${NC}"
id hwMindX
echo -e "${DARK_GRAY}===============================================================${NC}"

# Display directory structure for specific users
echo -e "${CYAN}Displaying directory structure for /home/HwHiAiUser...${NC}"
tree -L 1 /home/HwHiAiUser
echo -e "${CYAN}Displaying directory structure for /home/ascend...${NC}"
tree -L 1 /home/ascend
echo -e "${CYAN}Displaying directory structure for /home/hwMindX...${NC}"
tree -L 1 /home/hwMindX
echo -e "${DARK_GRAY}===============================================================${NC}"

# Display directory structure for /usr/local/Ascend.bak
echo -e "${CYAN}Displaying directory structure for /usr/local/Ascend.bak...${NC}"
tree -L 2 /usr/local/Ascend
