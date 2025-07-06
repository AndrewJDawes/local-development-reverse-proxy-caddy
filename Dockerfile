# Use the official Caddy image as base
# Build stage
FROM golang:1.24 AS builder

# Install xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# Build Caddy with the forwardproxy plugin
RUN xcaddy build --with github.com/caddyserver/forwardproxy

# Final image
FROM caddy:2.7.6-alpine

COPY --from=builder /go/caddy /usr/bin/caddy

# Expose port 80
EXPOSE 80
EXPOSE 2019

# External backend defaults
ENV EXTERNAL_BACKEND_SCHEME=https
ENV EXTERNAL_BACKEND_HOSTNAME=api.example.com
ENV EXTERNAL_BACKEND_PORT=443
ENV EXTERNAL_HEADER_UP_HOST=api.example.com
ENV EXTERNAL_BACKEND_COOKIE_HEADER_UP_ENABLED=false
ENV EXTERNAL_BACKEND_COOKIE_HEADER_DOWN_ENABLED=false

# Install envsubst
RUN apk add --no-cache gettext bash

COPY docker-entrypoint.sh /docker-entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /docker-entrypoint.sh

# Copy configurations
COPY ./etc/caddy /etc/caddy

ENV DEBUG_LEVEL=none

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
