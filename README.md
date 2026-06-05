*This project has been created as part of the 42 curriculum by mhoushma.*

# 🐳 Inception — Docker Infrastructure Project

## Description

A system administration project that builds a complete web infrastructure using Docker. Three services (NGINX, WordPress, MariaDB) run in isolated containers and communicate through a private network.

**Flow**: Browser → NGINX (443) → WordPress (PHP-FPM) → MariaDB

### Why Docker?

- Services isolated in separate containers
- Prevents conflicts and crashes
- Easy to manage, restart, and scale
- Reproducible environment

### Key Concepts

| Concept | Why Used |
|---------|----------|
| **Docker Compose** | Orchestrates all containers together |
| **Docker Network** | Services communicate via service names |
| **Volumes** | Data persists even after container restarts |
| **HTTPS/SSL** | Encrypts communication between browser and server |

Docker Compose allows you to:
- Define everything in one YAML file
- Start all containers with one command: `docker compose up`
- Automatically create networks between containers
- Manage volumes easily
- Handle service dependencies (WordPress waits for MariaDB)

---

### Docker vs Virtual Machines

Docker is lightweight and shares the host OS kernel, making it faster and more efficient than full virtual machines.

### Environment Variables vs Secrets

Environment variables store configuration (domain, ports, usernames). In production, secrets should be used for sensitive data, but `.env` is used here for simplicity.

### Docker Network vs Host Network

Docker network isolates services internally. Only NGINX exposes port 443 to the host. WordPress and MariaDB remain private.

### Named Volumes vs Bind Mounts

Named volumes store persistent data in `/home/mhoushma/data/`, managed by Docker and preserved across restarts.

---

## Services

| Service     | Purpose                          | Port |
|------------|----------------------------------|------|
| NGINX      | Reverse proxy, HTTPS entry point | 443  |
| WordPress  | Website backend (PHP-FPM)        | 9000 |
| MariaDB    | Database (internal only)         | 3306 |

---

## Instructions

### Prerequisites

- Docker and Docker Compose installed
- Linux system with `/home/mhoushma/` directory
- Port 443 available
- Root or sudo access

### Setup & Running

**Build and start containers:**
```bash
make up
````

**Stop containers:**

```bash
make down
```

**Full clean (removes all data):**

```bash
make fclean
```

### Access Website

```
https://mhoushma.42.fr
```

### Verification Commands

Check running containers:

```bash
docker ps
```

View logs:

```bash
cd srcs
docker-compose logs -f
```

Access container shell:

```bash
docker exec -it wordpress bash
```

Check MariaDB:

```bash
docker exec -it db mariadb -uroot -prootpass -e "SHOW DATABASES;"```

---


## Resources

### How AI Was Used

AI tools were used during this project for:

1. Understanding Docker architecture, networking, and container isolation
2. Designing the multi-service infrastructure (NGINX, WordPress, MariaDB)
3. Generating and improving configuration files (NGINX, Dockerfiles, MariaDB setup)
4. Debugging common issues such as port conflicts, permissions, and database connectivity
5. Structuring documentation according to 42 curriculum requirements
6. Improving Docker best practices (layer optimization, caching, and security setup)
7. Assisting with SSL/TLS configuration and network isolation verification

```

