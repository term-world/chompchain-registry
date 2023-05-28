#!/bin/sh

# CouchDB setup

COUCHDB_PASSWORD=$(echo -n $RANDOM | sha256sum)

# pm2 task
pm2-runtime /opt/server/nodes/ecosystem.config.js --only "validator, registry"
