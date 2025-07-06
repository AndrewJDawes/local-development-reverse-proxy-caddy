#!/usr/bin/env bash
docker build -t local-development-reverse-proxy-caddy:test .
docker run --rm -it \
    -e EXTERNAL_BACKEND_SCHEME=https \
    -e EXTERNAL_BACKEND_HOSTNAME=github.com \
    -e EXTERNAL_BACKEND_PORT=443 \
    -e EXTERNAL_HEADER_UP_HOST=github.com \
    -e EXTERNAL_BACKEND_COOKIE_HEADER_UP_ENABLED=true \
    -e EXTERNAL_BACKEND_COOKIE_HEADER_DOWN_ENABLED=true \
    -e DEBUG_LEVEL=verbose \
    -p 443:443 \
    -p 80:80 \
    -p 3025:2019 \
    local-development-reverse-proxy-caddy:test
