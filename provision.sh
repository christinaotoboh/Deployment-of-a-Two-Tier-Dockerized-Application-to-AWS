#!/bin/bash

# Switch to root user (might not be necessary)

echo "================================="
echo "   Updating system packages"
echo "================================="

echo "=============================================================="
echo "  Update the package index and install required dependencies "                                                                                                              echo "==============================================================="

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
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Add dcoker user to docker group (so no sudo needed)
usermod -aG docker docker

  # Enable and start Docker
    systemctl enable docker
    systemctl start docker


