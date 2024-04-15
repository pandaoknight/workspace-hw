#!/bin/bash

# Variable
CONTAINER_ID="container-id-ap1"
#
#NAMESPACE="k8s.io"

# Enter the running container
docker exec -it ${CONTAINER_ID} /bin/bash
