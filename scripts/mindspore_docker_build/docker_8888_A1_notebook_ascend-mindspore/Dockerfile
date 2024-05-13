FROM ascendhub.huawei.com/public-ascendhub/ascend-mindspore:23.0.0-A1-ubuntu18.04

LABEL maintainer="chenxing@unionbigdata.com"

USER root
RUN apt-get update && apt-get install libsqlite3-dev

# Infrastructure: jupyter notebook
RUN pip3 install pysqlite3==0.5.2
RUN pip3 install notebook==6.5.6
RUN sed -i 's/pysqlite2/pysqlite3/g' /usr/local/python3.7.5/lib/python3.7/site-packages/notebook/services/sessions/sessionmanager.py

# Utils
RUN apt-get install tree htop

# Business Lib:
RUN pip3 install download==0.3.5
RUN pip3 install opencv-python==4.9.0.80
RUN pip3 install matplotlib==3.5.3

COPY --chown=HwHiAiUser:HwHiAiUser mindspore_fcn8s/ /home/HwHiAiUser/mindspore_fcn8s/
COPY --chown=HwHiAiUser:HwHiAiUser resnet50/ /home/HwHiAiUser/resnet50/

USER HwHiAiUser

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''", "--NotebookApp.tornado_settings={\"headers\":{\"Content-Security-Policy\":\"frame-ancestors *\"}}"]
