#!/bin/bash -x

# Ref: https://www.chenshaowen.com/blog/basic-usage-of-npu-smi.html

npu-smi info -t board
npu-smi info -t board -i 2
npu-smi info -t board -i 2 -c 0
npu-smi info -t board -i 2 -c 1
npu-smi info -t memory -i 2
npu-smi info -t memory -i 2 -c 0
npu-smi info -t memory -i 2 -c 1
npu-smi info -t product -i 2
npu-smi info -t product -i 2 -c 0
npu-smi info -t product -i 2 -c 1
