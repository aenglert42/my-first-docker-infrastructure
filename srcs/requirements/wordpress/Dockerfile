FROM debian:buster

RUN apt-get update -y && apt-get install -y \
	php7.3-fpm \
	php7.3-mysql \
	mariadb-client \
	wget

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d
RUN mkdir /run/php

ARG WP_VOLUME=${WP_VOLUME}

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

COPY ./tools/wp_setup.sh ./wp_setup.sh
RUN chmod +x wp_setup.sh

CMD ["bash", "./wp_setup.sh"]