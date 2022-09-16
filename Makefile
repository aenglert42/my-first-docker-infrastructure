# https://shisho.dev/blog/posts/docker-remove-cheatsheet/
# docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
# docker rmi $(docker images -a -q)

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