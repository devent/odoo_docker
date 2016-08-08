REPOSITORY := erwinnttdata
NAME := odoo
BUILD := 001
VERSION ?= 9.0-20160727_build_$(BUILD)
APT_CACHE ?= http://172.17.0.1:3142

build: _build ##@targets Builds the docker image.

rebuild: _rebuild ##@targets Rebuilds the docker image using the same tag.

deploy: _deploy ##@targets Deployes the docker image to the repository.

clean: _clean ##@targets Removes the local docker image.

include ../docker_make_utils/Makefile.help
include ../docker_make_utils/Makefile.image

.PHONY +: build clean deploy
