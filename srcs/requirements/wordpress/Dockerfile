FROM debian:buster

RUN apt-get update -y && \
	apt-get install php -y && \
	apt-get install php-mysql -y && \
	apt-get install wget -y

WORKDIR /var/www/html

RUN wget http://wordpress.org/latest.tar.gz
RUN tar xfz latest.tar.gz
RUN mv wordpress/* ./
RUN rm -rf wordpress
RUN rm -f latest.tar.gz
RUN rm index.html
#COPY ./html/index.html ./index.html
#config file wp-config.php
#COPY ./conf/wp-config.php ./wp-config.php
#RUN mv wp-config-sample.php wp-config.php
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /bin/wp

EXPOSE 9000

COPY ./conf/script.sh ./script.sh
RUN chmod +x script.sh

CMD ["bash", "./script.sh"]