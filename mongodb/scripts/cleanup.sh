#!/bin/bash

# Source environment variables
source .env

echo "Cleaning up mongo docker..."

# Stop and remove the container
docker rm -f ${CONTAINER_NAME}

# Remove the image
docker rmi ${IMAGE_NAME}

# Prune unused volumes
docker volume prune -f

# Remove the specific volume
docker volume rm ${VOLUME_MONGO_DATA} ${VOLUME_MONGO_CONFIG}