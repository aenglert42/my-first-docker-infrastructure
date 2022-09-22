FROM debian:buster

#EXPOSE ${MARIADB_PORT}

RUN apt-get update -y && apt-get install -y mariadb-server

# can I remove those? or pass as env and use run?
# ARG DB_NAME=${DB_NAME}
# ARG DB_USER=${DB_USER}
# ARG DB_USER_PASSWORD=${DB_USER_PASSWORD}
# ARG DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD}

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/db_setup.sh /db_setup.sh
RUN bash ./db_setup.sh

CMD ["mysqld_safe"]