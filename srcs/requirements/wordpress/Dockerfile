FROM debian:buster

RUN apt-get update -y && apt-get install -y \
	php7.3-fpm \
	php7.3-mysql \
	mariadb-client \
	wget

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d
RUN mkdir /run/php

ARG WP_VOLUME=${WP_VOLUME}
ARG DB_HOST=${DB_HOST}
ARG DB_NAME=${DB_NAME}
ARG DB_USER=${DB_USER}
ARG DB_USER_PASSWORD=${DB_USER_PASSWORD}
ARG DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD}
ARG WP_VOLUME=${WP_VOLUME}
ARG WP_TITLE=${WP_TITLE}
ARG WP_URL=${WP_URL}
ARG WP_USER=${WP_USER}
ARG WP_USER_MAIL=${WP_USER_MAIL}
ARG WP_USER_PASSWORD=${WP_USER_PASSWORD}
ARG WP_ADMIN=${WP_ADMIN}
ARG WP_ADMIN_MAIL=${WP_ADMIN_MAIL}
ARG WP_ADMIN_PASSWORD=${WP_ADMIN_PASSWORD}

WORKDIR ${WP_VOLUME}

RUN wget http://wordpress.org/latest.tar.gz && \
	tar xfz latest.tar.gz && \
	mv wordpress/* ./ && \
	rm -rf wordpress && \
	rm -f latest.tar.gz && \
	rm -f index.html

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /bin/wp

# COPY ./tools/wp_setup.sh ./wp_setup.sh
# RUN chmod +x wp_setup.sh

RUN wp core config --dbhost=${DB_HOST} \
				--dbname=${DB_NAME} \
				--dbuser=${DB_USER} \
				--dbpass=${DB_USER_PASSWORD} \
				--allow-root

RUN wp core install --title=${WP_TITLE} \
				--admin_user=${WP_ADMIN} \
				--admin_password=${WP_ADMIN_PASSWORD} \
				--admin_email=${WP_ADMIN_MAIL} \
				--url=${WP_URL} \
				--allow-root

RUN wp user create ${WP_USER} ${WP_USER_MAIL} --role=author --user_pass=${WP_USER_PASSWORD} --allow-root


CMD ["php-fpm7.3", "--nodaemonize"]