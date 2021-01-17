FROM alpine:3.12

ARG PUPPETBOARD_VERSION="2.2.0"
ARG GUNICORN_VERSION="20.0.4"

ENV PUPPETBOARD_SETTINGS="docker_settings.py"

RUN apk add --no-cache --update \
    curl \
    python3 \
    py3-pip \
    py3-wheel \
  && \
  rm -rf /var/cache/apk/*

RUN set -eux; \
  pip install \
    gunicorn=="$GUNICORN_VERSION" \
    pypuppetdb \
    puppetboard=="$PUPPETBOARD_VERSION" \
  ; \
  pip check --verbose; \
  rm -rf /root/.cache/pip

EXPOSE 8000

CMD /usr/bin/gunicorn \
  -b 0.0.0.0:8000 \
  --access-logfile=/dev/stdout \
  puppetboard.app:app

# Health check
HEALTHCHECK --interval=10s --timeout=10s --retries=90 CMD \
  curl --fail -X GET localhost:8000 \
  |  grep -q 'Live from PuppetDB' \
  || exit 1

# https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.authors="Chris Boot" \
      org.opencontainers.image.url="https://github.com/bootc/puppetboard-docker" \
      org.opencontainers.image.source="https://git.boo.tc/bootc/puppetboard-docker" \
      org.opencontainers.image.title="Puppetboard" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.version="${PUPPETBOARD_VERSION}"

# vim: ts=2 sw=2 et sts=2 ft=dockerfile
