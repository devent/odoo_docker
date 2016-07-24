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
# database local user
CONTAINER_USER ?= postgres
# The data docker container image name, for example "mysql:latest".
DATA_IMAGE_NAME ?= erwinnttdata/postgresql:$(VERSION)
# The convoy volume name, for example "vol1".
DATA_VOL_NAME ?= postgres_9_4_data
# The data docker container mount path, for example "/var/lib/mysql".
DATA_MOUNT_PATH ?= var/lib/postgresql/data
# The data docker container name, for example "db_data".
DATA_CONTAINER_NAME ?= postgres_9_4_data

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
-e POSTGRES_USER_ID=`id -u $(CONTAINER_USER)` \
-e POSTGRES_PASSWORD=$(ROOT_PASSWORD) \
-d \
$(IMAGE_NAME)
endef

define DOCKER_DATA_CMD =
sudo docker run \
-e POSTGRES_USER_ID=`id -u $(CONTAINER_USER)` \
-v $(DATA_VOL_NAME):/$(DATA_MOUNT_PATH) \
--volume-driver=convoy \
--name $(DATA_CONTAINER_NAME) \
-d $(DATA_IMAGE_NAME) \
true 
endef

.PHONY +: run rerun rm clean test restart dataContainer rm_dataContainer connect user drop dropdb dropuser

run: weave convoy _localuser dataContainer _run ##@default Starts the container.

rerun: _rerun ##@targets Stops and starts the container.

rm: _rm ##@targets Stops and removes the container.

clean: _clean rm_dataContainer ##@targets Stops and removes the container and removes all created files.

test: testDataContainer _test ##@targets Tests if the container is running.

restart: _restart ##@targets Restarts the container.

bash: test _bash ##@targets Executes the bash inside the running container.

dataContainer: _dataContainer ##@targets Creates the data container.

rm_dataContainer: _rm_dataContainer ##@targets Removes the data container.

testDataContainer: _testDataContainer ##@targets Tests that the data container is available.

clean_dataContainer: _clean_dataContainer ##@targets Removes the data container and the volume.

weave:
	cd ../docker_utils && $(MAKE) weave

convoy:
	cd ../docker_utils && $(MAKE) convoy
