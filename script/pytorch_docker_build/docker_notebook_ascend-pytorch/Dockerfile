FROM ascendhub.huawei.com/public-ascendhub/ascend-pytorch:23.0.0-A2-1.11.0-ubuntu18.04

LABEL maintainer="chenxing@unionbigdata.com"

USER root
RUN apt-get update && apt-get install libsqlite3-dev

RUN pip3 install pysqlite3
RUN pip3 install notebook
RUN sed -i 's/pysqlite2/pysqlite3/g' /usr/local/python3.7.5/lib/python3.7/site-packages/notebook/services/sessions/sessionmanager.py

USER HwHiAiUser

EXPOSE 30081

WORKDIR /home/HwHiAiUser/

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=30081", "--no-browser", "--NotebookApp.password='argon2:$argon2id$v=19$m=10240,t=10,p=8$TjGr98G0l8p8ymGzHWoz5A$EKR1g8F49POgjF9qoBUq290rb7sAf9pXuh/YGxcvaro'"]
