#!/bin/bash

#RED='\033[0;31m'
#CYAN='\033[0;36m'
#NC='\033[0m' # No Color

service mysql start
mariadb -u root -e "CREATE DATABASE ${DB_NAME};"
mariadb -u root -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}' WITH GRANT OPTION;"
mariadb -u root -e "ALTER USER 'root'@'localhost' identified by '${DB_ROOT_PASSWORD}';"