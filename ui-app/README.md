# UI App Setup

## Locally

1. Create a new Docker Hub repository [rebelodocker/portfolio](https://hub.docker.com/)

2. Create a **Dockerfile** with the content:

   #### Dockerfile:

   ```
   # Use a lightweight Node.js base image for serving the application
   FROM node:20.13.1-alpine as build

   # Set the working directory inside the container
   WORKDIR /app

   # Copy only the package.json and package-lock.json files to leverage Docker's layer caching mechanism
   COPY package*.json ./

   # Install project dependencies
   RUN npm install --production

   # Copy the rest of the application code to the working directory
   COPY . .

   # Build the React application
   RUN npm run build

   # Use a lightweight Node.js base image for serving the application
   FROM node:20.13.1-alpine

   # Set the working directory inside the container
   WORKDIR /app

   # Copy only the built files from the previous stage
   COPY --from=build /app/build /app/build

   # Command to start the server and serve the built React application
   CMD ["npx", "serve", "-s", "build"]
   ```

3. Create the docker image by running the command using Git Bash terminal where the Dockerfile and the **<UI_APP>** is located:

   `$ docker buildx build --platform linux/amd64 -t rebelodocker/portfolio:v1.0 .`

4. Push the image to Docker Hub repository created earlier:

   `$ docker push rebelodocker/portfolio:v1.0`

5. Use a network already created or create a new one:

   `$ docker network create erebelo_cluster`

6. Create and start container (locally):

   ```
    docker run -d --name portfolio -p 3010:3000 --network erebelo_cluster \
    --restart unless-stopped \
    rebelodocker/portfolio:v1.0
   ```

## AWS EC2 via SSH

1. Connect to EC2 via Git Bash (enter the ssh password):

   `$ ssh ec2-user@<EC2_INSTANCE_IPV4_ADDRESS>`

2. Pull docker image:

   `$ docker pull rebelodocker/portfolio:v1.0`

3. Perform steps **#5** and **#6** described earlier
