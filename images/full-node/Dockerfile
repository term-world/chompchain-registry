from debian:stable-slim

ARG TXPOOL
ENV MEMPOOL=$TXPOOL

SHELL ["/bin/bash", "--login", "-c"]

RUN apt-get update && apt-get install -y wget git
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

RUN source ~/.bashrc 

RUN nvm install 16.10.0 && nvm use 16.10.0

RUN npm install pm2 --global

RUN mkdir /opt/server/

RUN cd /opt/server && git clone https://github.com/term-world/chompchain-node.git

RUN cd /opt/server/chompchain-node/nodes/ && npm install

RUN mkdir $TXPOOL

RUN COUCHDB_PASSWORD=$(echo -n $RANDOM | sha256sum) \
echo "couchdb couchdb/mode select clustered \
couchdb couchdb/mode seen true \
couchdb couchdb/nodename string couchdb@localhost \
couchdb couchdb/nodename seen true \
couchdb couchdb/cookie string cliv3isaliv3 \
couchdb couchdb/cookie seen true \
couchdb couchdb/bindaddress string 0.0.0.0 \
couchdb couchdb/bindaddress seen true \
couchdb couchdb/adminpass password ${COUCHDB_PASSWORD} \
couchdb couchdb/adminpass seen true \
couchdb couchdb/adminpass_again password ${COUCHDB_PASSWORD} \
couchdb couchdb/adminpass_again seen true" | debconf-set-selections \
DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes couchdb

#ADD entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh
#ENTRYPOINT /entrypoint.sh
