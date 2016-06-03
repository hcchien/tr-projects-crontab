FROM python:3.5.1-slim

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user

MAINTAINER hcchien@twreporter.org

SCRIPT_SOURCE /usr/src/twreporter

WORKDIR $SCRIPT_SOURCE

RUN set -x \
    && apt-get update \
    && apt-get install -y git \
    && rm -rf /var/lib/apt/lists/*
RUN buildDeps=' \
    gcc \
    make \
    python \
    ' \
    && set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \

ADD crontab /etc/cron.d/tr-cronyab

RUN chmod 644 /etc/cron.d/tr-crontab

RUN touch /var/log/cron.log

CMD cron && tail -f /var/log/cron.log
