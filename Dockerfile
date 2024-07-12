FROM python:3.12

RUN set -ex; \
  \
  apt-get update; \
  apt-get install -y --no-install-recommends \
  libxslt1-dev \
  libxml2 \
  libsm6 \
  libxext6 \
  libglib2.0-0 \
  build-essential \
  g++ \
  gcc \
  git \
  libffi-dev \
  libssl-dev \
  default-libmysqlclient-dev \
  libpq-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  wget \
  llvm \
  libncurses5-dev \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  liblzma-dev \
  unzip \
  ssh \
  curl; \
  rm -rf /var/lib/apt/lists/*;

# Sigh, needed to pin docker version
RUN export DOCKER_VERSION=docker-20.10.9.tgz \
  && DOCKER_URL="https://download.docker.com/linux/static/stable/x86_64/${DOCKER_VERSION}" \
  && echo Docker URL: $DOCKER_URL \
  && curl --silent --show-error --location --fail --retry 3 --output /tmp/docker.tgz "${DOCKER_URL}" \
  && ls -lha /tmp/docker.tgz \
  && tar -xz -C /tmp -f /tmp/docker.tgz \
  && mv /tmp/docker/* /usr/bin \
  && rm -rf /tmp/docker /tmp/docker.tgz \
  && which docker \
  && (docker version || true) \
  && pip install --ignore-installed -U pip setuptools

# Fix for mongo...
RUN wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_amd64.deb && \
    dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb

WORKDIR /root

ENV UV_CACHE_DIR /root/uv_cache

RUN pip install uv

RUN chsh -s /bin/bash root

ENTRYPOINT [ "/bin/bash" ]
