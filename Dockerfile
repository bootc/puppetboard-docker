FROM alpine:3.10

ARG PUPPETBOARD_VERSION="1.1.0"
ARG GUNICORN_VERSION="19.9.0"

ARG BUILD_DATE=1970-01-01T00:00:00Z
ARG VCS_REF=HEAD

LABEL org.label-schema.vendor="Chris Boot" \
      org.label-schema.url="https://github.com/bootc/puppetboard-docker" \
      org.label-schema.name="Puppetboard" \
      org.label-schema.license="Apache-2.0" \
      org.label-schema.version="${PUPPETBOARD_VERSION}" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.build-date="${BUILD_DATE}" \
      org.label-schema.vcs-ref="${VCS_REF}" \
      org.label-schema.vcs-url="https://git.boo.tc/bootc/puppetboard-docker.git"

ENV PUPPETBOARD_SETTINGS="docker_settings.py"

RUN apk add --no-cache --update curl python3 && \
	rm -rf /var/cache/apk/*

RUN pip3 install \
	gunicorn=="$GUNICORN_VERSION" \
	puppetboard=="$PUPPETBOARD_VERSION"

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
