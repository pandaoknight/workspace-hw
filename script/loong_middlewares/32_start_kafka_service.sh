#!/bin/bash

# Define color codes
CYAN="\x1b[36m"          # Cyan for the prompt
BRIGHT_WHITE="\x1b[97m"  # Bright white for the header
BLUE="\x1b[1;36m"        # Blue for USSD levels
RED="\x1b[31m"           # Red for errors
NC="\x1b[0m"             # No color (reset to default)

# Copy kafka.service to /etc/systemd/system/
echo -e "${CYAN}Copying kafka.service to /etc/systemd/system/ ...${NC}"
cp ./systemd/kafka.service /etc/systemd/system/

# Reload systemd manager configuration
echo -e "${CYAN}Reloading systemd manager configuration ...${NC}"
systemctl daemon-reload

# Start Kafka service
echo -e "${CYAN}Starting Kafka service ...${NC}"
systemctl start kafka

# Enable Kafka service to start on boot
echo -e "${CYAN}Enabling Kafka service to start on boot ...${NC}"
systemctl enable kafka

# Check Kafka service status
echo -e "${CYAN}Checking Kafka service status ...${NC}"
systemctl status kafka

# Check if Kafka service is active
if systemctl is-active --quiet kafka; then
    echo -e "${BRIGHT_WHITE}Kafka service is running successfully.${NC}"
else
    echo -e "${RED}Failed to start Kafka service. Please check the logs for details.${NC}"
    exit 1
fi
