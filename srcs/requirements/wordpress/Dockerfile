FROM debian:bookworm

# WordPress container: PHP-FPM only, no nginx in this image.
RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    curl \
    wget \
    mariadb-client \
    less \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php /var/www/html

# Download WordPress
RUN wget https://wordpress.org/wordpress-6.0.tar.gz -P /var/www && \
    tar -xzf /var/www/wordpress-6.0.tar.gz -C /var/www && \
    rm /var/www/wordpress-6.0.tar.gz

# Move WordPress into correct folder
RUN mv /var/www/wordpress/* /var/www/html/

# Permissions
RUN chown -R www-data:www-data /var/www/html

# PHP-FPM config
RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/*/fpm/pool.d/www.conf

# Install wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Startup script installs/configures WordPress, then runs php-fpm only.
COPY conf/auto_config.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["bash", "/entrypoint.sh"]