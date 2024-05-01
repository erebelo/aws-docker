# Nginx - Locally & AWS EC2

## Docker (Locally: Git Bash)

1. Create a new Docker Hub repository [rebelodocker/nginx](https://hub.docker.com/)

2. Create a **Dockerfile** with the content below:

   #### Dockerfile:

   ```
   # Build nginx
   FROM nginx:1.25.5
   ```

3. Create image set by Dockerfile:

   `$ docker buildx build --platform linux/amd64 -t rebelodocker/nginx:v1.25.5 .`

4. Push the image to Docker Hub repository created earlier:

   `$ docker push rebelodocker/nginx:v1.25.5`

5. Get the **Nginx Configuration File** provided by the filename **nginx-http.conf** and change the values of the following fields:

   - _http -> server -> listen_
   - _http -> server -> server_name_
   - _http -> server -> location -> proxy_pass_

6. Use the network created for the Apps or create a new one:

   `$ docker network create erebelo_cluster`

7. Create and start container:

   HTTP:

   ```
    $ docker run -d --name nginx-http -p 80:80 --network erebelo_cluster \
    --restart unless-stopped \
    rebelodocker/nginx:v1.25.5
   ```

   `$ docker cp nginx-http.conf nginx-http:/etc/nginx/nginx.conf`

   `$ docker restart nginx-http`

   HTTPS:

   ```
   $ docker run -d --name nginx-https -p 80:80 -p 443:443 --network erebelo_cluster \
   --restart unless-stopped \
   -v /etc/letsencrypt/certs:/etc/nginx/certs \
   rebelodocker/nginx:nginx:v1.25.5
   ```

   `$ docker cp nginx-https.conf nginx-http:/etc/nginx/nginx.conf`

   `$ docker restart nginx-https`

8. Testing manually (optional):

   `$ winpty docker exec -it <CONTAINER_NAME> bash # remove 'winpty' prefix if running on Linux`

   `$ /usr/sbin/nginx -v`

   `$ exit`

## AWS via SSH (Locally: Git Bash)

1.  Connect to EC2 via Git Bash (enter the public ssh password):

    `$ ssh ec2-user@<EC2_INSTANCE_IPV4_ADDRESS>`

2.  Pull docker image:

    `$ docker pull rebelodocker/nginx:v1.25.5`

3.  Perform steps **#6** and **#7** described earlier
