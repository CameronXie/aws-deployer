FROM docker:latest

ENV NODE_VERSION=12.15.0-r1
ENV GLIBC_VERSION=2.31-r0

# https://github.com/aws/aws-cli/issues/4685
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
    && wget -q https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
    && apk add --no-cache \
        glibc-${GLIBC_VERSION}.apk \
        glibc-bin-${GLIBC_VERSION}.apk \
        nodejs=${NODE_VERSION} \
        npm \
        jq \
        make \
    && wget -q -O awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        glibc-${GLIBC_VERSION}.apk \
        glibc-bin-${GLIBC_VERSION}.apk \
        awscliv2.zip \
        aws \
        /var/cache/apk/* \
    && aws --version