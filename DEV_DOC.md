# DEVELOPER DOCUMENTATION — Inception Project

## Overview

This project implements a small web infrastructure using Docker Compose.  
It consists of three main services:

- NGINX (HTTPS reverse proxy)
- WordPress (PHP-FPM application)
- MariaDB (database server)

All services run in separate containers and communicate through a private Docker network.

---

## Prerequisites

To run or develop this project, you need:

- Docker installed
- Docker Compose installed
- A Linux-based system (recommended)
- Port `443` available on the host machine
- A properly configured `.env` file (not committed to the repository)

---

## Project Structure

```

.
├── Makefile
├── README.md
├── srcs/
│  ├──docker-compose.yml
│  ├──requirements/
│     ├── nginx/
│     ├── wordpress/
│     └── mariadb/

```

### Description

- `Makefile`: entry point for building and managing the stack
- `srcs/`: contains all Docker-related configuration
- Each service has its own Dockerfile and configuration scripts

---

## Build and Run

The project is managed through a Makefile wrapper:

```bash
make up
```

Builds images and starts all containers.

```bash
make down
```

Stops and removes containers (keeps volumes).

```bash
make fclean
```

Removes containers, networks, and volumes (full reset).

---

## Direct Docker Compose Usage (Optional)

You can also interact directly with Docker Compose:

```bash
docker compose -f srcs/docker-compose.yml up -d --build
```

```bash
docker compose -f srcs/docker-compose.yml down
```

```bash
docker compose -f srcs/docker-compose.yml ps
```

---

## Service Architecture

### NGINX

- Acts as reverse proxy
- Terminates TLS (HTTPS)
- Exposes only port `443`
- Forwards requests to WordPress container

### WordPress

- Runs with PHP-FPM
- Handles dynamic web content
- Connects to MariaDB for data storage

### MariaDB

- Database backend for WordPress
- Stores all persistent application data

---

## Networking

All services communicate via a dedicated Docker bridge network defined in `docker-compose.yml`.

- Internal communication only
- No direct external access to WordPress or MariaDB

---

## Data Persistence

All important data is stored using Docker volumes:

- WordPress files and uploads
- MariaDB database files

### Inspect volumes

```bash
docker volume ls
```

```bash
docker volume inspect wordpress
docker volume inspect mariadb
```

This will show the host path where data is persisted.

---

## Live Verification Steps

To validate the system manually:

1. Start the stack:

   ```bash
   make up
   ```

2. Check containers:

   ```bash
   docker compose -f srcs/docker-compose.yml ps
   ```

3. Open the website:

   ```
   https://mhoushma.42.fr
   ```

4. Confirm:

   - Site loads correctly
   - HTTPS is enforced

5. Test HTTP:

   ```
   http://mhoushma.42.fr
   ```

   → Should NOT serve the application

6. Verify WordPress:

   - Installation is already completed
   - No setup screen appears

7. Login as admin and verify dashboard access

8. Modify content and restart stack:

   ```bash
   make down
   make up
   ```

   Confirm changes persist

---

## Troubleshooting

### Check logs

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

Or per service:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

---

### Common Issues

- **Website not reachable**

  - Check if port 443 is already in use
  - Ensure NGINX container is running

- **Database errors**

  - Verify MariaDB volume exists
  - Check `.env` credentials consistency

- **WordPress setup screen appears**

  - Database may not be initialized correctly
  - Reset with `make fclean` and rebuild

---

## Notes

- Only HTTPS (443) is exposed externally
- HTTP (80) is disabled
- WordPress and MariaDB are never exposed publicly
- All services are isolated in Docker containers
