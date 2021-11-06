#!/bin/bash 
# UBUNTU INSTALLER

sudo apt-get update && sudo apt-get upgrade -y

#Set up the repository
sudo apt-get install \
    apt-transport-https \
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
sudo apt-get update && sudo apt-get install \
  docker-ce \
  docker-ce-cli \
  containerd.io -y

#Docker Post-installation steps for Linux
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker 

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo dpkg -i minikube_latest_amd64.deb

minikube start --vm-driver=docker
minikube kubectl -- get pods -A
alias kubectl="minikube kubectl --"