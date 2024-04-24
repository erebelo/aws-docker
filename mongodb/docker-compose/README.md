##### `[BETTER APPROACH]`

# MongoDB with Replica Set and Mandatory Authentication (Docker Compose) - Locally & AWS EC2

**NOTE:** this solution using Docker Compose was the only one possible to enable mandatory authentication by keyfile when connecting to database.

Connection string: `mongodb://<USER>:<PASSWORD>@localhost:27017/?replicaSet=rs0&authMechanism=DEFAULT`

## Docker (Locally: Git Bash)

1. Create a new Docker Hub repository [rebelodocker/spring-mongodb-demo](https://hub.docker.com/)

2. There is an issue when running mongodb with replica set using Docker (at least for Windows), that it's not possible to connect to database after its creation. The workaround found is adding the following mapping to the hosts file _C:\Windows\System32\drivers\etc\hosts_:

   ```
   127.0.0.1   mongo1
   ```

3. As required, to push a docker image to Docker Hub, the docker image name needs to keep the Docker Hub pattern for the created repository. Therefore, for this it's necessary to create a **Dockerfile** and a **Docker Compose** with the contents below:

   #### Dockerfile:

   ```
   # Build mongodb
   FROM mongo:5
   ```

   #### docker-compose.yml:

   ```
   services:
     mongo1:
     container_name: mongo1
     restart: unless-stopped
     image: ${IMAGE_NAME}
     command: ["bash", "-c", "chmod 400 /keyfile && exec mongod --replSet rs0 --bind_ip localhost,mongo1 --keyFile /keyfile --auth"]
     ports:
       - "27017:27017"
     networks:
       - mongo_cluster
     volumes:
       - mongo1_data:/data/db
       - mongo1_configdb:/data/configdb
       - ./keyfile:/keyfile
     environment:
       - MONGO_INITDB_ROOT_USERNAME=${ROOT_USER}
       - MONGO_INITDB_ROOT_PASSWORD=${ROOT_PWD}

   networks:
     mongo_cluster:
       external: true

   volumes:
     mongo1_data:
       external: true
     mongo1_configdb:
       external: true
   ```

4. Create image set by Dockerfile:

   `$ docker buildx build --platform linux/amd64 -t rebelodocker/spring-mongodb-demo:mongodb-auth .`

5. Push the image to Docker Hub repository created earlier:

   `$ docker push rebelodocker/spring-mongodb-demo:mongodb-auth`

6. Generate a random sequence of 756 bytes using OpenSSL and grant read permission only for the file owner:

   `$ openssl rand -base64 756 > keyfile`

   `$ chmod 400 keyfile # Igonore if the permission is already set in docker-compose.yml by the command field`

7. Create a new network:

   `$ docker network create mongo_cluster`

8. Create the new volumes:

   `$ docker volume create mongo1_data`

   `$ docker volume create mongo1_configdb`

9. Create and start container:

   `$ docker-compose --env-file ../scripts/.env up -d`

10. Set the executable permission for the file **win-setup.sh** (creates replica set, database users, and collections) and run it in the directory where the script and the .env are:

    NOTE: Use **win-setup.sh** for Windows and **linux-setup.sh** for Linux SO.

    `$ cd ../scripts`

    `$ chmod +x win-setup.sh`

    `$ ./win-setup.sh`

11. Testing manually (optional):

    `$ winpty docker exec -it mongo1 mongosh # remove 'winpty' prefix if running on Linux`

    `$ use admin`

    `$ db.auth("root", <ROOT_PASSWORD>)`

    `$ show users`

    `$ rs.status()`

    `$ exit`

12. When wanting to clean mongo docker (container, image, and volumes), set the executable permission to the **cleanup.sh** file and run it (optional):

    `$ chmod +x cleanup.sh`

    `$ ./cleanup.sh`

## AWS via SSH (Locally: Git Bash)

1.  Connect to EC2 via Git Bash (enter the public ssh password):

    `$ ssh ec2-user@<EC2_INSTANCE_IPV4_ADDRESS>`

2.  Perform a similar approach as previously described in step **#2** by adding the **_mongo1_** mapping to the hosts file, but now for Linux OS:

    - Edit the /etc/hosts:

      `$ sudo vim /etc/hosts`

      `$ i`

    - Add **_mongo1_** to the end of the mapping for host **_127.0.1.1_**. The file should look like below:
      ```
      127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4 mongo1
      ::1         localhost6 localhost6.localdomain6
      ```
    - Exit and save by pressing the keys below:

      `$ Esc`

      `$ :wq`

3.  Pull docker image:

    `$ docker pull rebelodocker/spring-mongodb-demo:mongodb-auth`

4.  Perform steps **#6**, **#7**, **#8**, **#9**, and **#10** described earlier by using the github repository to get all required files

5.  Connect to AWS EC2 **_mongo1_** container by local **MongoDB Compass IDE**:

    - Use the following connection string:

      `mongodb://<USER>:<PASSWORD>@localhost:27017/?replicaSet=rs0&authMechanism=DEFAULT`

    - In **Authentication** tab, leave the **Username/Password** option set and fill the fields as follow:
      ```
      Username: <DB_USERNAME>
      Password: <DB_PASSWORD>
      Authentication Database: <DB_NAME>
      ```
    - In **Proxy/SSH** tab, leave the **SSH with Identity File** option set and fill the fields as follow:

      ````
      SSH Hostname: <EC2_INSTANCE_IPV4_ADDRESS>
      SSH Port: 22
      SSH Username: ec2-user
      SSH Identity File: get the id_rsa private file generated by SSH connection
      SSH Passphrase: <SSH_PASSWORD>```
      ````

---

Now, if applicable, perform one of the approaches from **java-app** described in README.md to deploy a **Java App** instance.
