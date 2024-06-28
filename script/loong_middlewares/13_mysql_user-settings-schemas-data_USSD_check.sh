#!/bin/bash

# Define color codes
CYAN="\x1b[36m"          # Cyan for the prompt
BRIGHT_WHITE="\x1b[97m"  # Bright white for the header
BLUE="\x1b[1;36m"        # Blue for USSD levels
NC="\x1b[0m"             # No color (reset to default)

# Define MySQL connection details
MYSQL_HOST="192.168.122.1"
MYSQL_PORT="31005"
MYSQL_USER="root"
MYSQL_PASSWORD="626uug"
MYSQL_DB="nacos_config"

# Print the MySQL USSD Checker header
echo -e "${BRIGHT_WHITE}==================================================================================${NC}"
echo -e "${BRIGHT_WHITE}                              MySQL USSD Checker               ${NC}"
echo -e "${BRIGHT_WHITE}                      User-Settings-Schemas-Data Checker ${NC}"
echo -e "${BRIGHT_WHITE}==================================================================================${NC}"

# Checking MySQL connection
echo -e "${BLUE}(1/4) Checking MySQL Connection ...${NC}"
mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT 1;" &> /dev/null
if [ $? -eq 0 ]; then
    echo -e "${CYAN}Successfully connected to MySQL server at ${MYSQL_HOST}:${MYSQL_PORT}.${NC}"
else
    echo -e "${CYAN}Failed to connect to MySQL server at ${MYSQL_HOST}:${MYSQL_PORT}.${NC}"
    exit 1
fi

# Checking users
echo -e "${BLUE}(2/4) Checking Users ...${NC}"
echo -e "${CYAN}Checking if user ${MYSQL_USER} exists...${NC}"
mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SELECT User FROM mysql.user WHERE User='${MYSQL_USER}';" | grep -q ${MYSQL_USER} || echo -e "${MYSQL_USER} does not exist."

# Checking database and tables
echo -e "${BLUE}(3/4) Checking Database and Tables ...${NC}"
echo -e "${CYAN}Checking if database ${MYSQL_DB} exists...${NC}"
mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -e "SHOW DATABASES LIKE '${MYSQL_DB}';" | grep -q ${MYSQL_DB} || echo -e "Database ${MYSQL_DB} does not exist."

TABLES=("config_info" "config_info_aggr" "config_info_beta" "config_info_tag" "config_tags_relation" "group_capacity" "his_config_info" "tenant_capacity" "tenant_info" "users" "roles" "permissions")

function check_table {
    local table=$1
    echo -e "${CYAN}Checking if table ${table} exists in database ${MYSQL_DB}...${NC}"
    mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -D ${MYSQL_DB} -e "SHOW TABLES LIKE '${table}';" | grep -q ${table} || echo -e "Table ${table} does not exist in ${MYSQL_DB}."
}

for table in "${TABLES[@]}"; do
    check_table ${table}
done

# Checking data
echo -e "${BLUE}(4/4) Checking Data ...${NC}"

function check_data {
    local table=$1
    echo -e "${CYAN}Checking data in table ${table} in database ${MYSQL_DB}...${NC}"
    mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -D ${MYSQL_DB} -e "SELECT COUNT(*) AS total_rows FROM ${table};"
    mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u ${MYSQL_USER} -p${MYSQL_PASSWORD} -D ${MYSQL_DB} -e "SELECT TABLE_NAME AS table_name, TABLE_ROWS AS row_count, DATA_LENGTH AS table_size, UPDATE_TIME AS last_update FROM information_schema.TABLES WHERE TABLE_NAME = '${table}';"
}

for table in "${TABLES[@]}"; do
    check_data ${table}
done

echo -e "${BRIGHT_WHITE}==================================================================================${NC}"
echo -e "${BRIGHT_WHITE}                              USSD Check Complete!         ${NC}"
echo -e "${BRIGHT_WHITE}==================================================================================${NC}"

