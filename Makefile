build:
	@docker build --secret id=secrets,src=./secrets.env -t docker-freeswitch .
start:
	@docker run -it -d --rm --name docker-freeswitch docker-freeswitch
stop:
	@docker stop docker-freeswitch || echo "down"
prune:
	@docker system prune -a || echo "no prune"
enter:
	@docker exec -ti docker-freeswitch /bin/bash || echo "no enter"

clean: stop prune
