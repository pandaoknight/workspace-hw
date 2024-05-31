FROM image.sourcefind.cn:5000/dcu/admin/base/pytorch:1.10.0-centos7.6-dtk-22.10-py38

LABEL maintainer="chenxing@unionbigdata.com"

# Infrastructure:
COPY wheels/horovod-0.22.1+git9d676e14.dtk2210-cp38-cp38-manylinux2014_x86_64.whl /tmp/horovod-0.22.1+git9d676e14.dtk2210-cp38-cp38-manylinux2014_x86_64.whl
RUN pip3 install /tmp/horovod-0.22.1+git9d676e14.dtk2210-cp38-cp38-manylinux2014_x86_64.whl

# Business Lib:
RUN pip3 install colorlog==6.8.2 \
  shapely==2.0.2 \
  jieba==0.42.1 \
  flask==3.0.3 \
  confluent-kafka==1.9.2 \
  pycocotools==2.0.7

#horovod==0.28.1

# Port Design:

CMD ["/bin/bash"]
