REPOSITORY := erwinnttdata
NAME := odoo
BUILD := 001
VERSION ?= 9.0-20160724_build_$(BUILD)

build: _build ##@targets Builds the docker image.

rebuild: _rebuild ##@targets Rebuilds the docker image using the same tag.

deploy: _deploy ##@targets Deployes the docker image to the repository.

clean: _clean ##@targets Removes the local docker image.

include ../docker_make_utils/Makefile.help
include ../docker_make_utils/Makefile.functions
include ../docker_make_utils/Makefile.image

.PHONY +: build clean deploy
