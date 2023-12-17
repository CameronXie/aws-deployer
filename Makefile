tool_repos:=aws/aws-cli

# Development
up: create-dev-env
	@docker compose up --build -d

down:
	@docker compose down -v

assume-role:
	@source ./assume_role.sh $(token)

create-dev-env:
	@test -e .env || cp .env.example .env

build:
	@docker build -t cameronx/aws-deployer:latest --platform linux/amd64 -f docker/deployer/Dockerfile docker/deployer

push: build
	@docker push cameronx/aws-deployer:latest

# Dev
fetch-versions:
	@aws_cli_ver=$(shell curl -s https://api.github.com/repos/aws/aws-cli/tags | jq -r .[].name | grep -m1 '^2'); \
		echo ARG AWS_CLI_VERSION=$$aws_cli_ver
	@sam_ver=$(shell curl -s https://api.github.com/repos/aws/aws-sam-cli/releases | jq -r .[0].tag_name); \
		echo ARG AWS_SAM_CLI_VERSION=$$sam_ver
	@rain_ver=$(shell curl -s https://api.github.com/repos/aws-cloudformation/rain/releases | jq -r .[0].tag_name); \
    		echo ARG RAIN_VERSION=$$rain_ver
	@eksctl_ver=$(shell curl -s https://api.github.com/repos/eksctl-io/eksctl/tags | jq -r '.[]|select(.name|contains("-")|not)|.name' | grep -m1 ""); \
		echo ARG EKSCTL_VERSION=$$eksctl_ver
	@kubectl_ver=$(shell curl -sL https://dl.k8s.io/release/stable.txt); \
		echo ARG KUBECTL_VERSION=$$kubectl_ver
	@helm_ver=$(shell curl -s https://api.github.com/repos/helm/helm/tags | jq -r .[0].name); \
		echo ARG HELM_VERSION=$$helm_ver
	@kustomize_ver=$(shell curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases | jq -r .[].tag_name | grep -m1 '^kustomize' | sed -n 's/^kustomize\/v\(\s*\)/\1/p'); \
		echo ARG KUSTOMIZE_VERSION=$$kustomize_ver
	@istio_ver=$(shell curl -s https://api.github.com/repos/istio/istio/tags | jq -r .[0].name); \
		echo ARG ISTIO_VERSION=$$istio_ver