# Use the official Caddy image as base
FROM caddy:2.7-alpine

# Expose port 80
EXPOSE 80

# Set environment variables with default values
# Web root directory
ENV WEB_ROOT=/www

# Internal backend (e.g. WordPress) defaults
ENV INTERNAL_BACKEND_SCHEME=http
ENV INTERNAL_BACKEND_HOSTNAME=wordpress
ENV INTERNAL_BACKEND_PORT=80
ENV INTERNAL_HEADER_UP_HOST=wordpress

# External backend defaults
ENV EXTERNAL_BACKEND_SCHEME=https
ENV EXTERNAL_BACKEND_HOSTNAME=api.example.com
ENV EXTERNAL_BACKEND_PORT=443
ENV EXTERNAL_HEADER_UP_HOST=api.example.com
ENV EXTERNAL_BACKEND_PATTERN="^/github/.*"

# Install envsubst
RUN apk add --no-cache gettext

COPY docker-entrypoint.sh /docker-entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /docker-entrypoint.sh

# Copy configurations
COPY ./etc/caddy /etc/caddy

ENV DEBUG_LEVEL=none

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
