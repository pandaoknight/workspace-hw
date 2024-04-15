#!/bin/bash

# Variable
CONTAINER_ID="container-id-ap1"
NAMESPACE="k8s.io"

# Enter the running container
ctr -n ${NAMESPACE} task exec -t --exec-id bash ${CONTAINER_ID} /bin/bash
