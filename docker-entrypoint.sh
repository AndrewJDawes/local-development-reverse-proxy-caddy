#!/usr/bin/env bash

# Set up fallback values for header hosts
export EXTERNAL_HEADER_UP_HOST=${EXTERNAL_HEADER_UP_HOST:-${EXTERNAL_BACKEND_HOSTNAME}:${EXTERNAL_BACKEND_PORT}}

export EXTERNAL_AUTH_TEMPLATE="none.conf"

# Handle external basic auth
if [ -n "$EXTERNAL_AUTH_USERNAME" ] && [ -n "$EXTERNAL_AUTH_PASSWORD" ]; then
    export EXTERNAL_AUTH_ENABLED=true
    export EXTERNAL_AUTH_TEMPLATE="external.conf"
    # Generate base64-encoded credentials for Authorization header
    credentials=$(printf "%s:%s" "$EXTERNAL_AUTH_USERNAME" "$EXTERNAL_AUTH_PASSWORD" | base64)
    export EXTERNAL_AUTH_HEADER_VALUE="$credentials"
fi

# Generate Caddyfile from template
envsubst </etc/caddy/Caddyfile.template >/etc/caddy/Caddyfile

# Execute the main command
exec "$@"
