FROM node:14-buster

ENV DOCKER_VERSION=20.10.1
ENV AWS_CLI=2.0.30

RUN apt-get update && apt install -y \
       jq \
       make \
       ca-certificates \
       openssh-client \
    && mkdir -p /tmp/build-deps \
    && cd /tmp/build-deps/ \
    && set -eux; \
       	apkArch="$(dpkg --print-architecture)"; \
       	case "$apkArch" in \
       		'x86_64' | 'amd64') \
       			dockerArch='x86_64'; \
       			;; \
       		'armhf') \
       			dockerArch='armel'; \
       			;; \
       		'armv7') \
       			dockerArch='armhf'; \
       			;; \
       		'aarch64') \
       			dockerArch='aarch64'; \
       			;; \
       		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;; \
       	esac \
    && curl "https://download.docker.com/linux/static/stable/$dockerArch/docker-${DOCKER_VERSION}.tgz" -o "docker.tgz" \
    && tar --extract \
        --file docker.tgz \
        --strip-components 1 \
        --directory /usr/local/bin/ \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI}.zip" -o "awscliv2.zip" \
    && unzip -q awscliv2.zip \
    && ./aws/install \
    && curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" \
       -o "session-manager-plugin.deb" \
    && dpkg -i session-manager-plugin.deb \
    && rm -r /tmp/build-deps/

RUN npm i -g aws-cdk
