# docker image version
VERSION := latest
# docker container name
NAME := pgadmin
# The container image.
IMAGE_NAME := erwinnttdata/pgadmin:$(VERSION)
# The name of the container running the authoritative DNS server, for example "maradns-deadwood".
DNS_SERVER ?= odoo_dns
# Configuration directory/
CONF_DIR := /var/lib/pgadmin4

include ../docker_make_utils/Makefile.help
include ../docker_make_utils/Makefile.functions
include ../docker_make_utils/Makefile.container

define DOCKER_CMD :=
set -x &&\
$(DNS_SERVER_ARG) \
docker run \
--name $(NAME) \
$$DNS_ARG \
-v "$(CONF_DIR):/root/.pgadmin" \
-d \
$(IMAGE_NAME)
endef

.PHONY +: run rerun rm clean test restart

run: weave $(CONF_DIR) _run ##@default Starts the container.

rerun: _rerun ##@targets Stops and starts the container.

rm: _rm ##@targets Stops and removes the container.

clean: _clean ##@targets Stops and removes the container and removes all created files.
	sudo rm -rf $(CONF_DIR)

test: _test ##@targets Tests if the container is running.

restart: _restart ##@targets Restarts the container.

bash: test _bash ##@targets Executes the bash inside the running container.

weave:
	cd ../docker_utils && $(MAKE) weave

$(CONF_DIR):
	sudo mkdir -p $(CONF_DIR)
