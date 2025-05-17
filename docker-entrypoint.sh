#!/bin/sh

# Set up fallback values for header hosts
export INTERNAL_HEADER_UP_HOST=${INTERNAL_HEADER_UP_HOST:-${INTERNAL_BACKEND_HOSTNAME}:${INTERNAL_BACKEND_PORT}}
export EXTERNAL_HEADER_UP_HOST=${EXTERNAL_HEADER_UP_HOST:-${EXTERNAL_BACKEND_HOSTNAME}:${EXTERNAL_BACKEND_PORT}}

# Generate Caddyfile from template
envsubst </etc/caddy/Caddyfile.template >/etc/caddy/Caddyfile

# Execute the main command
exec "$@"
