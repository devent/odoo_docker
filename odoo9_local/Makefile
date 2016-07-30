# docker image version
VERSION := 9.0-20160727_build_001
# The name of the docker image.
IMAGE_NAME := erwinnttdata/odoo:$(VERSION)
# docker container name
NAME := odoo
# The name of the container running the authoritative DNS server, for example "maradns-deadwood".
DNS_SERVER ?= odoo_dns
# container local user
CONTAINER_USER ?= odoo
PORTS ?= -p 8069:8069
# Data directory
DATA_DIR := /var/lib/odoo9

include ../docker_make_utils/Makefile.help
include ../docker_make_utils/Makefile.functions
include ../docker_make_utils/Makefile.container

define DOCKER_CMD :=
set -x &&\
$(DNS_SERVER_ARG) \
docker run \
--name $(NAME) \
$$DNS_ARG \
-e ODOO_USER_ID=`id -u odoo` \
-e ODOO_GROUP_ID=`id -g odoo` \
-e DB_PORT_5432_TCP_ADDR="postgres_9_4.weave.local" \
-e DB_PORT_5432_TCP_PORT="5432" \
-e DB_ENV_POSTGRES_USER="odoo9" \
-e DB_ENV_POSTGRES_PASSWORD="Choh5wieghar6eeN4aquiThie4quaa5o" \
-v "$(DATA_DIR):/var/lib/odoo" \
$(PORTS) \
-d \
$(IMAGE_NAME) \
openerp-server
endef

.PHONY +: run rerun rm clean test restart bash

run: _containeruser $(DATA_DIR) _run ##@default Starts the container.

rerun: _rerun ##@targets Stops and starts the container.

rm: _rm ##@targets Stops and removes the container.

clean: _clean ##@targets Stops and removes the container and removes all created files.
	sudo rm -rf $(DATA_DIR)

test: _test ##@targets Tests if the container is running.

restart: _restart ##@targets Restarts the container.

bash: test _bash ##@targets Executes the bash inside the running container.

$(DATA_DIR):
	sudo mkdir -p $(DATA_DIR)
	sudo chown $(CONTAINER_USER).$(CONTAINER_USER) -R $(DATA_DIR)
