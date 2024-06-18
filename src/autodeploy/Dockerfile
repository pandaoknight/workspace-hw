# from https://github.com/docker-library/postgres/blob/2f6878ca854713264ebb27c1ba8530c884bcbca5/14/alpine/Dockerfile
# goto postgres folder build with command: docker build -t icaplat/baseon/postgres:14-alpine3.16 .
FROM postgres:14.11-bullseye

ENV LANG='zh_CN.utf8' LANGUAGE='zh_CN:zh' LC_ALL='zh_CN.utf8'

ENV TIMESCALEDB_TELEMETRY off
ENV TS_TUNE_MAX_CONNS 5120

RUN set -ex \
    && apt-get update \
    && apt-get install locales locales-all \
    && rm -f /etc/localtime \
    && ln -sv /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone

COPY init-schemas.sh /docker-entrypoint-initdb.d/

RUN chmod +x /docker-entrypoint-initdb.d/init-schemas.sh
