# Use an official Debian base image (Bookworm)
FROM debian:bookworm

# Install MariaDB server and `tini` — a tiny helper that makes the container
# stop and clean up child processes correctly when it's told to stop.
# Remove apt lists to reduce final image size.
RUN apt-get update && apt-get install -y mariadb-server tini \
    && rm -rf /var/lib/apt/lists/*

# Copy a custom MariaDB server configuration into the image so the server
# starts with project-specific settings (charset, networking, etc.).
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Create `/run/mysqld` and make the `mysql` user the owner so MariaDB can
# write its socket and PID files there when it starts.
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

# Add the project initialization script into the image and make it executable.
# This script typically creates databases/users and starts the MariaDB server.
# make that file executable which we are gonna execute in CMD
COPY tools/setup_mariadb.sh /tmp/setup_mariadb.sh
RUN chmod +x /tmp/setup_mariadb.sh

# Expose the standard MariaDB port so other services or containers can connect.
# the container listens on port 3306. 
EXPOSE 3306

# Use `tini` as PID 1 to properly handle signals and child processes.
# PID 1 is the container’s “init” process
# PID must handle signals and clean up child processes. tini is a tiny init that does that for you
ENTRYPOINT ["/usr/bin/tini", "--"]

# Default command: run the setup script which will start the database and
CMD ["/tmp/setup_mariadb.sh"]

# Why PID 1  matters in containers: many services start child processes 
# If the top-level process ignores signals or doesn’t wait() for children,
# the container can hang on shutdown or accumulate defunct (zombie) processes.