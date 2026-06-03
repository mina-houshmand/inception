# Inception Developer Documentation

## Prerequisites

- Docker and Docker Compose installed
- A Linux host
- Available port 443
- The project environment file configured for the current machine

## Project Layout

- Root files contain the Makefile and documentation
- `srcs/` contains the Docker Compose file and all service configuration
- Each service has its own Dockerfile and supporting scripts

## Build and Run

Use the Makefile for the normal workflow:

```bash
make up
make down
make fclean
```

The Makefile wraps Docker Compose using `srcs/docker-compose.yml`.

If you need to run Compose directly:

```bash
docker compose -f srcs/docker-compose.yml up -d --build
docker compose -f srcs/docker-compose.yml down
docker compose -f srcs/docker-compose.yml ps
```

## Service Overview

- NGINX terminates TLS and exposes port 443
- WordPress runs with php-fpm only
- MariaDB runs as the database backend
- The services communicate through the internal bridge network defined in Compose

## Data Persistence

Persistent data is stored through Docker volumes mapped to host directories under the project data path.

To inspect a volume:

```bash
docker volume ls
docker volume inspect wordpress
docker volume inspect mariadb
```

The output should show the host path used for persistence.

## Live Check / Verification Steps

When validating the stack manually, check the following:

1. Start the project with `make up`.
2. Confirm the containers are up with `docker compose -f srcs/docker-compose.yml ps`.
3. Open `https://mhoushma.42.fr` and verify the site loads over HTTPS.
4. Confirm `http://mhoushma.42.fr` is not serving the application.
5. Verify the WordPress installation is already complete.
6. Log into WordPress as an administrator and confirm the dashboard works.
7. Add or edit content, then restart the stack and confirm the change remains.
8. Inspect the MariaDB container and verify the database is present and not empty.

## Troubleshooting

If the stack does not start correctly:

```bash
docker compose -f srcs/docker-compose.yml logs -f
docker logs nginx
docker logs site
docker logs db
```

If a volume path looks wrong, verify the data directory used by the project environment and rebuild the stack.
