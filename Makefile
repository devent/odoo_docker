SHELL := /bin/bash
.PHONY: all setup weave convoy dns proxy pgadmin
.DEFAULT_GOAL := all

include docker_make_utils/Makefile.help

all: weave convoy dns pgadmin postgres proxy ##@default Installs and setups the Odoo ERP. The Odoo application will be reachable over the http://muellerpublic.de.local and http://money.muellerpublic.de.local addresses. In addition, the pgAdmin will be reachable over the pgadmin.muellerpublic.de.local address.

weave: ##@targets Installs and setups the weave network.
	cd docker_utils && $(MAKE) weave

convoy: ##@targets Installs and setups the convoy volumes.
	cd docker_utils && $(MAKE) convoy

dns: weave ##@targets Installs and setups the authoritative DNS server.
	cd maradns_container && $(MAKE)

proxy: convoy ##@targets Installs and setups the Nginx proxy server to pgAdmin.
	cd nginx_proxy && $(MAKE)

pgadmin: weave ##@targets Installs and setups pgAdmin.
	cd pgadmin_container && $(MAKE)

postgres: weave convoy ##@targets Installs and setups pgAdmin.
	cd postgresql_convoy && $(MAKE)

clean-all: ##@targets Removes all created containers and volumes.
	cd postgresql_convoy clean
	cd nginx_proxy && $(MAKE) clean
	cd pgadmin_container && $(MAKE) clean
	cd maradns_container && $(MAKE) clean
