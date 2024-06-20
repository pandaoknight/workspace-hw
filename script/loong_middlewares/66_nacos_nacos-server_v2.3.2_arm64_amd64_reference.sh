#!/bin/bash

# Define cyan print function
print_cyan() {
  echo -e "\x1b[36m$1\x1b[0m"
}

# Pull and tag images for different platforms
docker pull --platform=linux/arm64 nacos/nacos-server:v2.3.2-slim
docker tag nacos/nacos-server:v2.3.2-slim nacos/nacos-server:v2.3.2-slim-arm64

docker pull --platform=linux/amd64 nacos/nacos-server:v2.3.2-slim
docker tag nacos/nacos-server:v2.3.2-slim nacos/nacos-server:v2.3.2-slim-amd64

docker pull --platform=linux/amd64 nacos/nacos-server:v2.3.2
docker tag nacos/nacos-server:v2.3.2 nacos/nacos-server:v2.3.2-amd64


# Print history for tagged images
print_cyan "History for nacos/nacos-server:v2.3.2-slim-arm64"
print_cyan "\`\`\`"
docker history nacos/nacos-server:v2.3.2-slim-arm64 --no-trunc -H --format json
print_cyan "\`\`\`"

print_cyan "History for nacos/nacos-server:v2.3.2-slim-amd64"
print_cyan "\`\`\`"
docker history nacos/nacos-server:v2.3.2-slim-amd64 --no-trunc -H --format json
print_cyan "\`\`\`"

print_cyan "History for nacos/nacos-server:v2.3.2-amd64"
print_cyan "\`\`\`"
docker history nacos/nacos-server:v2.3.2-amd64 --no-trunc -H --format json
print_cyan "\`\`\`"

