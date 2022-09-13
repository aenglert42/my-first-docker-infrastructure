FROM debian:buster

RUN apt-get update -y
##RUN apt-get upgrade -y


## Install firewall
##	RUN apt-get install ufw -y
##	RUN ufw enable
# Install openssl
	RUN apt-get install openssl -y
# Install nginx
	RUN apt-get install nginx -y
	## Enable UFW profile "Nginx HTTPS". This profile opens only port 443 (TLS/SSL encrypted traffic)
##	RUN ufw allow 'Nginx HTTPS'

# Create SSl certificate and key
	RUN openssl req -newkey rsa:4096 -x509 -sha512 -days 365 -nodes -out /etc/ssl/certificate.pem -keyout /etc/ssl/privatekey.pem -subj "/CN=aenglert.42.fr"

COPY ./html /usr/share/nginx/html
# nginx config
COPY ./conf/nginx.conf /etc/nginx/sites-available/default

#EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]