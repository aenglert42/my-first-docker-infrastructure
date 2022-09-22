LOGIN=aenglert
DOMAIN_NAME=$(LOGIN).42.fr
NETWORK=inception
# local directorys
DATA_PATH=/home/$(LOGIN)/data/
REQUIREMENTS_PATH=./requirements/

CERT=/etc/ssl/certificate.pem
KEY=/etc/ssl/privatekey.pem

NGINX_CONTAINER_NAME=NGINX
NGINX_PORT=443
MARIADB_CONTAINER_NAME=MARIADB
MARIADB_PORT=3306
WORDPRESS_CONTAINER_NAME=WORDPRESS
WORDPRESS_PORT=9000

DB_DATA_PATH=$(DATA_PATH)mariadb/
DB_VOLUME=/var/lib/mysql
DB_HOST=mariadb
DB_NAME=wordpress_db
DB_USER=user
DB_USER_PASSWORD=password
DB_ROOT_PASSWORD=root

WP_DATA_PATH=$(DATA_PATH)wordpress/
WP_VOLUME=/var/www/html
WP_TITLE=42inception
WP_URL=https://$(DOMAIN_NAME)
WP_USER=user
WP_USER_MAIL=user@example.com
WP_USER_PASSWORD=password
WP_ADMIN=god
WP_ADMIN_MAIL=god@example.com
WP_ADMIN_PASSWORD=password

all: env mariadb_conf
	sudo hostsed add 127.0.0.1 $(DOMAIN_NAME)
	sudo mkdir -p $(DB_DATA_PATH) $(WP_DATA_PATH)
	@echo "build & run"
	@cd srcs && \
	sudo docker-compose up --build -d && \
	cd .. && \
	echo "running..."

env:
	@echo "\
	LOGIN=$(LOGIN)\n\
	DOMAIN_NAME=$(DOMAIN_NAME)\n\
	NETWORK=$(NETWORK)\n\
	DATA_PATH=$(DATA_PATH)\n\
	REQUIREMENTS_PATH=$(REQUIREMENTS_PATH)\n\
	CERT=$(CERT)\n\
	KEY=$(KEY)\n\
	NGINX_CONTAINER_NAME=$(NGINX_CONTAINER_NAME)\n\
	NGINX_PORT=$(NGINX_PORT)\n\
	MARIADB_CONTAINER_NAME=$(MARIADB_CONTAINER_NAME)\n\
	MARIADB_PORT=$(MARIADB_PORT)\n\
	WORDPRESS_CONTAINER_NAME=$(WORDPRESS_CONTAINER_NAME)\n\
	WORDPRESS_PORT=$(WORDPRESS_PORT)\n\
	DB_DATA_PATH=$(DB_DATA_PATH)\n\
	DB_VOLUME=$(DB_VOLUME)\n\
	DB_HOST=$(DB_HOST)\n\
	DB_NAME=$(DB_NAME)\n\
	DB_USER=$(DB_USER)\n\
	DB_USER_PASSWORD=$(DB_USER_PASSWORD)\n\
	DB_ROOT_PASSWORD=$(DB_ROOT_PASSWORD)\n\
	WP_DATA_PATH=$(WP_DATA_PATH)\n\
	WP_VOLUME=$(WP_VOLUME)\n\
	WP_TITLE=$(WP_TITLE)\n\
	WP_URL=$(WP_URL)\n\
	WP_USER=$(WP_USER)\n\
	WP_USER_MAIL=$(WP_USER_MAIL)\n\
	WP_USER_PASSWORD=$(WP_USER_PASSWORD)\n\
	WP_ADMIN=$(WP_ADMIN)\n\
	WP_ADMIN_MAIL=$(WP_ADMIN_MAIL)\n\
	WP_ADMIN_PASSWORD=$(WP_ADMIN_PASSWORD)\n\
	" > ./srcs/.env

stop:
	@echo "stopping..."
	@cd srcs && \
	sudo docker-compose down && \
	cd .. && \
	echo "stopped"

clean: stop
	@echo "cleaning..."
	@cd srcs && \
	sudo docker-compose down --rmi all -v && \
	cd .. && \
	echo "cleaned"

fclean: clean
	sudo docker system prune -a
	sudo rm -rf $(DB_DATA_PATH)*
	sudo rm -rf $(WP_DATA_PATH)*
	sudo hostsed rm 127.0.0.1 $(DOMAIN_NAME)

re: fclean all

# extra '$' needed to let the shell do the command substitution
nuke:
	sudo docker stop $$(sudo docker ps -qa); \
	sudo docker rm $$(sudo docker ps -qa); \
	sudo docker rmi -f $$(sudo docker images -qa); \
	sudo docker volume rm $$(sudo docker volume ls -q); \
	sudo docker network rm $$(sudo docker network ls -q) 2>/dev/null

nuke2:
	sudo rm -rf $(DB_DATA_PATH)*
	sudo rm -rf $(WP_DATA_PATH)*
	sudo docker stop $$(sudo docker ps -qa); \
	sudo docker rm $$(sudo docker ps -qa); \
	sudo docker rmi -f $$(sudo docker images -qa); \
	sudo docker volume rm $$(sudo docker volume ls -q); \
	sudo docker network rm $$(sudo docker network ls -q) 2>/dev/null

mariadb_conf:
	@echo "\
	[server]\n\n\
	[mysqld]\n\n\
	user					= mysql\n\
	pid-file				= /run/mysqld/mysqld.pid\n\
	socket					= /run/mysqld/mysqld.sock\n\
	port					= $(MARIADB_PORT)\n\
	basedir					= /usr\n\
	datadir					= $(DB_VOLUME)\n\
	tmpdir					= /tmp\n\
	lc-messages-dir			= /usr/share/mysql\n\n\
	query_cache_size		= 16M\n\n\
	log_error				= /var/log/mysql/error.log\n\
	expire_logs_days		= 10\n\n\
	character-set-server	= utf8mb4\n\
	collation-server		= utf8mb4_general_ci\n\n\
	[embedded]\n\n\
	[mariadb]\n\n\
	[mariadb-10.3]\
	" > ./srcs/requirements/mariadb/conf/50-server.cnf

# extra "\$" for correct echo putput
nginx_conf:
	@echo "\
	server {\n\
		listen $(NGINX_PORT) ssl;\n\n\
		server_name $(DOMAIN_NAME);\n\n\
		ssl_certificate $(CERT);\n\
		ssl_certificate_key $(KEY);\n\
		ssl_protocols TLSv1.3;\n\n\
		root $(WP_VOLUME);\n\
		index index.php;\n\n\
		location / {\n\
				try_files \$$uri \$$uri/ =404;\n\
		}\n\n\
		location ~ \.php\$$ {\n\
			fastcgi_pass $(WORDPRESS_CONTAINER_NAME):$(WORDPRESS_PORT);\n\
			fastcgi_index index.php;\n\
			fastcgi_param SCRIPT_FILENAME \$$document_root\$$fastcgi_script_name;\n\
			include fastcgi_params;\n\
		}\n\
	}\
	" > ./srcs/requirements/nginx/conf/nginx.conf