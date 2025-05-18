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
    # Only hash the password if it's not already a bcrypt hash
    if [[ ! "$INTERNAL_AUTH_PASSWORD" =~ ^\$2[ayb]\$.* ]]; then
        password_hash=$(caddy hash-password --plaintext "$INTERNAL_AUTH_PASSWORD")
        export INTERNAL_AUTH_PASSWORD_HASH="$password_hash"
    else
        export INTERNAL_AUTH_PASSWORD_HASH="$INTERNAL_AUTH_PASSWORD"
    fi
fi

# Handle external basic auth
if [ -n "$EXTERNAL_AUTH_USERNAME" ] && [ -n "$EXTERNAL_AUTH_PASSWORD" ]; then
    export EXTERNAL_AUTH_ENABLED=true
    export EXTERNAL_AUTH_TEMPLATE="external.conf"
    # Only hash the password if it's not already a bcrypt hash
    if [[ ! "$EXTERNAL_AUTH_PASSWORD" =~ ^\$2[ayb]\$.* ]]; then
        password_hash=$(caddy hash-password --plaintext "$EXTERNAL_AUTH_PASSWORD")
        export EXTERNAL_AUTH_PASSWORD_HASH="$password_hash"
    else
        export EXTERNAL_AUTH_PASSWORD_HASH="$EXTERNAL_AUTH_PASSWORD"
    fi
fi

# Generate Caddyfile from template
envsubst </etc/caddy/Caddyfile.template >/etc/caddy/Caddyfile

# Execute the main command
exec "$@"
