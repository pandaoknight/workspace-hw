#!/bin/bash

# Define color codes
CYAN="\x1b[36m"          # Cyan for the prompt
BRIGHT_WHITE="\x1b[97m"  # Bright white for the header
BLUE="\x1b[1;36m"        # Blue for USSD levels
RED="\x1b[31m"           # Red for errors
NC="\x1b[0m"             # No color (reset to default)

#
echo -e "${CYAN}Consumer ...${NC}"
/opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning

#
