#!/bin/bash

# Source the bashrc file to load ENV vars
source ~/.bashrc

# CouchDB startup
service couchdb start
sleep 5

# Create environment variables for DB user

export DB_USER=$(openssl rand -hex 6)
echo $DB_USER >> /home/chompers/.bashrc
export DB_PASS=$(openssl rand -hex 32)
echo $DB_PASS  >> /home/chompers/.bashrc
echo "export DB_HOST='127.0.0.1'" >> /home/chompers/.bashrc

# CouchDB API requests
curl -s -o /dev/null -X PUT --user admin:$COUCHDB_PASSWORD http://127.0.0.1:5984/blocks
curl -s -o /dev/null -X PUT --user admin:$COUCHDB_PASSWORD http://127.0.0.1:5984/contracts
curl -s -o /dev/null -X PUT --user admin:$COUCHDB_PASSWORD http://127.0.0.1:5984/_users

# TODO: Add non-admin user to DB with password (may be 2 steps?)
curl -X PUT --user admin:$COUCHDB_PASSWORD http://127.0.0.1:5984/_users/org.couchdb.user:$DB_USER \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d '{"_id":"'"org.couchdb.user:$DB_USER"'", "type": "user", "roles": [], "password":"'"$DB_PASS"'"}'

curl -X POST http://127.0.0.1:5984/_session -d "name=$DB_USER&password=$DB_PASS"

# pm2 task
pm2-runtime /opt/server/chompchain-node/nodes/ecosystem.config.js --only "validator, registry"

# Transfer away from root user
#gosu chompers /bin/bash
/bin/bash
# TODO: Verify that this can run without apparent error
##gosu chompers python -c "import chompchain"
