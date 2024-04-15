
#!/bin/bash

# Variable
CONTAINER_ID="container-id-ap1"
# NOT Change
NAMESPACE="k8s.io"

# Run the container with the specified variables
ctr -n ${NAMESPACE} task kill ${CONTAINER_ID}
ctr -n ${NAMESPACE} task delete ${CONTAINER_ID}
ctr -n ${NAMESPACE} containers delete ${CONTAINER_ID}
