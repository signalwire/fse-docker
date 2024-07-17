build:
	@docker build -t docker-freeswitch . --build-arg FSA_USERNAME=$(FSA_USERNAME) --build-arg FSA_PASSWORD=$(FSA_PASSWORD)
start:
	@docker run -it -d --rm --name docker-freeswitch docker-freeswitch
stop:
	@docker stop docker-freeswitch || echo "down"
prune:
	@docker system prune -a || echo "no prune"
enter:
	@docker exec -ti docker-freeswitch /bin/bash || echo "no enter"

clean: stop prune
