all:
	@echo "build & run"
	@cd srcs && \
	docker-compose up --build -d && \
	cd .. && \
	echo "running..."