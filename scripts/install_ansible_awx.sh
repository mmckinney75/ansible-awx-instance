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

# Install and configure Tower CLI with default login info
sudo -H pip install ansible-tower-cli
tower-cli config host http://`hostname`
tower-cli config username admin
tower-cli config password password
tower-cli config verify_ssl false

# Change admin account default password
new_password=`openssl rand -base64 12`
echo $new_password
tower-cli user modify --username "admin" --email "root@localhost" --password $new_password
tower-cli config password $new_password  #Sets tower-cli to use new password


# Create default SSH credential

ssh_machine_cred_inputs="username: ubuntu
ssh_key_data: |
${data.template_file.awx_id_rsa.rendered}"

tower-cli credential create --name="SSH - Ubuntu AWX" --organization="Default" --credential-type="Machine" --inputs="$ssh_machine_cred_inputs"
