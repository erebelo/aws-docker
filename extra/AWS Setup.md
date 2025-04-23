# AWS Setup

## SSH Keys (Locally)

1. Generate SSH key:

   `$ ssh-keygen`

2. List SSH keys:

   `$ ls ~/.ssh`

3. Copy public SSH key:

   `$ cat ~/.ssh/id_rsa.pub`

## AWS Console

[AWS Console](https://us-east-1.console.aws.amazon.com/console/home?region=us-east-1)

**NOTE**: be careful with step **#5** as it may incur additional charges from AWS.

1. Create VPC

2. Create Security Group: _EC2 -> Network & Security -> Security Group_ (allow access via SSH, TCP, HTTP, and HTTPS)

3. Add the SSH public key: _EC2 -> Key Pairs -> Actions -> Import key pair_

4. Create EC2 instance: _EC2 -> Instances -> Launch instances_

5. `[charged]` Create Elastic IPs (used to keep the same EC2 IP when instance is stopped and started):

   - _EC2 -> Network & Security -> Elastic IPs -> Allocate Elastic IP address_
   - _EC2 -> Network & Security -> Elastic IPs -> Actions -> Associate Elastic IP address -> Instance_

   To remove a created Elastic IP address, follow these steps:

   - _Actions -> Disassociate Elastic IP address_
   - _Actions -> Release Elastic IP address_

6. Create Route 53:

   - _Route 53 -> Hosted zones -> Create hosted zone_
   - _Route 53 -> Hosted zones -> Create record_

   **IMPORTANT**: whenever the EC2 instance is stopped, started, or rebooted, its Public IPv4 address may change. Be sure to update the corresponding values in your Route 53 DNS records to reflect the new IP address.

7. Set the Route traffic to Hostinger DNS / Nameservers

## AWS EC2 via SSH

1. Connect to EC2 via Git Bash (enter the ssh password):

   `$ ssh ec2-user@<EC2_INSTANCE_IPV4_ADDRESS>`

2. Update Linux packages:

   `$ sudo yum update`

3. Docker setup (if applicable):

   - Install docker:

     `$ sudo yum install docker`

   - Start docker:

     `$ sudo service docker start`

   - Login docker:

     `$ sudo docker login`

   - Add the ec2-user to the docker group to avoid using sudo every time for Docker commands:

     `$ sudo usermod -a -G docker ec2-user`

   - Exit from AWS to reflect the admin right:

     `$ exit`

4. Docker Compose setup (if applicable):

   - Install Docker Compose:

     `$ sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose`

   - Grant executable permission:

     `$ sudo chmod +x /usr/local/bin/docker-compose`

5. Install git (if applicable):

   `$ sudo yum install git`

---

Now, if applicable, perform one of the approaches from each of the following topics:

- [java-app](https://github.com/erebelo/aws-docker/tree/main/java-app)

- [ui-app](https://github.com/erebelo/aws-docker/tree/main/ui-app)

- [mongodb](https://github.com/erebelo/aws-docker/tree/main/mongodb)

- [nginx](https://github.com/erebelo/aws-docker/tree/main/nginx)
