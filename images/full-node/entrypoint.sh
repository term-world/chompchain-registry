#!/bin/sh

# CouchDB startup
service couchdb start
sleep 10

# CouchDB API requests

curl -X PUT --user admin:$COUCHDB_PASSWORD http://127.0.0.1:5984/blocks
curl -X PUT --user admin:$COUCHDB_PASSWORD http://127.0.0.1:5984/contracts

# pm2 task
# pm2-runtime /opt/server/chompchain-node/nodes/ecosystem.config.js --only "validator, registry"

# Transfer away from root user
gosu chompers /bin/bash