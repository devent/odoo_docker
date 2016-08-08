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
# Nginx local user
CONTAINER_USER ?= nginx
# Set to PORTS='-p 80:80 -p 443:443' to use Nginx on localhost.
PORTS ?= -p 80:80 -p 443:443
# CACHE DIR
CACHE_DIR := /var/lib/odoo_nginx

include ../docker_make_utils/Makefile.help
include ../docker_make_utils/Makefile.container

define DOCKER_CMD :=
set -x &&\
$(DNS_SERVER_ARG) \
docker run \
--name $(NAME) \
$$DNS_ARG \
-v "$(CACHE_DIR):/var/cache/nginx" \
-v "`realpath nginx.conf`:/etc/nginx/nginx.conf.custom" \
-v "`realpath $(CONFIG)`:/etc/nginx/conf.d" \
-v "`realpath $(SITES)`:/etc/nginx/sites-enabled" \
-e NGINX_USER_ID=`id -u nginx` \
-e NGINX_GROUP_ID=`id -g nginx` \
$(PORTS) \
-d \
$(IMAGE_NAME)
endef

.PHONY +: run rerun rm clean test restart

run: _containeruser $(CACHE_DIR) _run ##@default Starts the container.

rerun: _rerun ##@targets Stops and starts the container.

rm: _rm ##@targets Stops and removes the container.
	set -x \
	&& USER="`whoami`" \
	&& sudo chown -R `id -u $$USER`.`id -g $$USER` nginx.conf $(CONFIG) $(SITES)

clean: _clean ##@targets Stops and removes the container and removes all created files.
	set -x \
	&& USER="`whoami`" \
	&& sudo chown -R `id -u $$USER`.`id -g $$USER` nginx.conf $(CONFIG) $(SITES)
	sudo rm -rf $(CACHE_DIR)

test: _test ##@targets Tests if the container is running.

restart: ##@targets Restarts the container.
	if $(container_running); then \
	docker exec $(NAME) nginx -s reload; \
	else \
	$(MAKE) rerun; \
	fi

bash: test _bash ##@targets Executes the bash inside the running container.

$(CACHE_DIR):
	sudo mkdir -p $(CACHE_DIR)
	sudo chown $(CONTAINER_USER).$(CONTAINER_USER) -R $(CACHE_DIR)
