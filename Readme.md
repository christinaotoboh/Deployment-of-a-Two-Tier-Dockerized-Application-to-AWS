# WordPress Deployment on AWS EC2 using Docker

## Overview
This project demonstrates the provisioning and deployment of a WordPress application using Docker on an AWS EC2 instance. The setup includes a MySQL database, persistent storage using an EBS volume, and backup storage using Amazon S3.

---

## What I Did

### 1. Provisioned an EC2 Instance
- Launched a Linux-based EC2 instance
- Configured security group to allow:
  - Port 22 (SSH access)
  - Port 80 (HTTP access)

---

### 2. Installed Docker
- Installed Docker on the EC2 instance
- Enabled and started the Docker service
- Verified Docker installation

---

### 3. Deployed WordPress and MySQL using Docker
- Pulled official Docker images for:
  - WordPress
  - MySQL
- Created and ran containers for both services using docker compose
- Configured environment variables for database connection
- Ensured WordPress connects to MySQL via Docker network

---

### 4. Configured Persistent Storage (EBS Volume)
- Attached an EBS volume to the EC2 instance
- Mounted the volume to the instance filesystem
- Used a bind mount to store MySQL data on the EBS volume
- Ensured database data persists beyond container restarts

---

### 5. Enabled Application Access
- Accessed the WordPress application via the EC2 public IP
- Completed WordPress setup through the browser
- Verified database connectivity and application functionality

---

### 6. Implemented Backup Strategy
- Created backups of the MySQL database
- Stored backups in an S3 bucket for durability and recovery

---

## Key Features of the Setup

- Containerized application using Docker
- Separation of application (WordPress) and database (MySQL)
- Persistent storage using EBS
- Remote accessibility via public IP
- Backup storage using S3

---

## Outcome
At the end of this project, I successfully deployed a working WordPress application on AWS using Docker, ensured data persistence with EBS, and implemented a basic backup strategy using S3.

---

## Notes
- The application is currently served over HTTP (port 80)
