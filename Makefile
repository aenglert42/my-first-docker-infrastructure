all:
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