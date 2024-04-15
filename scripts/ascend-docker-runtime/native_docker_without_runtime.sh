#!/bin/bash
docker run -it -u root \
      --device=/dev/davinci2 \
      --device=/dev/davinci_manager \
      --device=/dev/devmm_svm \
      --device=/dev/hisi_hdc \
      -v /usr/local/Ascend/driver:/usr/local/Ascend/driver \
      -v /usr/local/Ascend/add-ons/:/usr/local/Ascend/add-ons/ \
      -v /usr/local/sbin/:/usr/local/sbin/ \
      -v /usr/local/sbin/npu-smi:/usr/local/sbin/npu-smi \
      -v /var/log/npu/conf/slog/slog.conf:/var/log/npu/conf/slog/slog.conf \
      -v /var/log/npu/slog/:/var/log/npu/slog \
      -v /var/log/npu/profiling/:/var/log/npu/profiling \
      -v /var/log/npu/dump/:/var/log/npu/dump \
      -v /var/log/npu/:/usr/slog \
      -v /root/zj:/root/zj \
      -v /data/szl1160710/src/samples/:/root/samples \
      ascendhub.huawei.com/public-ascendhub/ascend-pytorch:23.0.RC3-1.11.0-ubuntu18.04 /bin/bash
