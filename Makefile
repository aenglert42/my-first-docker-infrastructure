all:
	sudo hostsed add 127.0.0.1 aenglert.42.fr
	sudo mkdir -p /home/aenglert/data/mariadb /home/aenglert/data/wordpress
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
	rm -rf /home/data/mariadb/*
	rm -rf /home/data/wordpress/*
	sudo hostsed rm 127.0.0.1 aenglert.42.fr

re: fclean all

# extra '$' needed to let the shell do the command substitution
nuke:
	sudo docker stop $$(sudo docker ps -qa); \
	sudo docker rm $$(sudo docker ps -qa); \
	sudo docker rmi -f $$(sudo docker images -qa); \
	sudo docker volume rm $$(sudo docker volume ls -q); \
	sudo docker network rm $$(sudo docker network ls -q) 2>/dev/null
