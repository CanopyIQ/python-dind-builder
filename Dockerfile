FROM python:3.7-slim-stretch

RUN set -ex; \
  \
  echo "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/debian-backports.list; \
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
  unzip \
  ssh \
  curl; \
  apt-get -t stretch-backports -y --no-install-recommends install git; \
  rm -rf /var/lib/apt/lists/*; \
  \
  export DOCKER_VERSION=$(curl --silent --fail --retry 3 https://download.docker.com/linux/static/stable/x86_64/ | grep -o -e 'docker-[.0-9]*\.tgz' | sort -r | head -n 1) \
  && DOCKER_URL="https://download.docker.com/linux/static/stable/x86_64/${DOCKER_VERSION}" \
  && echo Docker URL: $DOCKER_URL \
  && curl --silent --show-error --location --fail --retry 3 --output /tmp/docker.tgz "${DOCKER_URL}" \
  && ls -lha /tmp/docker.tgz \
  && tar -xz -C /tmp -f /tmp/docker.tgz \
  && mv /tmp/docker/* /usr/bin \
  && rm -rf /tmp/docker /tmp/docker.tgz \
  && which docker \
  && (docker version || true) \
  && pip install --ignore-installed -U pip setuptools \
  && cd /opt && curl --insecure -OL https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip \
  && unzip sonar-scanner-cli-4.2.0.1873-linux.zip && rm sonar-scanner-cli-4.2.0.1873-linux.zip \
  && ln -s /opt/sonar-scanner-4.2.0.1873-linux/bin/sonar-scanner /usr/bin/
