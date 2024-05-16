#!/bin/bash

# URL 设为变量
URL="http://localhost:8888/"

# 表单数据
FORM_DATA="byContentType=form&name=John&message=Hello%20world"

# 使用 curl 发送 POST 请求
curl -s -X POST -d "$FORM_DATA" $URL | jq .; echo


