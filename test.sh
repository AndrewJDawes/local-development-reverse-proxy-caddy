#!/bin/bash

# Build the image
docker build -t caddy-proxy .

# Stop and remove any existing container
docker rm -f caddy-proxy-test 2>/dev/null || true

# Start the container with test configuration
docker run -d \
    --name caddy-proxy-test \
    --network=00b2a1da-64fa-44f2-9b85-21f18aa03b22_docker_local_dev_network \
    -p 8080:80 \
    -e INTERNAL_BACKEND_SCHEME=http \
    -e INTERNAL_BACKEND_HOSTNAME=00b2a1da-64fa-44f2-9b85-21f18aa03b22_wordpress \
    -e INTERNAL_BACKEND_PORT=80 \
    -e INTERNAL_HEADER_UP_HOST=localhost:1071 \
    -e EXTERNAL_BACKEND_SCHEME=https \
    -e EXTERNAL_BACKEND_HOSTNAME=api.github.com \
    -e EXTERNAL_BACKEND_PORT=443 \
    -e EXTERNAL_HEADER_UP_HOST=api.github.com \
    -e EXTERNAL_BACKEND_PATTERN="^/github/.*" \
    caddy-proxy

echo "Proxy started on http://localhost:8080"
echo ""
echo "Test the internal backend (localhost:1071):"
echo "curl http://localhost:8080/api/some/endpoint"
echo "curl http://localhost:8080/another/path"
echo ""
echo "Test the external backend (GitHub API):"
echo "curl http://localhost:8080/github/zen"
echo "curl http://localhost:8080/github/emojis"
echo ""
echo "View container logs:"
echo "docker logs caddy-proxy-test"
