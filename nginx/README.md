# Nginx HTTP Setup

## Locally

1. Create a new Docker Hub repository [rebelodocker/nginx](https://hub.docker.com/)

2. Create a **Dockerfile** with the content below:

   #### Dockerfile:

   ```
   # Build nginx
   FROM nginx:1.25.5
   ```

3. Create an image set by Dockerfile:

   `$ docker buildx build --platform linux/amd64 -t rebelodocker/nginx:v1.25.5 .`

4. Push the image to Docker Hub repository created earlier:

   `$ docker push rebelodocker/nginx:v1.25.5`

5. Use a network already created or create a new one:

   `$ docker network create erebelo_cluster`

6. Create and start container:

   ```
    $ docker run -d --name nginx-http -p 80:80 --network erebelo_cluster \
    --restart unless-stopped \
    rebelodocker/nginx:v1.25.5
   ```

7. Get the **Nginx Configuration File** provided by the filename **nginx-http.conf** and change the values of the following fields:

   - _http -> server -> listen_
   - _http -> server -> server_name_
   - _http -> server -> location -> proxy_pass_

8. Copy the file **nginx-http.conf** from the local filesystem into the Docker container:

   `$ docker cp nginx-http.conf nginx-http:/etc/nginx/nginx.conf`

9. Restart the container:

   `$ docker restart nginx-http`

10. Testing manually (optional):

    `$ winpty docker exec -it <CONTAINER_NAME> bash # remove 'winpty' prefix if running on Linux`

    `$ /usr/sbin/nginx -v`

    `$ cat /etc/nginx/nginx.conf`

    `$ exit`

## AWS EC2 via SSH

1.  Connect to EC2 via Git Bash (enter the public ssh password):

    `$ ssh ec2-user@<EC2_INSTANCE_IPV4_ADDRESS>`

2.  Pull docker image:

    `$ docker pull rebelodocker/nginx:v1.25.5`

3.  Perform steps **#5**, **#6**, **#7**, **#8**, and **#9** described earlier by using the GitHub repository to get all required files

---

# Nginx HTTPS Setup

## Locally

1. Create a new Docker Hub repository [rebelodocker/nginx](https://hub.docker.com/)

2. Create a **Dockerfile** with the content below:

   #### Dockerfile:

   ```
   # Build nginx
   FROM nginx:1.25.5
   ```

3. Create an image set by Dockerfile:

   `$ docker buildx build --platform linux/amd64 -t rebelodocker/nginx:v1.25.5 .`

4. Push the image to Docker Hub repository created earlier:

   `$ docker push rebelodocker/nginx:v1.25.5`

## AWS EC2 via SSH

1.  Connect to EC2 via Git Bash (enter the public ssh password):

    `$ ssh ec2-user@<EC2_INSTANCE_IPV4_ADDRESS>`

2.  Pull docker image:

    `$ docker pull rebelodocker/nginx:v1.25.5`

3.  Use a network already created or create a new one:

    `$ docker network create erebelo_cluster`

4.  Create and start container:

    **NOTE**: before performing this step **#4**, follow the steps under **Generate Wildcard SSL/TLS Certificate through Let's Encrypt** topic below. If the certificate generation was used for renewal, the **nginx-https** container must be stopped and removed.

    ```
    $ docker run -d --name nginx-https -p 80:80 -p 443:443 --network erebelo_cluster \
    -v /etc/letsencrypt/certs:/etc/nginx/certs \
    --restart unless-stopped \
    rebelodocker/nginx:v1.25.5
    ```

5.  Get the **Nginx Configuration File** provided by the filename **nginx-https.conf** and change the values of the following fields:

    - _http -> server -> listen_
    - _http -> server -> server_name_
    - _http -> server -> ssl_certificate_
    - _http -> server -> ssl_certificate_key_
    - _http -> server -> location -> proxy_pass_

6.  Copy the file **nginx-https.conf** from the local filesystem into the Docker container:

    `$ docker cp nginx-https.conf nginx-https:/etc/nginx/nginx.conf`

7.  Restart the container:

    `$ docker restart nginx-https`

8.  Testing manually (optional):

    `$ winpty docker exec -it <CONTAINER_NAME> bash # remove 'winpty' prefix if running on Linux`

    `$ /usr/sbin/nginx -v`

    `$ cat /etc/nginx/nginx.conf`

    `$ exit`

#### Generate Wildcard SSL/TLS Certificate through Let's Encrypt

1.  Install Certbot:

    `$ sudo yum install certbot`

2.  Generate or renew certificate files:

    **NOTE**: if an error message similar to _**Another instance of Certbot is already running**_ occurs during the creation of the Wildcard SSL/TLS Certificate, it is essential to terminate the existing Certbot process before proceeding. In this case, run the commands below:

    ```
    # Find certbot process:
    $ ps -ef | grep certb

    # Kill it by the process ID (it's the first number after the user):
    $ sudo kill 5555
    ```

    `$ sudo certbot certonly --manual --preferred-challenges=dns --email <EMAIL> --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d erebelo.com -d *.erebelo.com`

    Follow the instructions provided to create a TXT file in _Route 53 -> Hosted zones -> erebelo.com -> Create record_:

    **NOTE**: create the record name only with **\_acme-challenge** as the domain name will be automatically added to it.

    ```
    Please deploy a DNS TXT record under the name:
    _acme-challenge.erebelo.com.
    with the following value: <CHALLENGE_VALUE>

    Record name: _acme-challenge.erebelo.com
    Record type: TXT
    Value: <CHALLENGE_VALUE>
    ```

    **IMPORTANT**: Wait until the new record is `INSYNC` to press Enter in the terminal.

    ```
    Successfully received certificate.
    Certificate is saved at: /etc/letsencrypt/live/erebelo.com/fullchain.pem
    Key is saved at: /etc/letsencrypt/live/erebelo.com/privkey.pem
    This certificate expires on yyyy-MM-dd.
    These files will be updated when the certificate renews.
    ```

3.  Verify that the certificate is created:

    `$ sudo certbot certificates`

4.  Copy the files that symbolic links point to another directory:

    `sudo cp -r -L /etc/letsencrypt/live/erebelo.com/fullchain.pem /etc/letsencrypt/certs/`

    `sudo cp -r -L /etc/letsencrypt/live/erebelo.com/privkey.pem /etc/letsencrypt/certs/`

**IMPORTANT**: If this process is being used for **certificate renewal**, you must run the container creation again at the end of this process, as described in [step #4 under Nginx HTTPS Setup -> AWS EC2 via SSH](#aws-ec2-via-ssh-1). This ensures the renewed certificate is correctly mounted and used.
