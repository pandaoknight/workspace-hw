
#!/bin/bash

# Variable
CONTAINER_ID="container-id-ap1"
IMAGE="docker.io/hyperdl/ascend-pytorch:23.0.RC1-ubuntu18.04"
# NOT Change
NAMESPACE="k8s.io"
RUNTIME="io.containerd.runtime.v1.linux"
DEVICES="2"

# Run the container with the specified variables
#ctr -n ${NAMESPACE} run --runtime ${RUNTIME} -t --env ${ENV_VARIABLE_NAME}=${ENV_VARIABLE_VALUE} ${IMAGE} ${CONTAINER_ID}
ctr -n ${NAMESPACE} run --runtime io.containerd.runtime.v1.linux -t --env ASCEND_VISIBLE_DEVICES=${DEVICES} ${IMAGE} ${CONTAINER_ID}
