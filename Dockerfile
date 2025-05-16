# Use the official Caddy image as base
FROM caddy:2.7-alpine

# Create directory for static files
RUN mkdir -p /www

# Copy the Caddyfile to the container
COPY Caddyfile /etc/caddy/Caddyfile

# Expose port 80
EXPOSE 80

# Set environment variables with default values
# Internal backend (e.g. WordPress) defaults
ENV INTERNAL_BACKEND_PROTOCOL=http
ENV INTERNAL_BACKEND_HOSTNAME=wordpress
ENV INTERNAL_BACKEND_PORT=80

# External backend defaults
ENV EXTERNAL_BACKEND_PROTOCOL=http
ENV EXTERNAL_BACKEND_HOSTNAME=api
ENV EXTERNAL_BACKEND_PORT=80
ENV EXTERNAL_BACKEND_PATTERN="^/api/.*"
