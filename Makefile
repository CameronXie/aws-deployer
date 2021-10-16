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
	@docker build -t cameronx/aws-deployer:latest -f docker/node/Dockerfile docker/node