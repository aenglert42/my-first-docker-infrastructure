LOGIN=aenglert
DOMAIN=$(LOGIN).42.fr
DATA_PATH=/home/$(LOGIN)/data/
MARIADB_PATH=$(DATA_PATH)mariadb/
WORDPRESS_PATH=$(DATA_PATH)wordpress/

all:
	sudo hostsed add 127.0.0.1 $(DOMAIN)
	sudo mkdir -p $(MARIADB_PATH) $(WORDPRESS_PATH)
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
	sudo docker system prune -a
	rm -rf $(MARIADB_PATH)*
	rm -rf $(WORDPRESS_PATH)*
	sudo hostsed rm 127.0.0.1 $(DOMAIN)

re: fclean all

# extra '$' needed to let the shell do the command substitution
nuke:
	sudo docker stop $$(sudo docker ps -qa); \
	sudo docker rm $$(sudo docker ps -qa); \
	sudo docker rmi -f $$(sudo docker images -qa); \
	sudo docker volume rm $$(sudo docker volume ls -q); \
	sudo docker network rm $$(sudo docker network ls -q) 2>/dev/null
