FROM debian:bookworm

RUN apt update && apt upgrade -y && \
    apt install -y mariadb-server tini && \
    rm -rf /var/lib/apt/lists/*

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

COPY tools/setup_mariadb.sh /tmp/setup_mariadb.sh
RUN chmod +x /tmp/setup_mariadb.sh

EXPOSE 3306

# Use tini as init system (BEST PRACTICE)
ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["/tmp/setup_mariadb.sh"]