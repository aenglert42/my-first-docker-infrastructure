FROM debian:buster

RUN apt-get update -y && apt-get install -y \
	openssl \
	nginx

ARG CERT=${CERT}
ARG KEY=${KEY}

# Create SSl certificate and key
RUN openssl req -newkey rsa:4096 -x509 -sha512 -days 365 -nodes -out ${CERT} -keyout ${KEY} -subj /CN=${DOMAIN_NAME}

# nginx config
COPY ./conf/nginx.conf /etc/nginx/sites-available/default

CMD ["nginx", "-g", "daemon off;"]