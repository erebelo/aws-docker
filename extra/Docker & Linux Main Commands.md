# Docker & Linux Main Commands

## Docker

### 1. Image Management:

```
# List all Docker images
$ docker images

# Build an image from a Dockerfile
$ docker build <OPTIONS> <PATH_TO_DOCKERFILE>

# Pull an image or a repository from a registry
$ docker pull <IMAGE_NAME>

# Push an image or a repository to a registry
$ docker push <IMAGE_NAME>

# Remove one or more images
$ docker rmi <IMAGE_NAME>
```

### 2. Container Lifecycle:

```
# List running containers
$ docker ps

# List all containers (including stopped ones)
$ docker ps -a

# Create and start a container
$ docker run <OPTIONS> <IMAGE_NAME>

# Start one or more stopped containers
$ docker start <CONTAINER_ID>

# Stop one or more running containers
$ docker stop <CONTAINER_ID>

# Restart one or more containers
$ docker restart <CONTAINER_ID>

# Remove one or more containers
$ docker rm <CONTAINER_ID>

# Kill one or more running containers
$ docker kill <CONTAINER_ID>

# Pause all processes within one or more containers
$ docker pause <CONTAINER_ID>

# Unpause all processes within one or more containers
$ docker unpause <CONTAINER_ID>

# Track container logs in real-time
$ docker logs -f <CONTAINER_ID>
```

### 3. Volume:

```
# List the volumes
$ docker volume ls

# Remove a volume
$ docker volume rm <VOLUME_NAME>

# Remove all volumes not used by at least one container
$ docker volume prune
```

### 4. Network:

```
# Create a network
$ docker network create <NETWORK_NAME>

# List the networks
$ docker network ls

# Remove a network
$ docker network rm <NETWORK_NAME>
```

### 5. Logs:

```
# Track container logs
$ docker logs -f
```

## Linux

```
# List all files and directories in long form
$ ls -l

# List all files and directories, including hidden ones in long format
$ ls -a -l

# Remove file
$ rm <FILE_NAME>

# Remove directory and its contents
$ rm -rf <DIRECTORY_NAME>

# Copy file to another path
$ cp <FILE_NAME> /<PATH>

# Copy file to current parent directory
$ cp <FILE_NAME> ../

# Create environment variable
$ export <ENV_VARIABLE>=<ENV_VARIABLE_VALUE>

# Print environment variable value
$ echo $<ENV_VARIABLE>

# Remove environment variable
$ unset <ENV_VARIABLE>

# Disk space usage information
$ df -h

# Real-time information about system resources, such as cpu, memory, and process state (S)
$ top

# Memory information, such as total memory, used memory, and free memory
$ free -h
```

#### Script (`env.sh`) to set multiple environment variables on Linux:

```
#!/bin/bash
export `<ENV_VARIABLE>**=<ENV_VARIABLE_VALUE>;
export <ENV_VARIABLE_2>=<ENV_VARIABLE_VALUE_2>;
```

Run the commands below in the terminal:

`$ chmod +x env.sh`

`$ source env.sh`

## Git

```
# Reset local branch to remote
git reset --hard HEAD
```
