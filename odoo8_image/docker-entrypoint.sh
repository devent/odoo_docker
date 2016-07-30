#!/bin/bash
set -eo pipefail

# Add local user;
# Either use the 
# - ODOO_USER_ID and
# - ODOO_GROUP_ID
# if passed in at runtime or fallback.
USER_ID=${ODOO_USER_ID:-9001}
GROUP_ID=${ODOO_GROUP_ID:-9001}
echo "Starting with UID and GID: $USER_ID:$GROUP_ID"
usermod -u $USER_ID odoo
groupmod -g $GROUP_ID odoo

# update permissions
chown odoo.odoo $OPENERP_SERVER
chown -R odoo.odoo /mnt/extra-addons
chown -R odoo.odoo /var/lib/odoo

# If the run command is started, run Odoo.
if [ "$1" = 'openerp-server' ]; then
    gosu odoo /odoo-entrypoint.sh "$@"
else
    # run command
    exec "$@"
fi
