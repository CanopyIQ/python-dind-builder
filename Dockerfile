FROM python:3-alpine

RUN set -ex; \
        \
        apk add --no-cache \
        libxslt \
        libxml2-dev \
        make \
        g++ \
        gcc \
        git \
        libffi-dev \
        openssl-dev \
        curl; \
        \
        VER="17.03.0-ce"; \
        curl -L -o /tmp/docker-$VER.tgz https://get.docker.com/builds/Linux/x86_64/docker-$VER.tgz; \
        tar -xz -C /tmp -f /tmp/docker-$VER.tgz; \
        rm /tmp/docker-$VER.tgz; \
        mv /tmp/docker/* /usr/bin; \
        pip install --ignore-installed -U pip setuptools; \
        ln -s /usr/include/locale.h /usr/include/xlocale.h
