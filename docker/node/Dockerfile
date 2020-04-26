FROM docker:latest

ENV NodeVersion=12.15.0-r1

RUN apk update && apk upgrade \
    && apk add --no-cache \
            nodejs=${NodeVersion} \
            npm \
            python3 \
            python3-dev \
            gcc \
            musl-dev \
            jq \
            make \
    && pip3 --disable-pip-version-check install \
            awscli \
            aws-sam-cli \
    && apk -v --purge --no-cache del \
            gcc \
            python3-dev \
            musl-dev

RUN npm i -g aws-cdk
