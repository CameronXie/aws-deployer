FROM python:3.12-bullseye

ARG NODE_MAJOR=20
ARG TMP_DIR=/tmp/deployer
ENV DEBIAN_FRONTEND=noninteractive

ARG AWS_CLI_VERSION=2.17.0
ARG AWS_SAM_CLI_VERSION=v1.119.0
ARG RAIN_VERSION=v1.11.0
ARG EKSCTL_VERSION=v0.183.0
ARG KUBECTL_VERSION=v1.30.2
ARG HELM_VERSION=v3.15.2
ARG KUSTOMIZE_VERSION=5.4.2
ARG ISTIO_VERSION=1.22.1

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
    # install Node \
    && mkdir -p /etc/apt/keyrings \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update && apt-get install nodejs -y \
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
    && wget -q -O samcli.zip https://github.com/aws/aws-sam-cli/releases/download/${AWS_SAM_CLI_VERSION}/aws-sam-cli-linux-x86_64.zip \
    && unzip samcli.zip -d samcli \
    && samcli/install \
    # install aws sam cli
    && wget -q -O rain.zip https://github.com/aws-cloudformation/rain/releases/download/${RAIN_VERSION}/rain-${RAIN_VERSION}_linux-amd64.zip \
    && unzip rain.zip \
    && mv rain-${RAIN_VERSION}_linux-amd64/rain /usr/local/bin/rain \
    # install eksctl
    && wget -q -O eksctl.tar.gz https://github.com/weaveworks/eksctl/releases/download/${EKSCTL_VERSION}/eksctl_$(uname -s)_amd64.tar.gz \
    && tar -xzf eksctl.tar.gz \
    && mv eksctl /usr/local/bin \
    # install kubectl
    && wget -q -O kubectl https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && install -m 0755 kubectl /usr/local/bin/kubectl \
    # install helm
    && wget -q -O helm.tar.gz https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz \
    && tar -zxvf helm.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    # install kustomize \
    && curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash -s -- ${KUSTOMIZE_VERSION} /usr/local/bin \
    # install istio \
    && curl -L https://istio.io/downloadIstio | ISTIO_VERSION=${ISTIO_VERSION} TARGET_ARCH=x86_64 sh - \
    && mv istio-${ISTIO_VERSION}/bin/istioctl /usr/local/bin/istioctl \
    # clean up
    && rm -rf ${TMP_DIR}
