#!/bin/bash

cd /var/www/html

if [ ! -f wp-config.php ]; then
    # Get latest WP source
    wget https://wordpress.org/latest.tar.gz

    tar -xvf latest.tar.gz

    cp -rf wordpress/* .

    rm -rf wordpress latest.tar.gz

    cp wp-config-sample.php wp-config.php

    sed -i "s/database_name_here/${MYSQL_DATABASE}/g" wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/g" wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/g" wp-config.php
    sed -i "s/localhost/mariadb/g" wp-config.php
fi

mkdir -p /run/php

# IMPORTANT: make sure PHP-FPM runs correctly
exec php-fpm7.4 -F
