#!/bin/bash

# Fetch versions
AWS_CLI_VERSION=$(curl -s https://api.github.com/repos/aws/aws-cli/tags | jq -r 'map(select(.name | startswith("2")))[0].name')
AWS_SAM_CLI_VERSION=$(curl -s https://api.github.com/repos/aws/aws-sam-cli/releases | jq -r '.[0].tag_name')
EKSCTL_VERSION=$(curl -s https://api.github.com/repos/eksctl-io/eksctl/tags | jq -r '.[]|select(.name|contains("-")|not)|.name' | grep -m1 "")
HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/tags | jq -r '.[0].name')
ISTIO_VERSION=$(curl -s https://api.github.com/repos/istio/istio/tags | jq -r '.[0].name')
K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases | jq -r '.[0].tag_name')
KUBECTL_VERSION=$(curl -sL https://dl.k8s.io/release/stable.txt)
KUSTOMIZE_VERSION=$(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases | jq -r 'map(select(.tag_name | startswith("kustomize")))[0].tag_name' | sed 's/^kustomize\/v\(.*\)/\1/')
RAIN_VERSION=$(curl -s https://api.github.com/repos/aws-cloudformation/rain/releases | jq -r '.[0].tag_name')

# Replaces placeholders in the template file and prints success message.
replace_placeholders() {
    local template_file=$1
    local output_file=$2

    sed -e "s/{{AWS_CLI_VERSION}}/${AWS_CLI_VERSION}/g" \
        -e "s/{{AWS_SAM_CLI_VERSION}}/${AWS_SAM_CLI_VERSION}/g" \
        -e "s/{{EKSCTL_VERSION}}/${EKSCTL_VERSION}/g" \
        -e "s/{{HELM_VERSION}}/${HELM_VERSION}/g" \
        -e "s/{{ISTIO_VERSION}}/${ISTIO_VERSION}/g" \
        -e "s/{{K9S_VERSION}}/${K9S_VERSION}/g" \
        -e "s/{{KUBECTL_VERSION}}/${KUBECTL_VERSION}/g" \
        -e "s/{{KUSTOMIZE_VERSION}}/${KUSTOMIZE_VERSION}/g" \
        -e "s/{{RAIN_VERSION}}/${RAIN_VERSION}/g" \
        < ${template_file} > ${output_file}

    echo "${output_file} has been generated from ${template_file}."
}

# Generate Dockerfile and README.md from templates
replace_placeholders "scripts/Dockerfile.template" "docker/deployer/Dockerfile"
replace_placeholders "scripts/README.template.md" "README.md"
