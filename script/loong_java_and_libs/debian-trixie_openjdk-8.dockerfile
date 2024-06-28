# Use the specified base image
FROM lcr.loongnix.cn/library/openjdk:8-sid

# Set the entry point for the container
ENTRYPOINT ["/bin/sh"]

#
RUN apt update
