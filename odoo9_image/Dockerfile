FROM debian:jessie
MAINTAINER Odoo S.A. <info@odoo.com>
MAINTAINER Erwin Mueller <erwin.mueller@nttdata.com>

# Set local cache. Remove if not needed.
ARG APT_CACHE
RUN set -x \
    && if [ -n "$APT_CACHE" ]; then \
        echo "Acquire::http::Proxy \"$APT_CACHE\";" > /etc/apt/apt.conf.d/01proxy ;\
    fi

# Install gosu.
ENV GOSU_VERSION 1.9

RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apt-get purge -y --auto-remove ca-certificates wget

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
ENV WKHTMLTOX_VERSION 0.12.1.2
ENV WKHTMLTOX_SHA 40e8b906de658a2221b15e4e8cd82565a47d7ee8
ENV WKHTMLTOX_PACKAGE wkhtmltox-${WKHTMLTOX_VERSION}_linux-jessie-amd64.deb

# Add wkhtmltox package. Use only in development.
COPY $WKHTMLTOX_PACKAGE /tmp/wkhtmltox.deb

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        node-less \
        node-clean-css \
        python-pyinotify \
        python-renderpm \
        python-support \
    && cd /tmp \
    # if the wkhtmltopdf package was empty
    && if [ -z "`find wkhtmltox.deb -size +1c`" ]; then \
        # download wkhtmltopdf
        curl -o wkhtmltox.deb -SL http://nightly.odoo.com/extra/$WKHTMLTOX_PACKAGE ;\
    fi \
    && echo "${WKHTMLTOX_SHA} wkhtmltox.deb" | sha1sum -c - \
    && dpkg --force-depends -i wkhtmltox.deb \
    && apt-get -y install -f --no-install-recommends \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false npm \
    && rm -rf /var/lib/apt/lists/* wkhtmltox.deb

# Install Odoo
ENV ODOO_VERSION 9.0
ENV ODOO_RELEASE 20160727
ENV ODOO_SHA 4c64cad71f79b843fff4ae571534d3a7e406859b
ENV ODOO_PACKAGE odoo_${ODOO_VERSION}c.${ODOO_RELEASE}_all.deb

# Add Odoo package. Use only in development.
COPY $ODOO_PACKAGE /tmp/odoo.deb

RUN set -x \
    && cd /tmp \
    # if the Odoo package was empty
    && if [ -z "`find odoo.deb -size +1c`" ]; then \
        # download Odoo
        curl -o odoo.deb -SL http://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/$ODOO_PACKAGE ;\
    fi \
    && echo "${ODOO_SHA} odoo.deb" | sha1sum -c - \
    && dpkg --force-depends -i odoo.deb \
    && apt-get update \
    && apt-get -y install -f --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* odoo.deb

# Copy Odoo entrypoint script.
COPY odoo-entrypoint.sh /
RUN set -x && chmod +x /odoo-entrypoint.sh

# Copy configuration.
COPY openerp-server.conf /etc/odoo/
RUN set -x && chown odoo /etc/odoo/openerp-server.conf

# Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN set -x \
    && mkdir -p /mnt/extra-addons \
    && chown -R odoo /mnt/extra-addons
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071

# Set the default config file
ENV OPENERP_SERVER /etc/odoo/openerp-server.conf

# Copy docker entrypoint script.
COPY docker-entrypoint.sh /
RUN set -x && chmod +x /docker-entrypoint.sh

# Set docker entrypoint script.
ENTRYPOINT ["/docker-entrypoint.sh"]

# Run Odoo as odoo user.
CMD ["gosu", "odoo", "openerp-server"]
