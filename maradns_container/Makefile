VERSION := latest
NAME := odoo_dns
CONF := ./maradns
CACHE := ./deadwood
CONTAINER_USER ?= maradns
# Set the option PORTS='-p 53:53/udp' to use the DNS server on localhost.
PORTS ?=

define DOCKER_CMD :=
docker run \
--name $(NAME) \
-v "`realpath mararc`:/etc/mararc.custom" \
-v "`realpath $(CONF)`:/etc/maradns" \
-v "`realpath dwood3rc`:/etc/dwood3rc.custom" \
-v "`realpath $(CACHE)`:/var/cache/deadwood" \
-v "`realpath filebeat.yml`:/etc/filebeat/filebeat.yml.custom" \
-e MARADNS_USER_ID=`id -u $(CONTAINER_USER)` \
-e MARADNS_GROUP_ID=`id -g $(CONTAINER_USER)` \
$(PORT_ON_LOCALHOST) \
-d \
erwinnttdata/maradns-deadwood:$(VERSION)
endef

include ../docker_make_utils/Makefile.help
include ../docker_make_utils/Makefile.functions
include ../docker_make_utils/Makefile.container

.PHONY +: run rerun rm clean test restart bash

run: $(CONF) _localuser _run ##@default Starts the container. Set the option PORT_ON_LOCALHOST='-p 127.0.0.1:53:53/udp' to use the DNS server on localhost.

rerun: _rerun ##@targets Stops and starts the container.

rm: _rm ##@targets Stops and removes the container.

clean: _clean ##@targets Stops and removes the container and removes all created files.

test: _test ##@targets Tests if the container is running.
	
restart: _restart ##@targets Restarts the container.

bash: test _bash ##@targets Executes the bash inside the running container.

$(CONF):
	mkdir -p "$(CONF)"

$(CACHE):
	mkdir -p "$(CACHE)"

cache_permissions:
	sudo chown -R maradns.maradns $(CACHE)
