from debian:stable-slim

SHELL ["/bin/bash", "--login", "-c"]

RUN apt-get update && apt-get install -y wget git
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

RUN source ~/.bashrc 

RUN nvm install 16.10.0 && nvm use 16.10.0

RUN npm install pm2 --global

RUN mkdir /opt/server/ && cd /opt/server

RUN git clone https://github.com/term-world/chompchain-node.git

RUN mkdir /mempool

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
