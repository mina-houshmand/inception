all: up

# create parent directories if they don't exist
# do not throw an error if the directory already exists
up:
	@mkdir -p /home/$(USER)/data/wordpress
	@mkdir -p /home/$(USER)/data/mariadb
	# docker compose → uses the compose system
	# up → starts the services
	# --build → builds images before starting
	# -f → use the following docker compose file
	# -d → Runs containers in the background
	@docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	@docker compose -f ./srcs/docker-compose.yml down

stop:
	@docker compose -f ./srcs/docker-compose.yml stop

start:
	@docker compose -f ./srcs/docker-compose.yml start

# Stops and removes the containers
# removes attached Docker volumes
# --remove-orphans → Removes containers not defined in the current compose file.
clean: down
	@docker compose -f ./srcs/docker-compose.yml down --volumes --remove-orphans
	# prune → Removes unused Docker data
	# -a → Also removes unused images
	# -f → Forces cleanup without asking for confirmation.
	@docker system prune -af

fclean: clean
	@sudo rm -rf /home/$(USER)/data
	@docker volume prune -f

re: fclean all

#shows live container logs
logs:
	@docker compose -f ./srcs/docker-compose.yml logs -f

#shows running containers and their state
status:
	@docker compose -f ./srcs/docker-compose.yml ps

# Prevents conflicts with files having the same names as targets
# ignores files with same names and always executes the commands.
.PHONY: all up down stop start clean fclean re logs status
