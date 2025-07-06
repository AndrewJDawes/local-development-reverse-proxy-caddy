# Use the official Caddy image as base
FROM caddy:2.7-alpine

# Expose port 80
EXPOSE 443

# External backend defaults
ENV EXTERNAL_BACKEND_SCHEME=https
ENV EXTERNAL_BACKEND_HOSTNAME=api.example.com
ENV EXTERNAL_BACKEND_PORT=443
ENV EXTERNAL_HEADER_UP_HOST=api.example.com
ENV EXTERNAL_BACKEND_COOKIE_HEADER_UP_ENABLED=false
ENV EXTERNAL_BACKEND_COOKIE_HEADER_DOWN_ENABLED=false

# Install envsubst
RUN apk add --no-cache gettext bash openssl

RUN cd /srv && openssl req \
    -x509 \
    -newkey rsa:4096 \
    -keyout key.pem \
    -out cert.pem \
    -sha256 \
    -days 365 \
    -nodes \
    -subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=blah.local"

COPY docker-entrypoint.sh /docker-entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /docker-entrypoint.sh

# Copy configurations
COPY ./etc/caddy /etc/caddy

ENV DEBUG_LEVEL=none

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
