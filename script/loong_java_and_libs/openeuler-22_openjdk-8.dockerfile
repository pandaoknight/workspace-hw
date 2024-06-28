# Use the specified base image
FROM lcr.loongnix.cn/openeuler/openeuler:22.03-LTS

#
RUN dnf update

#
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'
ENV TZ=Asia/Shanghai
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.372.b07-1.oe2203.loongarch64/jre

#
RUN dnf install -y java-1.8.0-openjdk rocksdbjni 

# Set the entry point for the container
ENTRYPOINT ["/bin/bash"]

