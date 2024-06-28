#!/bin/bash

# Define color codes
CYAN="\x1b[36m"          # Cyan for the prompt
BRIGHT_WHITE="\x1b[97m"  # Bright white for the header
BLUE="\x1b[1;36m"        # Blue for USSD levels
RED="\x1b[31m"           # Red for errors
NC="\x1b[0m"             # No color (reset to default)

echo -e "${CYAN}Createing topic: test ...${NC}"
/opt/kafka/bin/kafka-topics.sh --create --topic test --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

echo -e "${CYAN}Listing topic: test ...${NC}"
/opt/kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092
