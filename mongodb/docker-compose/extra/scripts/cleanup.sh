#!/bin/bash

# Source environment variables
source .env

echo "Cleaning up mongo docker..."

# Stop and remove the container
docker rm -f ${CONTAINER_1_NAME} ${CONTAINER_2_NAME} ${CONTAINER_3_NAME}

# Remove the image
docker rmi ${IMAGE_NAME}

# Prune unused volumes
docker volume prune -f

# Remove the specific volume
docker volume rm ${VOLUME_MONGO_1_DATA} ${VOLUME_MONGO_1_CONFIG} ${VOLUME_MONGO_2_DATA} ${VOLUME_MONGO_2_CONFIG} ${VOLUME_MONGO_3_DATA} ${VOLUME_MONGO_3_CONFIG}