#!/bin/bash

# URL 设为变量
URL="http://localhost:8888/"

# JSON 数据
JSON_DATA='{"byContentType": "json", "name": "John", "message": "Hello world"}'

# 使用 curl 发送 POST 请求
curl -s -X POST -H "Content-Type: application/json" -d "$JSON_DATA" $URL | jq .; echo
