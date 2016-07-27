# docker image version
VERSION := 9.4-build_004
# docker container name
NAME := postgres_9_4
# The container image.
IMAGE_NAME := erwinnttdata/postgresql:$(VERSION)
# The name of the container running the authoritative DNS server, for example "maradns-deadwood".
DNS_SERVER ?= odoo_dns
# database root password
ROOT_PASSWORD ?= Uleela8AiSahshang6Pu6Sei8eishahw
# container local user
CONTAINER_USER ?= postgres
# Data directory
DATA := /var/lib/postgresql/data

include ../docker_make_utils/Makefile.help
include ../docker_make_utils/Makefile.functions
include ../docker_make_utils/Makefile.container

define DOCKER_CMD :=
set -x &&\
$(DNS_SERVER_ARG) \
docker run \
--name $(NAME) \
$$DNS_ARG \
-v "/var/lib/postgresql/data:/var/lib/postgresql/data" \
-e POSTGRES_USER_ID=`id -u $(CONTAINER_USER)` \
-e POSTGRES_PASSWORD=$(ROOT_PASSWORD) \
-d \
$(IMAGE_NAME)
endef

.PHONY +: run rerun rm clean test restart

run: weave _containeruser $(DATA) _run ##@default Starts the container.

rerun: _rerun ##@targets Stops and starts the container.

rm: _rm ##@targets Stops and removes the container.

clean: _clean ##@targets Stops and removes the container and removes all created files.
	sudo rm -rf $(DATA)

test: _test ##@targets Tests if the container is running.

restart: _restart ##@targets Restarts the container.

bash: test _bash ##@targets Executes the bash inside the running container.

weave:
	cd ../docker_utils && $(MAKE) weave

$(DATA):
	sudo mkdir -p $(DATA)
	sudo chown $(CONTAINER_USER).$(CONTAINER_USER) -R $(DATA)
