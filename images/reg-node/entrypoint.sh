#!/bin/sh

# pm2 task
pm2-runtime /opt/server/ecosystem.config.js --only "registry"

gosu chompers /bin/bash
