#!/bin/bash

# Safely execute this bash script
# e exit on first failure
# x all executed commands are printed to the terminal
# u unset variables are errors
# a export all variables to the environment
# E any trap on ERR is inherited by shell functions
# -o pipefail | produces a failure code if any stage fails
set -Eeuoxa pipefail

#TODO: cloud-init https://stackoverflow.com/questions/42279763/why-does-terraform-apt-get-fail-intermittently
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

# install docker
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -yq
VERSION=$(curl --silent https://api.github.com/repos/docker/compose/releases/latest | grep -Po '"tag_name": "\K.*\d')
DESTINATION=/usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m) -o $DESTINATION
sudo chmod 705 /usr/local/bin/docker-compose
sudo apt install -yq awscli
sudo apt install -yq jq
sudo apt-get install -yq \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --batch --yes -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -yq
sudo apt-get install -yq docker-ce docker-ce-cli containerd.io

if [ $(getent group docker) ]; then
echo "docker group exists"
else
sudo groupadd docker
fi
sudo usermod -a -G docker ubuntu
#sudo su -s ubuntu
#newgrp docker
sudo chmod 666 /var/run/docker.sock
# git clone repo
ssh-keyscan github.com >> ~/.ssh/known_hosts
rm -rf slurm-queen
git clone https://github.com/sudnya/slurm-queen.git
# slurm-queen-up

cd slurm-queen
sudo service docker start
./slurm-queen-up -d
