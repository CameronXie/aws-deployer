FROM python:3.9-bullseye

ARG NODE_VERSION=lts
ARG AWS_CLI_VERSION=2.6.4
ARG AWS_SAM_CLI_VERSION=1.50.0
# https://storage.googleapis.com/kubernetes-release/release/stable.txt
ARG KUBECTL_VERSION=1.24.0
ARG HELM_VERSION=3.8.2
ARG KUSTOMIZE_VERSION=4.5.4
ARG TMP_DIR=/tmp/deployer
ENV DEBIAN_FRONTEND=noninteractive

COPY assume_role.sh /usr/local/bin/assume_role.sh

RUN set -eux \
    && apt-get update && apt-get install -y --no-install-recommends \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg \
      less \
      lsb-release \
      jq \
      vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR ${TMP_DIR}
RUN set -eux \
    # install Node
    && curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt install nodejs \
    # install Docker
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io \
    # install aws cli
    && wget -q -O awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip \
    && unzip awscliv2.zip -d awscli \
    && awscli/aws/install \
    # install aws sam cli
    && wget -q -O samcli.zip https://github.com/aws/aws-sam-cli/releases/download/v${AWS_SAM_CLI_VERSION}/aws-sam-cli-linux-x86_64.zip \
    && unzip samcli.zip -d samcli \
    && samcli/install \
    # install kubectl
    && wget -q -O kubectl https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && install -m 0755 kubectl /usr/local/bin/kubectl \
    # install eksctl
    && wget -q -O eksctl.tar.gz https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz \
    && tar -xzf eksctl.tar.gz \
    && mv eksctl /usr/local/bin \
    # install helm
    && wget -q -O helm.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -zxvf helm.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    # install kustomize \
    && curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash -s -- ${KUSTOMIZE_VERSION} /usr/local/bin \
    # clean up
    && rm -rf ${TMP_DIR}
