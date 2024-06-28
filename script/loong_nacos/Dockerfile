# Use the specified base image
FROM harbor.xnunion.com/lcr/openeuler-22_openjdk-8

# Set environment variables
ENV LANG=C.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=C.UTF-8 \
    MODE=standalone \
    PREFER_HOST_MODE=ip \
    BASE_DIR=/home/nacos \
    CLASSPATH=.:/home/nacos/conf: \
    CLUSTER_CONF=/home/nacos/conf/cluster.conf \
    FUNCTION_MODE=all \
    NACOS_USER=nacos \
    JVM_XMS=1g \
    JVM_XMX=1g \
    JVM_XMN=512m \
    JVM_MS=128m \
    JVM_MMS=320m \
    NACOS_DEBUG=n \
    TOMCAT_ACCESSLOG_ENABLED=false \
    TZ=Asia/Shanghai

# Set the working directory
WORKDIR /home/nacos

# Copy the Nacos server files from the host
COPY nacos /home/nacos

# Grant execute permission to the startup script
RUN chmod +x /home/nacos/bin/startup.sh

# Create log directory and symbolic links for log output
RUN mkdir -p /home/nacos/logs \
    && cd /home/nacos/logs \
    && touch start.out \
    && ln -sf /dev/stdout start.out \
    && ln -sf /dev/stderr start.out

# Expose the necessary port
EXPOSE 8848

# Set the entry point for the container
ENTRYPOINT ["bin/docker-startup.sh"]

