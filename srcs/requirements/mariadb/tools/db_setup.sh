#!/bin/bash

service mysql start

mariadb -u root -e "CREATE DATABASE ${DB_NAME};"
mariadb -u root -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';"
mariadb -u root -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"