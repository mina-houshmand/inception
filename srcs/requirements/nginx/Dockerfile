FROM debian:bookworm

# Install Nginx and OpenSSL
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    apt-get clean && rm -rf /var/lib/apt/lists/*


# Create SSL directory and runtime folder
RUN install -d -m 700 /etc/nginx/ssl /var/run/nginx

# generate certificate
RUN openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/inception.key \
  -out /etc/nginx/ssl/inception.crt \
  -subj "/C=CH/ST=VD/L=Vienna/O=42/OU=42/CN=mhoushma.42.fr/UID=mhoushma"


# config
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Set up website directory
RUN mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html && \
    chmod 755 /var/www/html

EXPOSE 443

# runs in foreground
CMD ["nginx", "-g", "daemon off;"]