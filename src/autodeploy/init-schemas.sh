#!/bin/bash
set -e

sed -i 's/max_connections = 100/max_connections = 5120/g' $PGDATA/postgresql.conf
sed -i 's/#max_prepared_transactions = 0/max_prepared_transactions = 5120/g' $PGDATA/postgresql.conf

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL

    CREATE USER "icaplat-user" with login password 'UnionBigData!123.';
    CREATE DATABASE "icaplat-user" WITH OWNER = "icaplat-user" ENCODING = 'UTF8' CONNECTION LIMIT = -1;

    CREATE USER "icaplat-base" with login password 'UnionBigData!123.';
    CREATE DATABASE "icaplat-base" WITH OWNER = "icaplat-base" ENCODING = 'UTF8' CONNECTION LIMIT = -1;

    CREATE USER "icaplat-dataset" with login password 'UnionBigData!123.';
    CREATE DATABASE "icaplat-dataset" WITH OWNER = "icaplat-dataset" ENCODING = 'UTF8' CONNECTION LIMIT = -1;

    CREATE USER "icaplat-label" with login password 'UnionBigData!123.';
    CREATE DATABASE "icaplat-label" WITH OWNER = "icaplat-label" ENCODING = 'UTF8' CONNECTION LIMIT = -1;

    CREATE USER "icaplat-train" with login password 'UnionBigData!123.';
    CREATE DATABASE "icaplat-train" WITH OWNER = "icaplat-train" ENCODING = 'UTF8' CONNECTION LIMIT = -1;

    CREATE USER "icaplat-operator" with login password 'UnionBigData!123.';
    CREATE DATABASE "icaplat-operator" WITH OWNER = "icaplat-operator" ENCODING = 'UTF8' CONNECTION LIMIT = -1;

    CREATE USER "icaplat-model" with login password 'UnionBigData!123.';
    CREATE DATABASE "icaplat-model" WITH OWNER = "icaplat-model" ENCODING = 'UTF8' CONNECTION LIMIT = -1;

    CREATE USER "icaplat-predict" with login password 'UnionBigData!123.';
    CREATE DATABASE "icaplat-predict" WITH OWNER = "icaplat-predict" ENCODING = 'UTF8' CONNECTION LIMIT = -1;

    CREATE USER "icaplat-dispatcher" with login password 'UnionBigData!123.';
    CREATE DATABASE "icaplat-dispatcher" WITH OWNER = "icaplat-dispatcher" ENCODING = 'UTF8' CONNECTION LIMIT = -1;

    CREATE USER "icaplat-licadm" with login password 'UnionBigData!123.';
    CREATE DATABASE "icaplat-licadm" WITH OWNER = "icaplat-licadm" ENCODING = 'UTF8' CONNECTION LIMIT = -1;

    CREATE USER "icaplat-cluster" with login password 'UnionBigData!123.';
    CREATE DATABASE "icaplat-cluster" WITH OWNER = "icaplat-cluster" ENCODING = 'UTF8' CONNECTION LIMIT = -1;

EOSQL