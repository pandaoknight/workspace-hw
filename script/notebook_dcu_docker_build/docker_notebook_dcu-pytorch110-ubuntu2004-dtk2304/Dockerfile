FROM image.sourcefind.cn:5000/dcu/admin/base/pytorch:1.10.0-ubuntu20.04-dtk-23.04-py39-latest

LABEL maintainer="chenxing@unionbigdata.com"

USER root

# Infrastructure: jupyter notebook
RUN pip3 install notebook==6.5.6 ipywidgets==8.1.2

# Business Lib:

RUN useradd -m -s /bin/bash -u 1000 jovyan
USER jovyan
WORKDIR /home/jovyan/

COPY --chown=jovyan:jovyan notebooks/ /home/jovyan/notebooks/

# Start Jupyter
EXPOSE 8888

CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''", "--NotebookApp.tornado_settings={\"headers\":{\"Content-Security-Policy\":\"frame-ancestors *\"}}"]
