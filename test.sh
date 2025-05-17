#!/bin/bash

# Build the image
docker build -t caddy-proxy .

# Stop and remove any existing container
docker rm -f caddy-proxy-test 2>/dev/null || true

# Start the container with test configuration
docker run -d \
    --name caddy-proxy-test \
    -p 8080:80 \
    -e INTERNAL_BACKEND_SCHEME=https \
    -e INTERNAL_BACKEND_HOSTNAME=httpbin.org \
    -e INTERNAL_BACKEND_PORT=443 \
    -e EXTERNAL_BACKEND_SCHEME=https \
    -e EXTERNAL_BACKEND_HOSTNAME=api.github.com \
    -e EXTERNAL_BACKEND_PORT=443 \
    -e EXTERNAL_BACKEND_PATTERN="^/github/.*" \
    caddy-proxy

echo "Proxy started on http://localhost:8080"
echo ""
echo "Test the internal backend (httpbin.org):"
echo "curl http://localhost:8080/get"
echo "curl http://localhost:8080/headers"
echo ""
echo "Test the external backend (GitHub API):"
echo "curl http://localhost:8080/github/zen"
echo "curl http://localhost:8080/github/emojis"
echo ""
echo "View container logs:"
echo "docker logs caddy-proxy-test"
