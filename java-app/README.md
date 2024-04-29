##### `[BETTER APPROACH]`

# Docker Setup - Locally & AWS EC2

## Docker (Locally: Git Bash)

1. Create a new Docker Hub repository [rebelodocker/spring-security-jwt](https://hub.docker.com/)

2. Create a **Dockerfile** with the content:

   #### Dockerfile:

   ```
   # Build the application
   FROM maven:3.8.4-openjdk-17 AS build
   WORKDIR /app
   COPY pom.xml .
   COPY src ./src
   RUN mvn clean install

   # Run the application
   FROM openjdk:17-alpine
   WORKDIR /app
   COPY --from=build /app/target/spring-security-jwt-0.0.1-SNAPSHOT.jar ./ss-jwt.jar
   EXPOSE 8080
   CMD ["java", "-jar", "ss-jwt.jar"]
   ```

3. Create the docker image by running the command using Git Bash terminal where the Dockerfile and the **target/<APP>.jar** is located:

   NOTE: one possible solution is to copy the **<APP>.jar** to where the Dockerfile is located.

   `$ docker buildx build --platform linux/amd64 -t rebelodocker/spring-security-jwt:v1.0 .`

4. Push the image to Docker Hub repository created earlier:

   `$ docker push rebelodocker/spring-security-jwt:v1.0`

5. Create a new network:

   `$ docker network create erebelo_cluster`

6. Create and start container (locally):

   - Example 1 for a simple Java App (Spring Security JWT):

     ```
     $ docker run -d --name ss-jwt -p 8000:8080 --network erebelo_cluster \
     -e ADMIN_PASSWORD=<ADMIN_PASSWORD> \
     -e SECRET_KEY=<SECRET_KEY> \
     --restart unless-stopped \
     rebelodocker/spring-security-jwt:v1.0
     ```

   - Example 2 for a Java App with database within the same network (Spring MongoDB Demo):

     NOTE: the host property should use the name of the previously defined database container (mongo1).

     ```
     $ docker run -d --name springmongodb -p 8001:8080 --network erebelo_cluster \
     -e SPRING_PROFILES_ACTIVE=dev \
     -e DB_HOST=mongo1 \
     -e DB_PORT=27017 \
     -e DB_NAME=<DB_NAME> \
     -e DB_USERNAME=<DB_USERNAME> \
     -e DB_PASSWORD=<DB_PASSWORD> \
     --restart unless-stopped \
     rebelodocker/spring-mongodb-demo:springmongodb
     ```

## AWS via SSH (Locally: Git Bash)

1. Connect to EC2 via Git Bash (enter the ssh password):

   `$ ssh ec2-user@<EC2_INSTANCE_IPV4_ADDRESS>`

2. Pull docker image:

   `$ docker pull rebelodocker/spring-security-jwt:v1.0`

3. Perform steps **#5** and **#6** described earlier

---

##### `[SECOND APPROACH]`

# Setup for Running Java App without Docker - AWS EC2

## AWS via SSH (Locally: Git Bash)

1.  Connect to EC2 via Git Bash (enter the ssh password):

    `$ ssh ec2-user@<EC2_INSTANCE_IPV4_ADDRESS>`

2.  Install Java:

    `$ sudo yum install java-17-amazon-corretto-headless.x86_64`

3.  Environment Variables:

    - Use the nano to edit bash_profile file:

      `$ nano ~/.bash_profile`

    - Add the variables at the end of the file:

      `$ export myVariable=VARIABLE_VALUE`

    - Press _Ctrl + O (Write Out) -> Press Enter -> Press Ctrl + X_ to exit nano

    - To apply the changes:

      `$ source ~/.bash_profile`

    - Print environment variables:

      `$ env`

4.  Run the spring boot application:

    **NOTE**: Before performing this step **#4**, perform the steps under **IntelliJ Terminal** topic below and then continue here.

    `$ java -jar <APP>.jar`

### IntelliJ Terminal

1. Build the project:

   `$ maven package`

2. Copy and send the project .jar to the EC2 instance:

   `$ scp .\target\<APP>.jar ec2-user@<EC2_INSTANCE_IPV4_ADDRESS>:/home/ec2-user`

---

**NOTE**: The downside of not using Docker is that the AWS via SSH terminal must always be open to work.
