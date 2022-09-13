FROM debian:buster

RUN apt-get update -y
##RUN apt-get upgrade -y


## Install firewall
##	RUN apt-get install ufw -y
##	RUN ufw enable
# Install nginx
	RUN apt-get install nginx -y
	## Enable UFW profile "Nginx HTTPS". This profile opens only port 443 (TLS/SSL encrypted traffic)
##	RUN ufw allow 'Nginx HTTPS'

COPY ./html /usr/share/nginx/html
COPY ./conf/nginx.conf /etc/nginx/sites-available/default

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]