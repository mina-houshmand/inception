# Inception User Documentation

## Purpose

This project runs a small web infrastructure with three services:

- NGINX as the HTTPS entry point
- WordPress as the website backend
- MariaDB as the database

The stack is started with Docker Compose and all persistent data is stored in the host data directory configured by the project.

## Start and Stop

Start the stack:

```bash
make up
```

Stop the stack:

```bash
make down
```

Remove containers and volumes when you want a clean reset:

```bash
make fclean
```

## Access the Website

Open the website in a browser with HTTPS:

```text
https://<login>.42.fr
```

Only port 443 should be reachable from outside. HTTP on port 80 should not be used.

## Access the WordPress Admin Panel

Use the administrator credentials defined in the project environment file to sign in.

After signing in, the admin dashboard is available from the WordPress menu or by visiting the admin path shown by WordPress.

## Credentials

The project reads its credentials from the environment file used by Docker Compose.

- Do not commit real passwords into documentation
- Keep the `.env` file private
- If credentials are changed, rebuild and restart the stack

## Basic Checks

Use these checks if something looks wrong:

```bash
make up
docker compose -f srcs/docker-compose.yml ps
docker ps
docker volume ls
```

Useful troubleshooting commands:

```bash
docker compose -f srcs/docker-compose.yml logs -f
docker logs nginx
docker logs site
docker logs db
```

## Live Check Guide

Use this sequence to verify the project manually during a defense:

1. Run `make up`.
2. Open `https://<login>.42.fr` in a browser.
3. Confirm the WordPress site loads and you do not see the WordPress installation screen.
4. Try `http://<login>.42.fr` and confirm it does not serve the site.
5. Check that the admin panel can be reached with the administrator account.
6. Create a comment or edit content from the dashboard to prove the site is writable.
7. Check that the database and website data remain after restarting the stack.

## Data Persistence

Website and database data are stored in the host data directories managed by Docker volumes. That means content should survive container restarts and recreation of the stack.
