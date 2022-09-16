#!/bin/bash

cd /var/www/html

#wp config create --allow-root

wp core config --dbhost=$DB_HOSTNAME \
				--dbname=$DB_NAME \
				--dbuser=$DB_USER \
				--dbpass=$DB_USER_PASSWORD \
				--allow-root

wp core install --title=$WP_TITLE \
				--admin_user=$WP_ADMIN \
				--admin_password=$WP_ADMIN_PASSWORD \
				--admin_email=$WP_ADMIN_MAIL \
				--url=$WP_URL \
				--allow-root

wp user create $WP_USER $WP_USER_MAIL --role=author --user_pass=$WP_USER_PASSWORD --allow-root

php-fpm7.3 --nodaemonize #--allow-root