#!/bin/bash

# Variable
CONTAINER_PATTERN="container-id-ap"
# NOT Change

# Run the container with the specified variables
docker ps -aqf "name=$CONTAINER_PATTERN" | xargs -r docker rm

echo "Containers with names starting with '$CONTAINER_PATTERN' have been deleted."
