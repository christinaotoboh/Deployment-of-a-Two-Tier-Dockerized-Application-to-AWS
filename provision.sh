#!/bin/bash

sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release -y

#Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg


# Set up the Docker apt repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Install the Docker Engine packages
sudo apt update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y


# Add dcoker user to docker group (so no sudo needed)
sudo usermod -aG docker ubuntu

  # Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# Format the EBS volume and make it a filesystem 
sudo mkfs -t ext4 /dev/nvme1n1

#Create a mount point where the EBS Volume will appear
sudo mkdir -p /mnt/ebs

#Mount the volume to the mount point (Folder)
sudo mount /dev/nvme1n1 /mnt/ebs

# Create a folder on the mounted EBS volume for mysql to write to
sudo mkdir -p /mnt/ebs/mysql-data

# mysql runs as a user with UID:999, grant it ownership to the volume directory so that it can write into it
sudo chown -R 999:999 /mnt/ebs/mysql-data

