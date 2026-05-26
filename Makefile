all: up

#--force-recreate tells Docker Compose to destroy and recreate the containers every time you run
up:
	docker compose -f ./srcs/docker-compose.yml up -d --build --force-recreate

down:
	docker compose -f ./srcs/docker-compose.yml down

stop:
	docker compose -f ./srcs/docker-compose.yml stop

start:
	docker compose -f ./srcs/docker-compose.yml start

build:
	docker compose -f ./srcs/docker-compose.yml build --no-cache

status:
	docker ps

fclean:
	docker system prune -af --volumes

re: fclean all

.PHONY: all up down stop start build status fclean re