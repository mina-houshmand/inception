# 🐳 Inception

## 📘 Overview

**Inception** is a project from **42** aimed at introducing system administration and containerization using **Docker** and **Docker Compose**.

The goal is to create a small, self-contained infrastructure composed of three services:
- **NGINX** — acts as a reverse proxy and HTTPS web server  
- **WordPress (PHP-FPM)** — dynamic website backend  
- **MariaDB** — database server for WordPress

Each service runs inside its own Docker container, built **from a custom Debian base image**, without any prebuilt images.

All data is stored persistently inside `/home/mhoushma/data/` using **named volumes backed by the local driver**.

---

## 🏗️ Project Structure

```
inception/
├── Makefile
├── .env
├── srcs/
│   ├── docker-compose.yml
│   ├── requirements/
│   │   ├── nginx/
│   │   │   ├── Dockerfile
│   │   │   └── conf/
│   │   │       └── nginx.conf
│   │   ├── wordpress/
│   │   │   ├── Dockerfile
│   │   │   └── conf/
│   │   │       └── auto_config.sh
│   │   ├── mariadb/
│   │   │   ├── Dockerfile
│   │   │   ├── conf/
│   │   │   │   └── 50-server.cnf
│   │   │   └── tools/
│   │   │       └── setup_mariadb.sh
└── data/
    ├── wordpress/
    └── mariadb/
```

---

## ⚙️ Services

### 🧩 NGINX
- Built from **Debian:bookworm**
- Configured to listen only on **port 443**
- Uses a **self-signed SSL certificate**
- Redirects PHP requests to the **WordPress container** on port `9000`
- Volume:
  ```
  /home/mhoushma/data/wordpress → /var/www/html
  ```

### 🧩 WordPress (PHP-FPM)
- Built from **Debian:bookworm**
- Installs PHP 8.2, PHP-FPM, and `wp-cli`
- Automatically installs and configures WordPress on startup
- Connects to the **MariaDB** container using environment variables
- Volume:
  ```
  /home/mhoushma/data/wordpress → /var/www/html
  ```

### 🧩 MariaDB
- Built from **Debian:bookworm**
- Initializes database and user on first run
- Stores data persistently on the host
- Listens on port `3306` within Docker network
- Volume:
  ```
  /home/mhoushma/data/mariadb → /var/lib/mysql
  ```

---

## 🧰 Environment Configuration

All environment variables are stored in the `.env` file:

```bash
# DOMAIN
DOMAIN_NAME=mhoushma.42.fr

# DATABASE
MARIADB_DATABASE=wordpress_db
MARIADB_USER=wordpress-user
MARIADB_PASSWORD=wppass
MARIADB_ROOT_PASSWORD=rootpass
MARIADB_HOST=mariadb

# WORDPRESS
WP_PATH=https://mhoushma.42.fr
WP_TITLE=My Inception Project
WP_ADMIN_USER=mhoushma42
WP_ADMIN_PASS=Admin
WP_ADMIN_EMAIL=mhoushma@42.fr

WP_USER=sina
WP_USER_EMAIL=sina@42.fr
WP_USER_PWD=Admin
```

---

## 🚀 Usage

### 1️⃣ Build and start the containers
```bash
make up
```

### 2️⃣ Stop the containers
```bash
make down
```

### 3️⃣ Clean everything
```bash
make fclean
```

---

## 🔍 Verification Commands

### Check running containers
```bash
docker ps
```

### Check MariaDB connectivity
```bash
docker exec -it mariadb mariadb -uroot -prootpass -e "SHOW DATABASES;"
docker exec -it mariadb mariadb -wordpress-user -pwppass wordpress_db -e "SHOW TABLES;"
```

### Check WordPress users
```bash
docker exec -it mariadb mariadb -wordpress-user -pwppass wordpress_db -e "SELECT ID, user_login FROM wp_users;"
```

### Check NGINX SSL
```bash
curl -vk https://mhoushma.42.fr
```

### Check PHP-FPM
```bash
docker exec -it wordpress ss -tulnp | grep 9000
```

---

## 💾 Data Persistence

The project uses **named volumes** backed by the local driver, with data stored on the host under `/home/mhoushma/data`.  
You can verify this with:

```bash
docker volume ls         # (should be empty)
ls -la /home/falberti/data
```

WordPress files: wordpress volume
WordPress database: mariadb volume

“WordPress files and the WordPress database are stored in two different persistent places. The WordPress container writes the website files to the wordpress volume, and the MariaDB container writes the database files to the mariadb volume. That way, if a container stops or gets rebuilt, the data is still kept on the host.”

“WordPress files and the WordPress database are stored in two different persistent places. The WordPress container writes the website files to the wordpress volume, and the MariaDB container writes the database files to the mariadb volume. That way, if a container stops or gets rebuilt, the data is still kept on the host.”

| Service | Container Path | Host Path |
|----------|----------------|------------|
| WordPress | `/var/www/html` | `/home/mhoushma/data/wordpress` |
| MariaDB | `/var/lib/mysql` | `/home/mhoushma/data/mariadb` |

This ensures that data persists after container restarts or rebuilds.

---

## ✅ Evaluation Checklist

- [x] One Dockerfile per service  
- [x] Custom images built from Debian  
- [x] SSL enabled and enforced  
- [x] WordPress accessible via HTTPS  
- [x] MariaDB initialized and persistent  
- [x] NGINX ↔ PHP-FPM ↔ MariaDB chain functional  
- [x] Volumes stored in `/home/mhoushma/data`  
- [x] No usage of prebuilt images  
- [x] Clean Makefile and Docker Compose workflow  


> 💬 “An image is the recipe — a container is the dish.”
