#!/usr/bin/env bash
docker build -t local-development-reverse-proxy-caddy:test . &&
    docker run --rm -it \
        --dns=8.8.8.8 \
        --dns=1.1.1.1 \
        -e DEBUG_LEVEL=verbose \
        -p 443:443 \
        -p 80:80 \
        local-development-reverse-proxy-caddy:test
