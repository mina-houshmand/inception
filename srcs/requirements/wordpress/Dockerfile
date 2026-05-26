FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget curl bash php php-fpm php-mysql mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php /var/www/html

# Download WordPress
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www && \
    tar -xzf /var/www/wordpress-6.0-fr_FR.tar.gz -C /var/www && \
    rm /var/www/wordpress-6.0-fr_FR.tar.gz

# Move WordPress into correct folder
RUN mv /var/www/wordpress/* /var/www/html/

# Permissions
RUN chown -R www-data:www-data /var/www/html

# PHP-FPM config
RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/*/fpm/pool.d/www.conf

# WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY conf/auto_config.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["bash", "/entrypoint.sh"]y