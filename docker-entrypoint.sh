#!/usr/bin/env bash

# Set up fallback values for header hosts
export INTERNAL_HEADER_UP_HOST=${INTERNAL_HEADER_UP_HOST:-${INTERNAL_BACKEND_HOSTNAME}:${INTERNAL_BACKEND_PORT}}
export EXTERNAL_HEADER_UP_HOST=${EXTERNAL_HEADER_UP_HOST:-${EXTERNAL_BACKEND_HOSTNAME}:${EXTERNAL_BACKEND_PORT}}

export INTERNAL_AUTH_TEMPLATE="none.conf"
export EXTERNAL_AUTH_TEMPLATE="none.conf"
# Handle internal basic auth
if [ -n "$INTERNAL_AUTH_USERNAME" ] && [ -n "$INTERNAL_AUTH_PASSWORD" ]; then
    export INTERNAL_AUTH_ENABLED=true
    export INTERNAL_AUTH_TEMPLATE="internal.conf"
    # Generate base64-encoded credentials for Authorization header
    credentials=$(printf "%s:%s" "$INTERNAL_AUTH_USERNAME" "$INTERNAL_AUTH_PASSWORD" | base64)
    export INTERNAL_AUTH_HEADER_VALUE="$credentials"
fi

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
