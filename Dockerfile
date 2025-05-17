# Use the official Caddy image as base
FROM caddy:2.7-alpine

# Create directory for static files and transport configs
RUN mkdir -p /www /etc/caddy/transport

# Copy transport configurations
COPY http_transport https_transport /etc/caddy/transport/

# Install envsubst
RUN apk add --no-cache gettext

# Copy the Caddyfile template and entrypoint script
COPY Caddyfile.template /etc/caddy/Caddyfile.template
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /docker-entrypoint.sh

# Expose port 80
EXPOSE 80

# Set environment variables with default values
# Internal backend (e.g. WordPress) defaults
ENV INTERNAL_BACKEND_SCHEME=http
ENV INTERNAL_BACKEND_HOSTNAME=wordpress
ENV INTERNAL_BACKEND_PORT=80

# External backend defaults
ENV EXTERNAL_BACKEND_SCHEME=https
ENV EXTERNAL_BACKEND_HOSTNAME=api.example.com
ENV EXTERNAL_BACKEND_PORT=443
ENV EXTERNAL_BACKEND_PATTERN="^/github/.*"

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
