# Inception — Simple Project Summary

The main idea of this project is to build a small real-world server infrastructure using Docker.

Instead of installing everything directly on Linux, every service runs inside its own container.

A container is like a small isolated machine that runs one service only.

For example:

* one container runs NGINX
* one container runs WordPress
* one container runs MariaDB

All containers communicate together through a private Docker network.

---

# What is the goal of the project?

The goal is to understand how modern websites are built and managed.

This project teaches:

* how services communicate
* how Docker works
* how servers are organized
* how websites connect to databases
* how reverse proxy systems work
* how data is stored permanently
* how infrastructure is monitored

The project simulates a small production server.

---

# General Flow of the Project

When a user opens the website:

```text id="p2r0sy"
Browser
   |
   v
NGINX
   |
   v
WordPress
   |
   v
MariaDB
```

Now let’s explain this in simple words.

---

# Step 1 — User opens the website

Example:

```text id="6c6v4u"
https://oshcheho.42.fr
```

The browser sends a request to your server asking:

> “Please give me the website.”

---

# Step 2 — NGINX receives the request

NGINX is the first thing that receives the request.

Think of NGINX like a security guard or receptionist.

It is the ONLY container that the outside world can directly access.

This means:

✅ Browser can talk to NGINX

❌ Browser cannot directly talk to:

* MariaDB
* Redis
* WordPress
* FTP
* Adminer

This improves security.

---

# What does “only NGINX is exposed” REALLY mean?

It means:

Only NGINX opens ports to your computer.

For example:

```text id="n8e4ys"
localhost:443 -> NGINX
```

But MariaDB is hidden inside Docker.

So nobody from outside can directly access your database.

The database only accepts connections from containers inside Docker.

---

# Step 3 — NGINX forwards the request

NGINX checks the request and sends it to the correct service.

Example:

```text id="7plq6h"
Browser asks for website
        |
        v
NGINX forwards request
        |
        v
WordPress container
```

This is called a reverse proxy.

NGINX acts like a middleman between the user and the application.

---

# Step 4 — WordPress creates the webpage

WordPress is the application itself.

It:

* creates pages
* handles logins
* loads posts
* manages plugins
* generates HTML

But WordPress needs data.

For example:

* users
* passwords
* blog posts
* comments

So it asks the database.

---

# Step 5 — MariaDB sends data

MariaDB stores all website information.

Think of it like storage memory for the website.

WordPress asks:

> “Give me all blog posts.”

MariaDB returns the data.

---

# Step 6 — Website returns to the browser

The flow goes back:

```text id="e7g7du"
MariaDB
   |
WordPress
   |
NGINX
   |
Browser
```

Then the user finally sees the webpage.

---

# Why Docker is important

Without Docker:

* everything installs directly on Linux
* services can conflict
* configuration becomes messy

With Docker:

* every service is isolated
* easier to manage
* easier to restart
* cleaner structure

Example:

```text id="vbm1iz"
Container 1 -> NGINX
Container 2 -> WordPress
Container 3 -> MariaDB
```

Each container has its own environment.

---
we seperate each service like backend-database-frontend in seperated container
so we need to run each container separately and connect those containers together.
so we use docker compose
we have services in the compose.yaml file and inside that we have services that we put containers that we wanna run together
# Why Docker Compose is used

Docker Compose helps start all containers together.

Instead of starting services one by one:

```bash id="c26v2h"
docker run ...
docker run ...
docker run ...
```

you simply use:

```bash id="mzebt6"
docker compose up
```

Docker Compose:

* creates containers
* creates networks
* connects services
* mounts volumes
* starts everything automatically

---

# Why a Docker Network is used

Containers need to communicate safely.

Docker creates a private network.

Inside this network:

```text id="v7m3qs"
WordPress -> MariaDB
WordPress -> Redis
NGINX -> WordPress
```

Containers communicate using service names.

Example:

```text id="0umqjk"
mariadb
wordpress
redis
```

instead of IP addresses.

---

# Why volumes are important

Containers are temporary.

If a container is deleted, its files disappear.

Volumes solve this problem.

Volumes store data permanently outside containers.

Your project uses volumes for:

* WordPress files
* MariaDB database

So even if containers restart:

✅ website stays
✅ database stays
✅ posts stay

---

# Why secrets are used

Passwords should not be written directly inside code.

Secrets store sensitive information separately.

Examples:

* database password
* WordPress password
* FTP password

Containers read these passwords at runtime.

This is safer than hardcoding credentials.

---

# HTTPS / SSL

Your website uses HTTPS.

Example:

```text id="yyh0my"
https://oshcheho.42.fr
```

HTTPS encrypts communication between:

* browser
* server

This prevents others from reading data during transfer.

NGINX handles SSL certificates.

---

# Bonus Services Explained

---

# Redis

Redis is used for caching.

Caching means:

> store frequently used data in memory to make the website faster.

Instead of asking MariaDB every time:

```text id="6ho6fn"
WordPress -> Redis -> fast response
```

This reduces database load.

---

# FTP Server

FTP allows remote file management.

You can:

* upload files
* edit WordPress files
* manage content

without entering containers manually.

The FTP container shares the same files as WordPress.

---

# Adminer

Adminer is a web interface for MariaDB.

Instead of typing SQL commands manually, you get a graphical interface.

You can:

* view tables
* edit database rows
* run SQL queries
* debug database issues

---

# Flask Monitoring Dashboard

This is your custom monitoring system.

Built using:

* Python
* Flask

It checks whether services are alive.

Example:

```text id="3x4sj2"
NGINX -> OK
MariaDB -> OK
Redis -> OK
```

This simulates real production monitoring.

---

# cAdvisor

cAdvisor monitors Docker containers.

It shows:

* CPU usage
* RAM usage
* network usage
* disk usage

This helps understand container performance.

---

# Main Concepts Learned

## Infrastructure

I learned how multiple services work together to create one complete application.
For example:

* NGINX receives requests
* WordPress generates the website
* MariaDB stores data

I learned how these services depend on each other and communicate together.

---

## Reverse Proxy

I learned how NGINX works as a middle layer between the user and the application.

The browser sends requests to NGINX first, and NGINX forwards them internally to the correct container like WordPress.

This improves:

* security
* organization
* HTTPS handling

---

## Service Isolation

I learned that every service should run separately inside its own Docker container.

For example:

* NGINX container only handles web traffic
* MariaDB container only handles database operations
* Redis container only handles caching

This makes the system:

* cleaner
* easier to manage
* safer
* easier to debug

---

## Networking

I learned how containers communicate through Docker networks.

Containers can talk to each other using service names like:

```text id="ljh88s"
wordpress
mariadb
redis
```

instead of IP addresses.

I also learned how internal services stay hidden from outside users.

---

## Persistent Storage

I learned how Docker volumes keep data even after containers stop or restart.

Without volumes:

* database data would be lost
* WordPress files would disappear

With volumes:

* website data remains saved permanently

---

## Monitoring

I learned how to monitor containers and services in real time.

Using:

* Flask dashboard
* cAdvisor

I could check:

* service status
* CPU usage
* memory usage
* network activity

This helped me understand how infrastructure behaves while running.


# Final Simple Summary

This project is basically:

> Building your own mini web hosting infrastructure using Docker.

You created:

* a secure web server
* a database server
* a WordPress application
* caching
* monitoring
* networking
* persistent storage

All services are separated into containers and connected together like a real production environment.

