# SETTINGS
# variables can be edited to customize the docker infrastructure
# IMPORTANT! Please delete or comment out sensitive DEFAULT VALUES to get prompted for CUSTOM VALUES!
LOGIN=aenglert
DOMAIN_NAME=$(LOGIN).42.fr
NETWORK=inception
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
DB_ROOT_PASSWORD=root
DB_ROOT_PASSWORD?=$(shell read -p "Please enter password for MariaDB root user: " dbrootpw; printf "$$dbrootpw")
DB_USER=dbuser# DEFAULT VALUE should be deleted or commented out, to get prompted for CUSTOM VALUE
DB_USER?=$(shell read -p "Please enter username for MariaDB user: " dbuser; printf "$$dbuser")
DB_USER_PASSWORD=password# DEFAULT VALUE should be deleted or commented out, to get prompted for CUSTOM VALUE
DB_USER_PASSWORD?=$(shell read -p "Please enter password for MariaDB user: " dbuserpw; printf "$$dbuserpw")

WP_DATA_PATH=$(DATA_PATH)wordpress/
WP_VOLUME=/var/www/html
WP_TITLE=42inception
WP_URL=https://$(DOMAIN_NAME)
WP_ADMIN=wpadmin# DEFAULT VALUE should be deleted or commented out, to get prompted for CUSTOM VALUE
WP_ADMIN?=$(shell read -p "Please enter username for WordPress admin: " wpadmin; printf "$$wpadmin")
WP_ADMIN_MAIL=admin@example.com
WP_ADMIN_PASSWORD=password# DEFAULT VALUE should be deleted or commented out, to get prompted for CUSTOM VALUE
WP_ADMIN_PASSWORD?=$(shell read -p "Please enter password for WordPress admin: " wpadminpw; printf "$$wpadminpw")
WP_USER=wpuser# DEFAULT VALUE should be deleted or commented out, to get prompted for CUSTOM VALUE
WP_USER?=$(shell read -p "Please enter username for WordPress user: " wpuser; printf "$$wpuser")
WP_USER_MAIL=user@example.com
WP_USER_PASSWORD=password# DEFAULT VALUE should be deleted or commented out, to get prompted for CUSTOM VALUE
WP_USER_PASSWORD?=$(shell read -p "Please enter password for WordPress user: " wpuserpw; printf "$$wpuserpw")


all: init start

# creates .env and config files
init: env mariadb_conf php_conf
	sudo hostsed add 127.0.0.1 $(DOMAIN_NAME)
	sudo mkdir -p $(DB_DATA_PATH) $(WP_DATA_PATH)

start:
	@echo "build & run"
	@cd srcs && \
	sudo docker-compose up --build -d && \
	cd .. && \
	echo "running..."

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
	yes | sudo docker system prune -a
	sudo rm -rf $(DB_DATA_PATH)*
	sudo rm -rf $(WP_DATA_PATH)*
	sudo hostsed rm 127.0.0.1 $(DOMAIN_NAME)

re: fclean all

# extra '$' needed to let the shell do the command substitution
# - for ignoring errors
eva:
	-sudo docker stop $$(sudo docker ps -qa)
	-sudo docker rm $$(sudo docker ps -qa)
	-sudo docker rmi -f $$(sudo docker images -qa)
	-sudo docker volume rm $$(sudo docker volume ls -q)
	-sudo docker network rm $$(sudo docker network ls -q) 2>/dev/null

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
	DB_ROOT_PASSWORD=$(DB_ROOT_PASSWORD)\n\
	DB_USER=$(DB_USER)\n\
	DB_USER_PASSWORD=$(DB_USER_PASSWORD)\n\
	WP_DATA_PATH=$(WP_DATA_PATH)\n\
	WP_VOLUME=$(WP_VOLUME)\n\
	WP_TITLE=$(WP_TITLE)\n\
	WP_URL=$(WP_URL)\n\
	WP_ADMIN=$(WP_ADMIN)\n\
	WP_ADMIN_MAIL=$(WP_ADMIN_MAIL)\n\
	WP_ADMIN_PASSWORD=$(WP_ADMIN_PASSWORD)\n\
	WP_USER=$(WP_USER)\n\
	WP_USER_MAIL=$(WP_USER_MAIL)\n\
	WP_USER_PASSWORD=$(WP_USER_PASSWORD)\n\
	" > ./srcs/.env

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

php_conf:
	@echo "\
	[www]\n\
	user = www-data\n\
	group = www-data\n\
	listen = $(WORDPRESS_PORT)\n\
	pm = dynamic\n\
	pm.max_children = 5\n\
	pm.start_servers = 2\n\
	pm.min_spare_servers = 1\n\
	pm.max_spare_servers = 3\n\
	clear_env = no\
	" > ./srcs/requirements/wordpress/conf/www.conf

.PHONY: all init start stop clean fclean re eva env mariadb_conf nginx_conf php_conf