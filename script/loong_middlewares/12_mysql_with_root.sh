#!/bin/bash

# Define color codes
CYAN="\x1b[36m"          # Cyan for the prompt
BRIGHT_WHITE="\x1b[97m"  # Bright white for the value
NC="\x1b[0m"             # No color (reset to default)

#
echo -e "${CYAN}Checking ...${NC}"


#
echo -e "${CYAN}Connecting to localhost mysql with User: root (po-pass: 626uug)...${NC}"
mysql -h 192.168.122.1 -P31005 -uroot -p626uug -Dnacos_config
