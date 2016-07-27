SHELL := /bin/bash
.PHONY: all setup weave convoy dns proxy pgadmin
.DEFAULT_GOAL := all

include docker_make_utils/Makefile.help

all: weave dns pgadmin postgres odoo proxy ##@default Installs and setups the Odoo ERP. The Odoo application will be reachable over the http://muellerpublic.de.local and http://money.muellerpublic.de.local addresses. In addition, the pgAdmin will be reachable over the pgadmin.muellerpublic.de.local address.

weave: ##@targets Installs and setups the weave network.
	cd docker_utils && $(MAKE) weave

dns: weave ##@targets Installs and setups the authoritative DNS server.
	cd maradns_container && $(MAKE)

proxy: ##@targets Installs and setups the Nginx proxy server to pgAdmin.
	cd nginx_proxy && $(MAKE)

pgadmin: weave ##@targets Installs and setups pgAdmin.
	cd pgadmin4_local && $(MAKE)

postgres: weave ##@targets Installs and setups pgAdmin.
	cd postgresql_local && $(MAKE)

odoo: weave ##@targets Installs and setups Odoo 9.
	cd odoo_local && $(MAKE)

clean-all: ##@targets Removes all created containers and volumes.
	cd postgresql_local && $(MAKE) clean
	cd nginx_proxy && $(MAKE) clean
	cd pgadmin4_local && $(MAKE) clean
	cd maradns_container && $(MAKE) clean
