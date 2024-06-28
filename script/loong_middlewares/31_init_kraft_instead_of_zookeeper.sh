#!/bin/bash

# Define color codes
CYAN="\x1b[36m"          # Cyan for the prompt
BRIGHT_WHITE="\x1b[97m"  # Bright white for the header
BLUE="\x1b[1;36m"        # Blue for USSD levels
RED="\x1b[31m"           # Red for errors
NC="\x1b[0m"             # No color (reset to default)

#
echo -e "${CYAN}Stopping Kafka service ...${NC}"
systemctl stop kafka

#
echo -e "${CYAN}Checking Kafka port 9092|9093 and /tmp/kraft-combined-logs/ and clean ...${NC}"
netstat -apn|grep -E "9092|9093"
ls -al /tmp/kraft-combined-logs/
rm -rf /tmp/kraft-combined-logs/

#
echo -e "${CYAN}Initiating config base on Kraft ...${NC}"
cd /opt/kafka
uuid=$(./bin/kafka-storage.sh random-uuid)
echo -e "${BRIGHT_WHITE}uuid:${NC} ${uuid}"
./bin/kafka-storage.sh format -t ${uuid} -c ./config/kraft/server.properties

ls -al /tmp/kraft-combined-logs/
