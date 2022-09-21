# include ./srcs/.env
LOGIN=aenglert
DOMAIN_NAME=$(LOGIN).42.fr
NETWORK=inception
DATA_PATH=/home/$(LOGIN)/data/
REQUIREMENTS_PATH=./requirements/

DB_DATA_PATH=$(DATA_PATH)mariadb/
DB_HOST=mariadb
DB_NAME=wordpress_db
DB_USER=user
DB_USER_PASSWORD=password
DB_ROOT_PASSWORD=root

WP_DATA_PATH=$(DATA_PATH)wordpress/
WP_TITLE=42inception
WP_URL=https://$(DOMAIN_NAME)
WP_USER=user
WP_USER_MAIL=user@example.com
WP_USER_PASSWORD=password
WP_ADMIN=god
WP_ADMIN_MAIL=god@example.com
WP_ADMIN_PASSWORD=password

all:
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
	DB_DATA_PATH=$(DB_DATA_PATH)\n\
	DB_HOST=$(DB_HOST)\n\
	DB_NAME=$(DB_NAME)\n\
	DB_USER=$(DB_USER)\n\
	DB_USER_PASSWORD=$(DB_USER_PASSWORD)\n\
	DB_ROOT_PASSWORD=$(DB_ROOT_PASSWORD)\n\
	WP_DATA_PATH=$(WP_DATA_PATH)\n\
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
