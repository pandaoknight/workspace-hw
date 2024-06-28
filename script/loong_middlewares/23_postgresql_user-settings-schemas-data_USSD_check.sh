#!/bin/bash

# Define color codes
CYAN="\x1b[36m"          # Cyan for the prompt
BRIGHT_WHITE="\x1b[97m"  # Bright white for the header
BLUE="\x1b[1;36m"        # Blue for USSD levels
NC="\x1b[0m"             # No color (reset to default)

# Define PostgreSQL connection details
PG_HOST="192.168.122.1"
PG_PORT="31003"
PG_USER="icaplat"
PG_PASSWORD="UnionBigData_123."

# Export the PostgreSQL password
export PGPASSWORD="${PG_PASSWORD}"

# Print the PostgreSQL USSD Checker header
echo -e "${BRIGHT_WHITE}==================================================================================${NC}"
echo -e "${BRIGHT_WHITE}                              Postgresql USSD Checker               ${NC}"
echo -e "${BRIGHT_WHITE}                      User-Settings-Schemas-Data Checker ${NC}"
echo -e "${BRIGHT_WHITE}==================================================================================${NC}"

# Checking users
echo -e "${BLUE}(1/4) Checking Users ...${NC}"
#
echo -e "${CYAN}Checking /var/lib/pgsql/data/pg_hba.conf ...${NC}"
grep -E '^(host|local|# TYPE)' /var/lib/pgsql/data/pg_hba.conf
#
echo -e "${CYAN}Checking /var/lib/pgsql/data/postgresql*.conf ...${NC}"
ls -l /var/lib/pgsql/data/postgresql*.conf
echo -e "${CYAN}Checking postgresql*.conf ...${NC}"
grep -El '(port = |listen_addresses = )' /var/lib/pgsql/data/postgre*.conf
#
echo -e "${CYAN}Connecting to localhost postgres with User: ${PG_USER} ...${NC}"
USERS=("icaplat-user" "icaplat-base" "icaplat-dataset" "icaplat-label" "icaplat-train" "icaplat-operator" "icaplat-model" "icaplat-predict" "icaplat-dispatcher" "icaplat-licadm" "icaplat-cluster")

for user in "${USERS[@]}"; do
    echo -e "${CYAN}Checking if user ${user} exists...${NC}"
    psql -h ${PG_HOST} -p ${PG_PORT} -U ${PG_USER} -d postgres -tc "SELECT 1 FROM pg_roles WHERE rolname='${user}'" | grep -q 1 || echo -e "${user} does not exist."
done

# Checking settings
echo -e "${BLUE}(2/4) Checking Settings ...${NC}"
echo -e "${CYAN}Checking max_connections and max_prepared_transactions...${NC}"
sudo -u postgres psql -p ${PG_PORT} <<-EOSQL
SHOW max_connections;
SHOW max_prepared_transactions;
EOSQL

# Checking schemas
echo -e "${BLUE}(3/4) Checking Schemas ...${NC}"
DATABASES=("icaplat-base" "icaplat-model" "icaplat-operator")

function check_schema {
    local db=$1
    local table=$2
    echo -e "${CYAN}Checking if table ${table} exists in database ${db}...${NC}"
    psql -h ${PG_HOST} -p ${PG_PORT} -U ${PG_USER} -d ${db} -tc "SELECT to_regclass('${table}')" | grep -q ${table} || echo -e "${table} does not exist in ${db}."
}

# Checking tables in icaplat-base
BASE_TABLES=("public.container_image_scene" "public.container_images" "public.compute_spec_scene" "public.compute_spec")
for table in "${BASE_TABLES[@]}"; do
    check_schema "icaplat-base" ${table}
done

# Checking tables in icaplat-model
MODEL_TABLES=("public.am_public_model" "public.workflow_public_model" "public.application" "public.workflow_application")
for table in "${MODEL_TABLES[@]}"; do
    check_schema "icaplat-model" ${table}
done

# Checking tables in icaplat-operator
OPERATOR_TABLES=("public.am_mine_operator" "public.am_public_operator" "public.am_operator_parameter" "public.public_operator" "public.output_parameter" "public.input_parameter" "public.supper_parameter" "public.mine_operator")
for table in "${OPERATOR_TABLES[@]}"; do
    check_schema "icaplat-operator" ${table}
done

# Checking data
echo -e "${BLUE}(4/4) Checking Data ...${NC}"

function check_data {
    local db=$1
    local table=$2
    echo -e "${CYAN}Checking data in table ${table} in database ${db}...${NC}"
    psql -h ${PG_HOST} -p ${PG_PORT} -U ${PG_USER} -d ${db} -c "SELECT COUNT(*) AS total_rows FROM ${table};"
    psql -h ${PG_HOST} -p ${PG_PORT} -U ${PG_USER} -d ${db} -c "SELECT relname AS table_name, n_live_tup AS row_count, pg_size_pretty(pg_relation_size(relid)) AS table_size, pg_stat_user_tables.last_vacuum AS last_vacuum, pg_stat_user_tables.last_autovacuum AS last_autovacuum, pg_stat_user_tables.last_analyze AS last_analyze, pg_stat_user_tables.last_autoanalyze AS last_autoanalyze FROM pg_stat_user_tables WHERE relname = '${table}';"
}

# Checking data in icaplat-base
for table in "${BASE_TABLES[@]}"; do
    check_data "icaplat-base" ${table}
done

# Checking data in icaplat-model
for table in "${MODEL_TABLES[@]}"; do
    check_data "icaplat-model" ${table}
done

# Checking data in icaplat-operator
for table in "${OPERATOR_TABLES[@]}"; do
    check_data "icaplat-operator" ${table}
done

echo -e "${BRIGHT_WHITE}==================================================================================${NC}"
echo -e "${BRIGHT_WHITE}                              USSD Check Complete!         ${NC}"
echo -e "${BRIGHT_WHITE}==================================================================================${NC}"

