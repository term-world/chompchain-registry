from debian:stable-slim

SHELL ["/bin/bash", "--login", "-c"]

RUN apt-get update && apt-get install -y wget
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

RUN source ~/.bashrc 

RUN nvm install 16.10.0 && nvm use 16.10.0

RUN npm install pm2 --global

ADD ../../../node /opt/server

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
