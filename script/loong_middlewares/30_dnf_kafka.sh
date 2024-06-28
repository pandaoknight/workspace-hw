#!/bin/bash

# Define color codes
CYAN="\x1b[36m"          # Cyan for the prompt
BRIGHT_WHITE="\x1b[97m"  # Bright white for the header
BLUE="\x1b[1;36m"        # Blue for USSD levels
RED="\x1b[31m"           # Red for errors
NC="\x1b[0m"             # No color (reset to default)

#
echo -e "${CYAN}Kafka version from dnf ...${NC}"
dnf search kafka

dnf install kafka --assumeno

#
echo -e "${CYAN} Autodeploy files ...${NC}"
grep -r kafka -l --color=always /home/workspace-hw/src/autodeploy

echo -e "${CYAN} Autodeploy !*.sql configs ...${NC}"
find /home/workspace-hw/src/autodeploy -type f ! -name "*.sql" -exec grep --color=always -r "kafka" {} +

#
