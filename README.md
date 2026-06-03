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
| **Docker Network** | Services communicate via service names, hidden from outside |
| **Volumes** | Data persists even after containers restart |
| **HTTPS/SSL** | Encrypts communication between browser and server |

Docker Compose lets you:
- Define everything in one YAML file
- Start all containers with one command: docker compose up
- Automatically create networks between containers
- Manage volumes easily
- Handle dependencies (e.g., WordPress waits for MariaDB)
---

### Docker vs Virtual Machines

Docker is lightweight, fast, and sufficient for containerization without the overhead of full OS per container. Services share the Linux kernel, making it ideal for this project.

### Environment Variables vs Secrets

Environment Variables store non-sensitive config (domain, ports, usernames). Secrets should store passwords in production, but here we use `.env` for simplicity.

### Docker Network vs Host Network

Docker Network isolates services internally. Services communicate via service names. Only NGINX exposes ports to the host (443). MariaDB and WordPress remain hidden.

### Named Volumes vs Bind Mounts

Named Volumes store data in `/home/mhoushma/data/` and are Docker-managed. This ensures data persists across container restarts and is portable.

---

## Services

| Service | Purpose | Port |
|---------|---------|------|
| **NGINX** | Reverse proxy, HTTPS entry point | 443 |
| **WordPress** | Website backend (PHP-FPM) | 9000 (internal) |
| **MariaDB** | Database, hidden from outside | 3306 (internal) |

---


---

## Instructions

### Prerequisites

- Docker and Docker Compose installed
   * Without docker compose, you'd use: 
    ```
    docker run -v /path/data:/data -p 3306:3306 mariadb
    ```
    This is long and you must run each container separately and connect them manually.

- Linux system with `/home/mhoushma/` directory
- Port 443 available
- Root or sudo access

### Setup & Running

**Build and Start:**

```bash
make up
```

Stop Containers:
```
make down
```

Full Clean (removes data):
```
make fclean
```

Access Website:
```
https://mhoushma.42.fr
```
Verification Commands
Check running containers:
```
docker ps
```

View logs:
```
docker-compose logs -f
```

Access container shell:
```
docker exec -it wordpress bash
```

Check MariaDB:
```
docker exec -it mariadb mariadb -uroot -prootpass -e "SHOW DATABASES;"
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Port 443 in use | `sudo lsof -i :443` then `sudo kill -9 <PID>` |
| Permission denied | `sudo chown -R $(id -u):$(id -g) /home/mhoushma/data/` |
| MariaDB won't connect | Wait 15-20s for initialization, check logs |
| SSL warnings | Normal with self-signed certificates |
| Containers won't start | Check `.env` file configuration |

---


## How AI Was Used

AI tools were primarily utilized for:

1. **Understanding Docker Architecture** — Explained Docker networking concepts, container isolation, and communication patterns between services
2. **Infrastructure Design** — Helped structure the multi-service architecture and design decisions for reverse proxy, database isolation, and data persistence
3. **Configuration Assistance** — Generated NGINX reverse proxy configurations, MariaDB initialization scripts, and WordPress auto-setup procedures
4. **Troubleshooting & Debugging** — Provided commands and solutions for common Docker issues like port conflicts, permission problems, and database connectivity
5. **Documentation Structure** — Organized README.md following 42 curriculum requirements and best practices for technical documentation
6. **Code Optimization** — Reviewed Dockerfiles for best practices, layer caching efficiency, and minimal image sizes
7. **Security Review** — Assisted with SSL/TLS setup, password management strategies, and network isolation verification

---










