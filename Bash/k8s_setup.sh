#!/bin/bash 
# UBUNTU INSTALLER

###
# Prepare server environment
###

sudo swapoff -a
sudo sed -ri '/\sswap\s/s/^#?/#/' /etc/fstab

###
# Prepare runtime environment
###

sudo apt-get update && apt-get install \
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

###
# Install Kubernetes
###

#Add Googles Cloud public signing key
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

#Add Kubernetes apt repository
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

#Update apt package index, install kubelet, kubeadm and kubectl, and pin their version:
sudo apt-get update && sudo apt-get install \
    kubelet \
    kubeadm \
    kubectl -y

#Stop Kubernetes packages from being updates or removed
sudo apt-mark hold kubelet kubeadm kubectl

sudo apt update && sudo apt upgrade -y && sudo systemctl reboot