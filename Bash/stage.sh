#!/bin/bash 
# UBUNTU INSTALLER | 22.04

echo "Deploying Docker Environment..."

#Set up prerequisites 
sudo apt update && \
  sudo apt install apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

#Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

#Setup Stable Repo
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Install Docker Engine
sudo apt-get update && \
  sudo apt-get install docker-ce \
  docker-ce-cli \
  containerd.io -y

#Docker Post-installation steps for Linux
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 

#Install docker-compose stable (1.29.2)
#sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#sudo chmod +x /usr/local/bin/docker-compose

#Install docker compose v2 (2.2.3)
mkdir -p ~/.docker/cli-plugins/
curl -SL "https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-$(uname -s)-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

echo "Docker environment deployed!"
