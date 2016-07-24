# docker image version
VERSION := latest
# The name of the docker image.
IMAGE_NAME := erwinnttdata/nginx:$(VERSION)
# docker container name
NAME := odoo_proxy
# The name of the container running the authoritative DNS server, for example "maradns-deadwood".
DNS_SERVER ?= odoo_dns
# configuration files
CONFIG := conf.d
# active domains
SITES := sites
# data container
DATA_VOL_NAME := odoo_proxy_data
DATA_MOUNT_PATH := var/cache/nginx
DATA_IMAGE_NAME := $(IMAGE_NAME)
DATA_CONTAINER_NAME := odoo_proxy_data
# Nginx local user
CONTAINER_USER ?= nginx
# Set to PORTS='-p 80:80 -p 443:443' to use Nginx on localhost.
PORTS ?= -p 80:80 -p 443:443

include ../docker_make_utils/Makefile.help
include ../docker_make_utils/Makefile.functions
include ../docker_make_utils/Makefile.container

define DOCKER_CMD :=
set -x &&\
$(DNS_SERVER_ARG) \
docker run \
--name $(NAME) \
$$DNS_ARG \
--volumes-from $(DATA_CONTAINER_NAME) \
-v "`realpath nginx.conf`:/etc/nginx/nginx.conf.custom" \
-v "`realpath $(CONFIG)`:/etc/nginx/conf.d" \
-v "`realpath $(SITES)`:/etc/nginx/sites-enabled" \
-e NGINX_USER_ID=`id -u nginx` \
-e NGINX_GROUP_ID=`id -g nginx` \
$(PORTS) \
-d \
$(IMAGE_NAME)
endef

.PHONY +: run rerun rm clean test restart dataContainer rm_dataContainer connect user drop dropdb dropuser

run: dataContainer _containeruser _run ##@default Starts the container.

rerun: _rerun ##@targets Stops and starts the container.

rm: _rm ##@targets Stops and removes the container.

clean: _clean rm_dataContainer ##@targets Stops and removes the container and removes all created files.
	set -x \
	&& USER="`whoami`" \
	&& sudo chown -R `id -u $$USER`.`id -g $$USER` nginx.conf $(CONFIG) $(SITES)

test: testDataContainer _test ##@targets Tests if the container is running.

restart: ##@targets Restarts the container.
	if $(container_running); then \
	docker exec $(NAME) nginx -s reload; \
	else \
	$(MAKE) rerun; \
	fi

bash: test _bash ##@targets Executes the bash inside the running container.

dataContainer: _dataContainer ##@targets Creates the data container.

rm_dataContainer: _rm_dataContainer ##@targets Removes the data container.

testDataContainer: _testDataContainer ##@targets Tests that the data container is available.
