#!/bin/sh

# Generate Caddyfile from template
envsubst </etc/caddy/Caddyfile.template >/etc/caddy/Caddyfile

# Execute the main command
exec "$@"
