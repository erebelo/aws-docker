# AWS Docker

This article provides a detailed step-by-step guide on how to deploy a **MongoDB**, **Java App**, and **UI App** instances using Docker, locally and on AWS EC2.

Additionally, it provides how to set up **Nginx** as a reverse proxy for multiple Apps running on a single EC2 instance and responding to the same HTTP (80) and HTTPS (443) ports.

Start with the [AWS Setup](https://github.com/erebelo/aws-docker/tree/main/setup) section to configure the necessary resources on the AWS account, such as a VPC, Security Group, EC2 instance, and more. Completing these steps ensures the environment is properly prepared for the deployment instructions outlined below:

- [mongodb](https://github.com/erebelo/aws-docker/tree/main/mongodb): guide that describes two approaches on how to deploy a **MongoDB** using Docker.

- [java-app](https://github.com/erebelo/aws-docker/tree/main/java-app): guide that describes an approach on how to deploy a **Java App** using Docker.

- [ui-app](https://github.com/erebelo/aws-docker/tree/main/ui-app): guide that describes an approach on how to deploy an **UI App** using Docker.

- [nginx](https://github.com/erebelo/aws-docker/tree/main/nginx): guide that describes how to set up **Nginx** as a reverse proxy for HTTP and HTTPS protocols, including the setup of a valid Wildcard SSL/TLS Certificate for secure communication.
