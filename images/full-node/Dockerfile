from debian:stable-slim

ARG TXPOOL
ENV MEMPOOL=$TXPOOL
ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "--login", "-c"]

RUN apt-get update && apt-get install -y apt-utils \
    wget \
    git \ 
    curl \ 
    cron \
    dpkg \
    sudo \
    gosu \
    apt-transport-https \
    gnupg \
    lsb-release \
    libicu67 \
    libmozjs-78-0 \
    libncurses6 \
    libprocps8 \
    procps \
    psmisc \
    gettext \
    python3 \
    python3-pip \
    python-is-python3

RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

RUN source ~/.bashrc 

RUN nvm install 16.10.0 && nvm use 16.10.0

RUN npm install pm2 --global

RUN mkdir /opt/server/

RUN cd /opt/server && git clone https://github.com/term-world/chompchain-node.git

RUN cd /opt/server/chompchain-node/nodes/ && npm install

RUN mkdir /$TXPOOL

RUN curl https://couchdb.apache.org/repo/keys.asc | gpg --dearmor | sudo tee /usr/share/keyrings/couchdb-archive-keyring.gpg >/dev/null 2>&1
RUN source /etc/os-release
RUN echo "deb [signed-by=/usr/share/keyrings/couchdb-archive-keyring.gpg] https://apache.jfrog.io/artifactory/couchdb-deb/ `lsb_release -cs` main" \
    | sudo tee /etc/apt/sources.list.d/couchdb.list >/dev/null

RUN apt-get update

RUN echo "export COUCHDB_PASSWORD=$(openssl rand -hex 32)" > /root/.bashrc
RUN echo "export COUCHDB_COOKIE=$(openssl rand -hex 32)" >> /root/.bashrc
ADD couchdb.conf /couchdb.conf
RUN envsubst < /couchdb.conf > /couchdb-env.conf
RUN debconf-set-selections /couchdb-env.conf
RUN rm /couchdb.conf && rm /couchdb-env.conf
RUN sudo apt-get download couchdb && ls -la && sudo dpkg -i couchdb_3.3.2~$(lsb_release -cs)_amd64.deb

RUN set -eux; \
    apt-get update; \
    apt-get install -y gosu; \
    rm -rf /var/lib/apt/lists/*; \
    gosu nobody true

RUN useradd chompers
RUN mkdir /home/chompers
RUN usermod -d /home/chompers chompers

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
