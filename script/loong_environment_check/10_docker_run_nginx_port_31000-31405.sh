#!/bin/bash

# Docker image to be used
IMAGE="lcr.loongnix.cn/library/nginx:1.23.1-alpine"

# Ports to be mapped
PORTS=(31000 31001 31002 31003 31004 31005 31400 31401 31402 31403 31404 31405)

# Function to run docker container
run_nginx_container() {
  local index=$1
  local port=${PORTS[$index]}

  docker run -d \
    --name nginx_instance_$index \
    -p $port:80 \
    $IMAGE

  echo "Started nginx_instance_$index: Mapped local port $port to container port 80"
}

# Start 12 nginx instances
for i in ${!PORTS[@]}; do
  run_nginx_container $i
done

echo "All nginx instances have been started and port mapping is complete."
