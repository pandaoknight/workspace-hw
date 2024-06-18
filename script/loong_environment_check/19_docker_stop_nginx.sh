#!/bin/bash

# Function to stop and remove docker container
stop_nginx_container() {
  local index=$1

  container_name="nginx_instance_$index"
  
  docker stop $container_name
  docker rm $container_name

  echo "Stopped and removed $container_name"
}

# Stop and remove 12 nginx instances
for i in {0..11}; do
  stop_nginx_container $i
done

echo "All nginx instances have been stopped and removed."

