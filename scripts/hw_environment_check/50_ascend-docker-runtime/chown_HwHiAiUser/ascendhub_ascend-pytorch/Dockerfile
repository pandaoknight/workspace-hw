FROM ascendhub.huawei.com/public-ascendhub/ascend-pytorch:23.0.RC3-1.11.0-ubuntu18.04

USER root
RUN groupmod -g 1001 HwHiAiUser && \
    usermod -u 1001 -g 1001 HwHiAiUser

RUN chown -R 1001:1001 /home/HwHiAiUser
USER HwHiAiUser
