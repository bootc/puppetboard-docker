#!/bin/dash
#
# NB: This script runs in a Kaniko container in BusyBox ash. You must avoid
# bashisms when modifying this script.
#

set -eu

# Import ARGs from Dockerfile as variables
eval "$(awk '$1 == "ARG" { for (i=2; i<=NF; ++i) print $i }' Dockerfile)"

case $CI_COMMIT_REF_SLUG in
  master)
    TAGS="${CI_COMMIT_SHORT_SHA} ${PUPPETBOARD_VERSION} latest"
    ;;
  *)
    TAGS="${CI_COMMIT_REF_SLUG}"
    ;;
esac

CREATED_DATE="$(date --utc +%Y-%m-%dT%H:%M:%SZ)"
DOCKER_HUB_IMAGE="bootc/puppetboard"

kaniko_destinations() {
  for TAG in $TAGS; do
    echo "--destination ${CI_REGISTRY_IMAGE}:${TAG}";
  done

  if [ -n "${DOCKER_HUB_IMAGE:-}" ]; then
    for TAG in $TAGS; do
      echo "--destination ${DOCKER_HUB_IMAGE}:${TAG}";
    done
  fi
}

# Generate the Docker config.json with authentication info
[ -z "${DOCKER_CONFIG:-}" ] && export DOCKER_CONFIG=/kaniko/.docker/
cat > "${DOCKER_CONFIG}/config.json" <<EOF
{
  "auths": {
EOF

if [ -n "${DOCKER_HUB_AUTH:-}" ]; then
  cat >> "${DOCKER_CONFIG}/config.json" <<EOF
    "https://index.docker.io/v1/": {
      "auth": "${DOCKER_HUB_AUTH}"
    },
EOF
fi

cat >> "${DOCKER_CONFIG}/config.json" <<EOF
    "${CI_REGISTRY}": {
      "username": "${CI_REGISTRY_USER}",
      "password": "${CI_REGISTRY_PASSWORD}"
    }
  }
}
EOF

echo "Building image: $CI_REGISTRY_IMAGE ..."
set -x

# Build the container image
# shellcheck disable=SC2046
/kaniko/executor \
  --force \
  --context . \
  --dockerfile Dockerfile \
  --label org.opencontainers.image.created="$CREATED_DATE" \
  --label org.opencontainers.image.revision="$CI_COMMIT_SHA" \
  "$@" \
  $(kaniko_destinations)

# vim: ai ts=2 sw=2 et sts=2 ft=sh
