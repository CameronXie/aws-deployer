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
