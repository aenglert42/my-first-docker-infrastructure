FROM debian:buster

RUN apt-get update -y
# use update and install in the same RUN command


# Install PHP
RUN apt-get install php php-mysql -y

# Install mariadb client
RUN apt-get install mariadb-client -y

WORKDIR /var/www/html
#don't use ADD, use wget or curl instead
ADD http://wordpress.org/latest.tar.gz ./latest.tar.gz
RUN tar xfz latest.tar.gz
#move files to /var/www/html/
RUN mv wordpress/* ./
RUN rm -f latest.tar.gz
RUN rm index.html index.nginx-debian.html
#config file wp-config.php
COPY ./conf/wp-config.php ./wp-config.php
#RUN mv wp-config-sample.php wp-config.php
ADD https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /bin/wp
RUN chmod +x /bin/wp

# Install nginx
	RUN apt-get install nginx -y
	## Enable UFW profile "Nginx HTTPS". This profile opens only port 443 (TLS/SSL encrypted traffic)
##	RUN ufw allow 'Nginx HTTPS'

# Create SSl certificate and key
	RUN openssl req -newkey rsa:4096 -x509 -sha512 -days 365 -nodes -out /etc/ssl/certificate.pem -keyout /etc/ssl/privatekey.pem -subj "/CN=aenglert.42.fr"

COPY ./html /usr/share/nginx/html
# nginx config
COPY ./conf/wordpress.conf /etc/nginx/sites-available/default

EXPOSE 9000

# use ENTRYPOINT and CMD, maybe script for PID 1
CMD ["nginx", "-g", "daemon off;"]