# docker exec -it WORDPRESS /bin/bash
# mysql -h mariadb -u user -p

FROM debian:buster

EXPOSE 9000

RUN apt-get update -y && apt-get install -y \
	php7.3-fpm \
	php7.3-mysql \
	mariadb-client \
	wget

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d

WORKDIR /var/www/html

RUN wget http://wordpress.org/latest.tar.gz && \
	tar xfz latest.tar.gz && \
	mv wordpress/* ./ && \
	rm -rf wordpress && \
	rm -f latest.tar.gz && \
	rm -f index.html

#COPY ./html/index.html ./index.html
#config file wp-config.php
#COPY ./conf/wp-config.php ./wp-config.php
#RUN cp wp-config-sample.php wp-config.php

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /bin/wp

RUN mkdir /run/php

COPY ./conf/script.sh ./script.sh
RUN chmod +x script.sh

CMD ["bash", "./script.sh"]