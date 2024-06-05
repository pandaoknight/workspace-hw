
#!/bin/bash

# Variable
CONTAINER_ID="container-id-ap1"
# NOT Change
#NAMESPACE="k8s.io"

# Run the container with the specified variables
docker rm ${CONTAINER_ID}
