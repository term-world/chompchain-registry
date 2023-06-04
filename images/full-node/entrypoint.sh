#!/bin/sh

# CouchDB startup
service couchdb start

# pm2 task
pm2-runtime /opt/server/chompchain-node/nodes/ecosystem.config.js --only "validator, registry"

# Transfer away from root user
gosu chompers /bin/bash
