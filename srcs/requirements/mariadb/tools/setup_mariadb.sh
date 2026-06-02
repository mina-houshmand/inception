#!/bin/bash
# makes the script fail fast and avoid silent errors.
set -euo pipefail

# environment validation
: "${MARIADB_ROOT_PASSWORD:?MARIADB_ROOT_PASSWORD must be set}"
MARIADB_DATABASE="${MARIADB_DATABASE:-}"
MARIADB_USER="${MARIADB_USER:-}"
MARIADB_PASSWORD="${MARIADB_PASSWORD:-}"

# Directory Setup and assigns ownership to the mysql user.
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Initial Database Setup only on first run.
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "First initialization detected — setting up MariaDB..."

    mysql_install_db --user=mysql --ldata=/var/lib/mysql
fi

echo "Starting temporary MariaDB server..."

# Start Temporary Server in the background .
mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
temp_pid=$!


# Waits up to 30 seconds for the socket file to appear. if it doesn't ...
echo "Waiting for MariaDB to be ready..."
for i in {30..0}; do
    if [ -S /run/mysqld/mysqld.sock ]; then
        break
    fi
    sleep 1
done


# If it doesn't appear, it assumes the server failed to start and exits with an error.
if [ ! -S /run/mysqld/mysqld.sock ]; then
    echo "MariaDB did not start properly — aborting setup."
    kill "$temp_pid" || true
    exit 1
fi

# Sets the root password via SQL commands.
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Configuring initial root password..."
    mariadb -u root <<-EOSQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOSQL
fi


# Creates WordPress database, user, and grants permissions.
# if -> Checks if all three variables have values (not empty)
# it sets up a separate database and user account for WordPress to use, 
# so WordPress doesn't have root access—just access to its own database.
echo "Ensuring WordPress database and user exist..."
if [ -n "$MARIADB_DATABASE" ] && [ -n "$MARIADB_USER" ] && [ -n "$MARIADB_PASSWORD" ]; then
    mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" <<-EOSQL
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MARIADB_USER}\`@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE}\`.* TO \`${MARIADB_USER}\`@'%';
FLUSH PRIVILEGES;
EOSQL
fi

# Stops the temporary server and waits for it to finish.
mysqladmin -u root -p"${MARIADB_ROOT_PASSWORD}" shutdown
wait "$temp_pid" || true

# Start Production Server
echo "Starting MariaDB in foreground..."
exec mysqld --user=mysql --console
