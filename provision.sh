#!/bin/bash


# Check if docker is installed on system

systemctl is-active --quiet docker && echo docker is running

# if [systemctl status docker == 1];
#   echo "docker is installed"
# fi


# STATUS="$(systemctl is-active tomcat.service)"
# if [ "${STATUS}" = "active" ]; then
#     echo "Execute your tasks ....."
# else 
#     echo " Service not running.... so exiting "  
#     exit 1  
# fi


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
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin -y
sudo apt-get install -y docker-compose-plugin

# Add dcoker user to docker group (so no sudo needed)
usermod -aG docker ubuntu

  # Enable and start Docker
    systemctl enable docker
    systemctl start docker

# Mount the EBS Volume on the EC2 instance

# Format the volume with an ext4 filesystem
sudo mkfs -t ext4 /dev/xvdf

sudo cp -r /mysql-data  /tmp/mysql-data-backup


mount the mysql-data to the ebs volume
sudo mount /dev/xvdf /mnt/mysql-data


#Set correct ownership/permissions on the mount point so Docker can write to it
sudo chmod 777 /dev/xvdf

# Install AWS Cli

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o"awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws configure #Figure out how to automate 




