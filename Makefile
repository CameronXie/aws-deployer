# Development
up: create-dev-env
	@make start-containers

down:
	@make stop-containers

start-containers:
	@docker-compose up --build -d

stop-containers:
	@docker-compose down -v

assume-role:
	@source ./assume_role.sh $(token)

create-dev-env:
	@test -e .env || cp .env.example .env