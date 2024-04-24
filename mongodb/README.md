# MongoDB Deployment

## Aproaches

- [docker-compose](https://github.com/erebelo/aws-docker/tree/main/mongodb/docker-compose): this approach uses **Docker Compose** combined with **Dockerfile** to generate an image with a custom name and launches a MongoDB container set up with **Replica Set** and **Mandatory Authentication**

- [dockerfile](https://github.com/erebelo/aws-docker/tree/main/mongodb/dockerfile): this approach uses only **Dockerfile** to generate an image with a custom name and launches a MongoDB container set up with **Replica Set**, but **No Mandatory Authentication**
