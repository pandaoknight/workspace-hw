FROM image.sourcefind.cn:5000/dcu/admin/base/pytorch:1.10.0-centos7.6-dtk-22.10-py38-latest

LABEL maintainer="chenxing@unionbigdata.com"

USER root
RUN apt-get update && apt-get install libsqlite3-dev

# Infrastructure: jupyter notebook
RUN pip3 install pysqlite3==0.5.2
RUN pip3 install notebook==6.5.6
RUN sed -i 's/pysqlite2/pysqlite3/g' /usr/local/python3.7.5/lib/python3.7/site-packages/notebook/services/sessions/sessionmanager.py

# Business Lib:
RUN pip3 install opencv-python==4.9.0.80
RUN pip3 install matplotlib==3.5.3

USER HwHiAiUser

EXPOSE 30081

WORKDIR /home/HwHiAiUser/

#RUN source /usr/local/Ascend/ascend-toolkit/set_env.sh

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=30081", "--no-browser", "--NotebookApp.password='argon2:$argon2id$v=19$m=10240,t=10,p=8$TjGr98G0l8p8ymGzHWoz5A$EKR1g8F49POgjF9qoBUq290rb7sAf9pXuh/YGxcvaro'"]
