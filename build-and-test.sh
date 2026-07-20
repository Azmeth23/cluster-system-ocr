#!/bin/bash
set -e

# Username & image tags 
DOCKER_USER="azmeth07"
REPO="ocr-p-repo"

GATEWAY_TAG="$DOCKER_USER/$REPO:api-gateway"
OCR_TAG="$DOCKER_USER/$REPO:ocr-model"

echo "Building Docker Images;"
docker build -t $GATEWAY_TAG ./api-gateway
docker build -t $OCR_TAG ./ocr-model

echo "Setting Up Local Network & Cleanup;"
docker network create ocr-network 2>/dev/null || true
docker rm -f ocr-model-container local-api-gateway 2>/dev/null || true

echo "Starting Containers Locally;"
# Runs the ocr model container
docker run -d \
  --name ocr-model-container \
  --network ocr-network \
  -p 8080:8080 \
  $OCR_TAG

# Runs the api gateway container with network link
docker run -d \
  --name local-api-gateway \
  --network ocr-network \
  -p 8000:8000 \
  $GATEWAY_TAG

sleep 5

echo "Validating Health"
curl --fail http://localhost:8000/docs || { echo "Gateway failed to respond!"; exit 1; }

echo "Pushing to Docker Hub;"
docker push $GATEWAY_TAG
docker push $OCR_TAG

echo "Images built and launched;"
echo "- API Gateway running on http://localhost:8000"
echo "- OCR Model running on http://localhost:8080"
echo " Run 'docker logs local-api-gateway' or 'docker logs local-ocr-model' to check outputs."
echo "Use 'docker rm -f local-api-gateway ocr-model-container' and 'docker network rm ocr-network' to stop them." 