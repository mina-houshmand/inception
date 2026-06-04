#!/bin/bash
set -e

echo "⏳ Waiting for MariaDB to be ready..."
while ! mariadb -h"${MARIADB_HOST}" -u"${MARIADB_USER}" -p"${MARIADB_PASSWORD}" -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 2
done
echo "✅ Database is ready!"

cd /var/www/html

# ----------------------------------------
# 1. Download WordPress if needed
# ----------------------------------------
if [ ! -f "wp-load.php" ]; then
    echo "⬇️ Downloading WordPress..."
    wp core download --allow-root
fi

# ----------------------------------------
# 2. Create wp-config if missing
# ----------------------------------------
if [ ! -f "wp-config.php" ]; then
    echo "⚙️ Creating wp-config.php..."

    wp config create \
        --allow-root \
        --dbname="${MARIADB_DATABASE}" \
        --dbuser="${MARIADB_USER}" \
        --dbpass="${MARIADB_PASSWORD}" \
        --dbhost="${MARIADB_HOST}"
fi

# ----------------------------------------
# 3. Install WordPress ONLY once
# ----------------------------------------
echo "🛠 Checking WordPress installation..."

if ! wp option get siteurl --allow-root >/dev/null 2>&1; then
    echo "🛠 Installing WordPress..."

    wp core install \
        --allow-root \
        --url="${WP_PATH}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN_EMAIL}"
else
    echo "✅ WordPress already installed"
fi

# ----------------------------------------
# 4. SYNC ADMIN USER FROM .ENV (EVERY RUN)
# ----------------------------------------
echo "👑 Syncing admin user from .env..."

if wp user get "${WP_ADMIN_USER}" --allow-root >/dev/null 2>&1; then
    wp user update "${WP_ADMIN_USER}" \
        --user_email="${WP_ADMIN_EMAIL}" \
        --user_pass="${WP_ADMIN_PASS}" \
        --role=administrator \
        --allow-root
else
    wp user create "${WP_ADMIN_USER}" "${WP_ADMIN_EMAIL}" \
        --user_pass="${WP_ADMIN_PASS}" \
        --role=administrator \
        --allow-root
fi

# ----------------------------------------
# 5. SYNC NORMAL USER FROM .ENV (EVERY RUN)
# ----------------------------------------
echo "👤 Syncing normal user from .env..."

if wp user get "${WP_USER}" --allow-root >/dev/null 2>&1; then
    wp user update "${WP_USER}" \
        --user_email="${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PWD}" \
        --role=author \
        --allow-root
else
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PWD}" \
        --role=author \
        --allow-root
fi

# ----------------------------------------
# 6. Sync site title
# ----------------------------------------
echo "📝 Ensuring site title matches env..."

CURRENT_TITLE=$(wp option get blogname --allow-root)
if [ "${CURRENT_TITLE}" != "${WP_TITLE}" ]; then
    wp option update blogname "${WP_TITLE}" --allow-root
fi

# ----------------------------------------
# 7. Permissions
# ----------------------------------------
chown -R www-data:www-data /var/www/html

# ----------------------------------------
# 8. Start PHP-FPM
# ----------------------------------------
echo "🚀 Starting PHP-FPM..."
exec php-fpm8.2 -F

