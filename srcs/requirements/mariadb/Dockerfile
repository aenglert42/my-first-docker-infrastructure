FROM debian:buster

EXPOSE 3306

RUN apt-get update -y && apt-get install -y mariadb-server
	
#RUN mysql_secure_installation

ARG DB_NAME=${DB_NAME}
ARG DB_USER=${DB_USER}
ARG DB_USER_PASSWORD=${DB_USER_PASSWORD}
ARG DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD}

# Create Database and User
#RUN service mysql start
#RUN mariadb -u root -e "CREATE DATABASE ${DB_NAME};"
###RUN mariadb -u root -e "SHOW DATABASES";
###RUN mariadb -u root -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';"
## RUN mariadb -u root -e "SELECT User FROM mysql.user;"
###RUN mariadb -u root -e "USE ${DB_NAME};"
#RUN mariadb -u root -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}' WITH GRANT OPTION;"
###RUN mariadb -u root -e "SHOW GRANTS";
#RUN mariadb -u root -e "ALTER USER 'root'@'localhost' identified by '${DB_ROOT_PASSWORD}';"

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/db_setup.sh /db_setup.sh
RUN bash ./db_setup.sh

CMD ["mysqld_safe"]