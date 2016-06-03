FROM python:2.7.11-slim

RUN groupadd user && useradd --create-home --home-dir /home/user -g user user

MAINTAINER hcchien@twreporter.org

ENV SCRIPT_SOURCE /usr/src/twreporter

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
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
    && apt-get install -y libxml-rss-perl libjson-perl && rm -rf /var/lib/apt/lists/* \
    && pip install --upgrade pip \
    && pip install pymongo

ADD crontab /etc/rc.d/crontab

ADD * $SCRIPT_SOURCE/

RUN touch /var/log/cron.log

RUN mkdir -p /tmp/twreporters/articles

CMD cron && tail -f /var/log/cron.log
