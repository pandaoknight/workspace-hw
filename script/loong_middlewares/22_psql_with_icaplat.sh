#!/bin/bash

# Define color codes
CYAN="\x1b[36m"          # Cyan for the prompt
BRIGHT_WHITE="\x1b[97m"  # Bright white for the value
NC="\x1b[0m"             # No color (reset to default)

#
echo -e "${CYAN}Checking /var/lib/pgsql/data/pg_hba.conf ...${NC}"
tail -n20 /var/lib/pgsql/data/pg_hba.conf
# Following lines expected. 
## IPv4 local connections:
#host    all             all             0.0.0.0/0               md5
##host    all             all             127.0.0.1/32            ident
#
echo -e "${CYAN}Checking /var/lib/pgsql/data/postgresql*.conf ...${NC}"
ls -l /var/lib/pgsql/data/postgresql*.conf
echo -e "${CYAN}Checking postgresql*.conf ...${NC}"
grep -El '(port = |listen_addresses = )' /var/lib/pgsql/data/postgre*.conf


#
echo -e "${CYAN}Connecting to localhost postgres with User: icaplat (po-pass: UnionBigData_123.)...${NC}"
export PGPASSWORD='UnionBigData_123.'
psql -h 192.168.122.1 -p 31003 -U icaplat -d postgres

#psql -h 127.0.0.1 -p 31003 -U icaplat -d postgres
