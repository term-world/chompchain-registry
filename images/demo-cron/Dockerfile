FROM debian:bullseye-slim
ADD crontab /etc/cron.d/hello-cron
RUN chmod 0644 /etc/cron.d/hello-cron

RUN touch /var/log/cron.log

RUN apt update && apt install cron -y

CMD cron && tail -f /var/log/cron.log