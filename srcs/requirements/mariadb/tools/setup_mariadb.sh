#!/bin/bash
set -euo pipefail

# Basic environment validation
: "${MARIADB_ROOT_PASSWORD:?MARIADB_ROOT_PASSWORD must be set}"
MARIADB_DATABASE="${MARIADB_DATABASE:-}"
MARIADB_USER="${MARIADB_USER:-}"
MARIADB_PASSWORD="${MARIADB_PASSWORD:-}"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "First initialization detected — setting up MariaDB..."

    mysql_install_db --user=mysql --ldata=/var/lib/mysql

    echo "Starting temporary MariaDB server..."
    mysqld --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
    temp_pid=$!

    echo "Waiting for MariaDB to be ready..."
    for i in {30..0}; do
        if [ -S /run/mysqld/mysqld.sock ]; then
            break
        fi
        sleep 1
    done

    if [ ! -S /run/mysqld/mysqld.sock ]; then
        echo "MariaDB did not start properly — aborting setup."
        kill "$temp_pid" || true
        exit 1
    fi

    echo "Configuring initial users and database..."
    mariadb -u root <<-EOSQL
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOSQL

    if [ -n "$MARIADB_DATABASE" ]; then
        mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" <<-EOSQL
CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
FLUSH PRIVILEGES;
EOSQL
    fi

    if [ -n "$MARIADB_USER" ] && [ -n "$MARIADB_PASSWORD" ]; then
        mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" <<-EOSQL
CREATE USER IF NOT EXISTS \`${MARIADB_USER}\`@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MARIADB_DATABASE:-*}\`.* TO \`${MARIADB_USER}\`@'%';
FLUSH PRIVILEGES;
EOSQL
    fi

    mysqladmin -u root -p"${MARIADB_ROOT_PASSWORD}" shutdown
    wait "$temp_pid" || true
fi

echo "Starting MariaDB in foreground..."
exec mysqld --user=mysql --console
