#!/bin/bash

# Variable
CONTAINER_ID="container-id-ap12"

generate_timestamp() {
    date +'%y%m%d%H%M'
}

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
OUTPUT_DIR="${SCRIPT_DIR}/output"

mkdir -p ${OUTPUT_DIR} 

# Enter the running container
TIMESTAMP=$(generate_timestamp)
FILENAME="${TIMESTAMP}_npu-smi_info_watch.out"
docker exec -it ${CONTAINER_ID} npu-smi info watch | tee ${OUTPUT_DIR}/${FILENAME}
