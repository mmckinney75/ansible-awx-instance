#!/bin/bash

# Update packages
sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

# Install Ansible
sudo apt-get install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo DEBIAN_FRONTEND=noninteractive apt-get install ansible -y

# Install Docker, PIP, and Docker SDK
sudo apt install docker.io -y
sudo apt install python-pip -y
pip install docker
pip install docker-compose


# Install NodeJS and NPM
sudo apt install nodejs npm -y
sudo npm install npm --global

# Install AWX
git clone https://github.com/ansible/awx.git
cd awx/installer
sudo ansible-playbook -i inventory install.yml

# Install and configure Tower CLI
sudo -H pip install ansible-tower-cli
tower-cli config host `hostname`
tower-cli config username admin
tower-cli config password password
