#!/bin/bash

service mysql start

mariadb -u root -e "CREATE DATABASE ${DB_NAME};"
mariadb -u root -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}' WITH GRANT OPTION;"
mariadb -u root -e "ALTER USER 'root'@'localhost' identified by '${DB_ROOT_PASSWORD}';"