FROM debian:buster

RUN apt-get update -y && apt-get install -y \
	openssl \
	nginx

# Create SSl certificate and key
RUN openssl req -newkey rsa:4096 -x509 -sha512 -days 365 -nodes -out /etc/ssl/certificate.pem -keyout /etc/ssl/privatekey.pem -subj "/CN=aenglert.42.fr"

#COPY ./html /usr/share/nginx/html
# nginx config
COPY ./conf/nginx.conf /etc/nginx/sites-available/default

CMD ["nginx", "-g", "daemon off;"]