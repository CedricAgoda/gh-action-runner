FROM ubuntu:focal

# Prepare stable environment
ENV DEBIAN_FRONTEND=noninteractive
LABEL maintainer="Cedric Rochefolle"

RUN apt-get update \
    && apt-get install apt-utils -y \
    && apt-get upgrade -y \
    && apt-get autoremove --purge -y \
    && apt-get install locales curl tzdata -y \
    && rm -Rf /var/cache/apt/* /var/lib/apt/lists/*

# Setup en_US.UTF8 as locale and Thailand as timezone
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
RUN echo "Asia/Bangkok" > /etc/timezone \
    && rm -f /etc/localtime \
    && dpkg-reconfigure tzdata

# Create GitHub Actions Runner
RUN mkdir /opt/actions-runner
WORKDIR /opt/actions-runner

ENV GHAR_SERIES="v2.272.0"
ENV GHAR_VERSION="2.272.0"

RUN cd /opt/actions-runner \
    && curl -s -O -L https://github.com/actions/runner/releases/download/${GHAR_SERIES}/actions-runner-linux-x64-${GHAR_VERSION}.tar.gz \
    && tar -zxf actions-runner-linux-x64-${GHAR_VERSION}.tar.gz \
    && ./bin/installdependencies.sh \
    && rm actions-runner-linux-x64-${GHAR_VERSION}.tar.gz

# Configure and start Actions Runner
RUN useradd -m -U ghactions \
    && chown -Rf ghactions:ghactions /opt/actions-runner

COPY entrypoint.sh /opt/actions-runner/
RUN chmod +x /opt/actions-runner/entrypoint.sh

ENV GHAR_REPO=""
ENV GHAR_TOKEN=""
ENV GHAR_OLD_TOKEN=""
ENV GHAR_RUN=""

USER ghactions
ENTRYPOINT [ "/opt/actions-runner/entrypoint.sh" ]