#!/bin/bash

service mysql start

#mariadb -u root -e "CREATE DATABASE ${DB_NAME};"
#mariadb -u root -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${DB_USER_PASSWORD}' WITH GRANT OPTION;"
#mariadb -u root -e "ALTER USER 'root'@'localhost' identified by '${DB_ROOT_PASSWORD}';"

mysql -u root -e "CREATE DATABASE ${DB_NAME};"
mysql -u root -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
mysql -u root -e "FLUSH PRIVILEGES;"
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"