name = Mattermost

VAR :=				# Cmd arg var
NO_COLOR=\033[0m	# Color Reset
OK=\033[32;01m		# Green Ok
ERROR=\033[31;01m	# Error red
WARN=\033[33;01m	# Warning yellow
USER_ID = $(shell id -u)
ifneq (,$(wildcard .env))
    include .env
    export $(shell sed 's/=.*//' .env)
endif

all:
	@printf "Launch configuration ${name}...\n"
	@docker-compose -f ./docker-compose.yml up -d

help:
	@echo -e "$(OK)==== Все команды для конфигурации ${name} ===="
	@echo -e "$(WARN)- make				: Launch configuration"
	@echo -e "$(WARN)- make build			: Configuration build"
	@echo -e "$(WARN)- make config			: Show configuration
	@echo -e "$(WARN)- make connect			: Exec to container"
	@echo -e "$(WARN)- make dirs			: Create volumes directories"
	@echo -e "$(WARN)- make folders			: Create necessary folders"
	@echo -e "$(WARN)- make git			: Set git user"
	@echo -e "$(WARN)- make down			: Stopping the configuration"
	@echo -e "$(WARN)- make env			: Create .env from source"
	@echo -e "$(WARN)- make ps			: Show the configuration "
	@echo -e "$(WARN)- make push			: Push changes to the github"
	@echo -e "$(WARN)- make re			: Rebuild the configuration"
	@echo -e "$(WARN)- make clean			: Clean all images"
	@echo -e "$(WARN)- make fclean			: Full clean of all configurations$(NO_COLOR)"

build:
	@printf "Сonfiguration ${name} build...\n"
	@bash folders.sh
	@docker-compose -f ./docker-compose.yml up -d --build

config:
	@printf "$(OK_COLOR)==== Wiew container configuration... ====$(NO_COLOR)\n"
	@docker-compose config

connect:
	@docker exec -it atlas bash

dirs:
	@if [ ! -d conf ]; then mkdir conf; fi
	@if [ ! -d data ]; then mkdir data; fi
	@if [ ! -d logs ]; then mkdir logs; fi
	@printf "Directories was created!\n"

down:
	@printf "Stopping the configuration ${name}...\n"
	@docker-compose -f ./docker-compose.yml down

env:
	@printf "$(WARN_COLOR)==== Create environment file for ${name}... ====$(NO_COLOR)\n"
	@if [ -f .env ]; then \
		echo "$(ERROR_COLOR).env file already exists!$(NO_COLOR)"; \
	else \
		cp .env.example .env; \
		echo "USER_ID=${USER_ID}" >> .env && \
		echo "$(OK_COLOR).env file successfully created!$(NO_COLOR)"; \
	fi

folders:
	@printf "$(YELLOW)==== Set user name and email to git for ${name} repo... ====$(NO_COLOR)\n"
	@bash scripts/folders.sh

git:
	@printf "$(YELLOW)==== Set user name and email to git for ${name} repo... ====$(NO_COLOR)\n"
	@bash scripts/gituser.sh

ps:
	@printf "Show the configuration ${name}......\n"
	@docker-compose -f ./docker-compose.yml ps

push:
	@bash scripts/push.sh

re:
	@printf "Rebuild the configuration ${name}...\n"
	@docker-compose -f ./docker-compose.yml down
	@docker-compose -f ./docker-compose.yml up -d --build

clean: down
	@printf "Clean all images...\n"
	@docker system prune -a

fclean:
	@printf "Full clean of all configurations\n"
#	@docker stop $$(docker ps -qa)
#	@docker system prune --all --force --volumes
#	@docker network prune --force
#	@docker volume prune --force

.PHONY	: all build down ps re scan show clean fclean
