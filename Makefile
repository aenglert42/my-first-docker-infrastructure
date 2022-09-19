# https://shisho.dev/blog/posts/docker-remove-cheatsheet/
# docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
# docker rmi $(docker images -a -q)

# systemctl restart docker

# sudo echo "127.0.0.1       localhost       aenglert.42.fr" >> /etc/hosts

all:
#	mkdir /home/data
#	mkdir /home/data/mariadb
#	mkdir /home/data/wordpress
	@echo "build & run"
	@cd srcs && \
	docker-compose up --build -d && \
	cd .. && \
	echo "running..."

stop:
	@echo "stopping..."
	@cd srcs && \
	docker-compose down && \
	cd .. && \
	echo "stopped"

clean: stop
	@echo "cleaning..."
	@cd srcs && \
	docker-compose down --rmi all -v && \
	cd .. && \
	echo "cleaned"

fclean: clean
	docker system prune -a
	rm -rf /home/data/mariadb/*
	rm -rf /home/data/wordpress/*

re: fclean all