# USER DOCUMENTATION — Inception Project

## Overview

This project deploys a small web infrastructure composed of:

- NGINX (HTTPS entry point)
- WordPress (web application)
- MariaDB (database backend)

The entire stack is managed using Docker Compose, and all services run in separate containers. Persistent data is stored using Docker volumes on the host machine.

---

## Requirements

- Docker and Docker Compose installed on the system
- `make` available (Makefile provided in the project)

---

## Project Structure (User View)

- Website is served over HTTPS only
- HTTP (port 80) is disabled
- WordPress is automatically configured at startup
- Data persists between container restarts

---

## Start the Stack

To build and start all services:

```bash
make up
````

This will:

* Build Docker images (if needed)
* Create and start containers
* Set up the WordPress database
* Expose the website via HTTPS

---

## Stop the Stack

To stop all running services:

```bash
make down
```

This stops containers but keeps volumes (data is preserved).

---

## Full Reset (Clean State)

To remove containers, networks, and volumes:

```bash
make fclean
```

⚠️ This will delete all persistent data, including the database and WordPress content.

---

## Access the Website

Once the stack is running, open:

```text
https://mhoushma.42.fr
```

> The site is only accessible via HTTPS (port 443).

If your browser shows a security warning, accept the self-signed certificate.

---

## WordPress Admin Panel

Access the administration interface:

```text
https://mhoushma.42.fr/wp-admin
```

### Login

Use the administrator credentials defined in the `.env` file.

After login, you can:

* Create and edit posts
* Manage comments
* Change website settings
* Install themes and plugins (if enabled)

---

## Credentials

All credentials are stored in the `.env` file used by Docker Compose.

Important rules:

* Do NOT commit `.env` to the repository
* Passwords must remain private
* Changes in credentials require rebuilding the stack:

```bash
make fclean
make up
```

---

## Basic Health Checks

If something is not working correctly, you can verify the stack:

```bash
docker compose -f srcs/docker-compose.yml ps
docker ps
```

Check running containers:

* nginx
* wordpress
* mariadb

---

## Logs (for debugging)

If needed, check service logs:

```bash
docker compose -f srcs/docker-compose.yml logs -f
```

Or individually:

```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

---

## Live Verification (Defense Checklist)

During evaluation, verify the following:

1. Start the stack:

   ```bash
   make up
   ```

2. Open the website:

   * [https://mhoushma.42.fr](https://mhoushma.42.fr)

3. Confirm:

   * WordPress homepage loads correctly
   * You are NOT on installation page

4. Test HTTPS-only rule:

   * [http://mhoushma.42.fr](http://mhoushma.42.fr) should NOT work

5. Login to admin panel:

   * [https://mhoushma.42.fr/wp-admin](https://mhoushma.42.fr/wp-admin)

6. Perform a change:

   * Create a post or comment

7. Restart stack:

   ```bash
   make down
   make up
   ```

   Confirm data is still present

---

## Data Persistence

All WordPress and MariaDB data are stored using Docker volumes on the host system.

This ensures:

* Data survives container restarts
* Data survives image rebuilds
* Website content remains persistent

---

## Notes

* Only HTTPS (port 443) is exposed externally
* HTTP (port 80) is disabled for security
* Each service runs in its own container
* Docker Compose handles networking between services

