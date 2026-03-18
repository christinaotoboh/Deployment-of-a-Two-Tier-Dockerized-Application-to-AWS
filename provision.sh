#!/bin/bash
set -e

echo "============================================================"
echo "Provisioning script is now running"
echo "============================================================"

# Status of docker on the server

if  command -v docker &>/dev/null || sudo systemctl is-active --quiet docker; then
  echo "docker $(docker --version) is installed and running. Skip docker installation"
else
  echo "Docker is not installed, installing docker ................"
  
  #Update packages
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
echo "docker $(docker -v) has been installed......"
fi



# Install aws cli

echo "============================================"
echo "Installing aws cli"
echo "============================================"

if command -v aws &>/dev/null; then
  echo "aws CLI $(aws --version) is installed"
else

  # Download the official AWS CLI v2 installer. I am using Ubuntu
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"

  # Unzip it
  sudo apt install unzip -y
  unzip /tmp/awscliv2.zip -d /tmp

  # Run the installer
  sudo /tmp/aws/install

  # Verify installation
  aws --version

  # Cleanup
  rm -rf /tmp/awscliv2.zip /tmp/aws
fi

# Format the EBS volume and make it a filesystem 
echo "==========================================="
echo "Mounting EBS Volume"
echo "==========================================="

if mountpoint -q /mnt/ebs; then
  echo "EBS Volume is mounted"
else
  echo "EBS Volume is not mounted.... Mounting EBS Volume"

  #Format the EBS volume
  sudo mkfs -t ext4 /dev/nvme1n1

  #Create a mount point where the EBS Volume will appear
  sudo mkdir -p /mnt/ebs

  #Mount the volume to the mount point (Folder), add the fstan to make the mount permanent (survives reboots)
  sudo mount /dev/nvme1n1 /mnt/ebs
  echo '/dev/nvme1n1 /mnt/ebs ext4 defaults,nofail 0 2' | sudo tee -a /etc/fstab
fi



# Create a folder on the mounted EBS volume for mysql to write to
sudo mkdir -p /mnt/ebs/mysql-data

# mysql runs as a user with UID:999,  grant it ownership to the volume directory so that it can write into it
sudo chown -R 999:999 /mnt/ebs/mysql-data

echo "Provisoning Script completed!"

