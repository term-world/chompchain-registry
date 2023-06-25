#!/bin/bash

# Source the bashrc file to load ENV vars
source ~/.bashrc

# CouchDB startup
service couchdb start
sleep 5

# Create environment variables for DB user

export DB_USER=$(openssl rand -hex 6)
echo "export DB_USER=$DB_USER" >> /home/chompers/.bashrc
export DB_PASS=$(openssl rand -hex 32)
echo "export DB_PASS=$DB_PASS"  >> /home/chompers/.bashrc
export DB_HOST="127.0.0.1:5984"
echo "export DB_HOST=$DB_HOST" >> /home/chompers/.bashrc

# CouchDB API requests
echo "Create databases..."
curl -s -o /dev/null -X PUT --user admin:$COUCHDB_PASSWORD http://127.0.0.1:5984/blocks
curl -s -o /dev/null -X PUT --user admin:$COUCHDB_PASSWORD http://127.0.0.1:5984/contracts
curl -s -o /dev/null -X PUT --user admin:$COUCHDB_PASSWORD http://127.0.0.1:5984/_users

# Adds our generated user to the database as a member
echo "Generate user..."
curl -s -o /dev/null -X PUT --user admin:$COUCHDB_PASSWORD http://127.0.0.1:5984/_users/org.couchdb.user:$DB_USER \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d '{"_id":"'"org.couchdb.user:$DB_USER"'", "type": "user", "roles": [], "password":"'"$DB_PASS"'"}'

echo "Add user to database roles..."
curl -X PUT http://127.0.0.1:5984/blocks/_security \
    -u admin:$COUCHDB_PASSWORD \
    -H "Content-Type: application/json" \
    -d '{"admins": {"names": [], "roles":[]}, "members": {"names": ["'"$DB_USER"'"], "roles":[]}}'
curl -X PUT http://127.0.0.1:5984/contracts/_security \
    -u admin:$COUCHDB_PASSWORD \
    -H "Content-Type: application/json" \
    -d '{"admins": {"names": [], "roles":[]}, "members": {"names": ["'"$DB_USER"'"], "roles":[]}}'

# Limits revisions on all DBs to 2
echo "Limit revisions to database records..."
curl -s -o /dev/null -X PUT --user admin:$COUCHDB_PASSWORD http://127.0.0.1:5984/blocks/_revs_limit \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -d '2'

# pm2 task
echo "Kick off project daemons..."
pm2-runtime /opt/server/chompchain-node/nodes/ecosystem.config.js --only "validator, registry"

# Transfer away from root user
gosu chompers /bin/bash
# TODO: Verify that this can run without apparent error
##gosu chompers python -c "import chompchain"
