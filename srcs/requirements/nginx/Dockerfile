FROM debian:bookworm

# install dependencies
RUN apt update && apt upgrade -y && \
    apt install -y nginx openssl curl vim sudo bash && \
    rm -rf /var/lib/apt/lists/*

# create SSL folder
RUN mkdir -p /etc/nginx/ssl

# generate certificate
RUN openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/inception.key \
  -out /etc/nginx/ssl/inception.crt \
  -subj "/C=CH/ST=VD/L=Lausanne/O=42/OU=42/CN=falberti.42.fr/UID=falberti"

# nginx runtime folder
RUN mkdir -p /var/run/nginx

# config
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/default.conf /etc/nginx/conf.d/default.conf

# permissions
RUN chmod 755 /var/www/html && \
    chown -R www-data:www-data /var/www/html

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]