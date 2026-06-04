# start every thing
all: up

# creates necessary directories for volumes if they don't exist
volumes:
	mkdir -p /home/$(shell whoami)/data/wordpress
	mkdir -p /home/$(shell whoami)/data/mariadb

# brings containers up with volume preparation
# -v -> Stop containers & Also delete named volumes
# --remove-orphans -> Removes containers that are defined in the project before but 
#are no longer in your current docker-compose.yml
# 2>/dev/null -> silencing any error messages that may occur during the execution 
# || true -> failure is ignored and Make continues anyway
# export USER=$(shell whoami) -> Start Docker Compose,pass my username into the environment as USER
up: volumes
	docker compose -f srcs/docker-compose.yml down -v --remove-orphans 2>/dev/null || true
	export USER=$(shell whoami) && docker compose -f srcs/docker-compose.yml up -d

# stops containers
down:
	docker compose -f ./srcs/docker-compose.yml down

# stops running containers without removing them
stop:
	docker compose -f ./srcs/docker-compose.yml stop

# starts stopped containers without recreating them
start:
	docker compose -f ./srcs/docker-compose.yml start

# builds images without using cache
build:
	docker compose -f ./srcs/docker-compose.yml build --no-cache

# shows running containers
status:
	docker ps

# removes all stopped containers, unused networks, dangling images, and build cache
fclean:
	docker system prune -af --volumes

# restart (fclean + all)
re: fclean all

# declare phony targets to avoid conflicts with files of the same name
.PHONY: all up down stop start build status fclean re