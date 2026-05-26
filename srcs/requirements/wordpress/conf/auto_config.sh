#!/bin/bash
set -e

# Wait for MariaDB to be ready
echo "⏳ Waiting for MariaDB to be ready..."
while ! mariadb -h"${MARIADB_HOST}" -u"${MARIADB_USER}" -p"${MARIADB_PASSWORD}" -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 2
done
echo "✅ Database is ready!"


cd /var/www/html

# If WordPress files are missing, download them
if [ ! -f "wp-load.php" ]; then
    echo "⬇️ Downloading WordPress..."
    wp core download --allow-root
fi

# Download WordPress core if not already present
if [ ! -f "wp-config.php" ]; then
    echo "⚙️ Setting up wp-config.php..."
    wp config create \
        --allow-root \
        --dbname="${MARIADB_DATABASE}" \
        --dbuser="${MARIADB_USER}" \
        --dbpass="${MARIADB_PASSWORD}" \
        --dbhost="${MARIADB_HOST}" 

    echo "🛠 Installing WordPress..."
    wp core install \
        --allow-root \
        --url="${WP_PATH}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN_EMAIL}"
    
    echo "👤 Creating secondary user..."
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" --role=author --user_pass="${WP_USER_PWD}" --allow-root
else
    echo "🔁 WordPress already configured — skipping installation."
fi

echo "📝 Ensuring site title matches the environment..."
CURRENT_TITLE=$(wp option get blogname --allow-root)
if [ "${CURRENT_TITLE}" != "${WP_TITLE}" ]; then
    wp option update blogname "${WP_TITLE}" --allow-root
fi

# Fix permissions
chown -R www-data:www-data /var/www/html

echo "🚀 Starting PHP-FPM..."
exec php-fpm8.2 -F
