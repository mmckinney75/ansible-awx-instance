#!/bin/bash

# Update packages
sudo DEBIAN_FRONTEND=noninteractive apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

echo "*****************************************************"
echo "**  Installing Ansible - Command Line   "
echo "*****************************************************"

# Install Ansible
sudo apt-get install software-properties-common -y
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo DEBIAN_FRONTEND=noninteractive apt-get install ansible -y

echo "*****************************************************"
echo "**  Ansible - Command Line Installation  - COMPLETE  "
echo "*****************************************************"
echo "**  Installing Docker  "
echo "*****************************************************"

# Install Docker, PIP, and Docker SDK
sudo apt install docker.io -y
sudo apt install python-pip -y
pip install docker
pip install docker-compose
echo $SHLVL

echo "*****************************************************"
echo "**  Docker Installation - COMPLETE  "
echo "*****************************************************"
echo "**  Installing NodeJS and NPM  "
echo "*****************************************************"

# Install NodeJS and NPM
sudo apt install nodejs npm -y
sudo npm install npm --global
echo $SHLVL

echo "*****************************************************"
echo "**  NodeJS and NPM Installation - COMPLETE  "
echo "*****************************************************"
echo "**  Installing Ansible AWX  "
echo "*****************************************************"

# Install AWX
git clone https://github.com/ansible/awx.git
cd awx/installer
sudo ansible-playbook -i inventory install.yml
cd
echo $SHLVL

echo "*****************************************************"
echo "**  Ansible AWX installation - COMPLETE "
echo "*****************************************************"
echo "**  Installing and configuring Tower-CLI   "
echo "*****************************************************"

# Install and configure Tower CLI with default login info
sudo -H pip install ansible-tower-cli
tower-cli config host http://`hostname`
tower-cli config username admin
tower-cli config password password
tower-cli config verify_ssl false
tower-cli config

env
export PATH=/home/ubuntu/.local/bin:$PATH:/snap/bin
echo $SHLVL

echo "Sourcing .profile"
sed -i '5,9d' .bashrc
. .profile
env

# Test tower-cli ability to reach AWX
count = 0

until tower-cli version
do
  echo "Count: $count"
  echo "Unable to reach AWX; Retrying"
  ((count++))
  sleep 5
  if [ $count -eq 5 ]; then
    break
  fi
done

# echo "*****************************************************"
# echo "**  Tower-CLI Installation/ Configuration - COMPLETE "
# echo "*****************************************************"
# echo "**  Changing Administrator default password"
# echo "*****************************************************"

# # Change admin account default password
# new_password=`openssl rand -base64 12`
# echo $new_password
# tower-cli user modify --username "admin" --email "root@localhost" --password $new_password
# tower-cli config password $new_password  #Sets tower-cli to use new password
#
# # Test tower-cli ability to reach AWX
# until tower-cli version
# do
# echo "Unable to reach AWX; Retrying"
#   sleep 5
# done
#
# echo "*****************************************************"
# echo "**  Admin Password Update - COMPLETE "
# echo "*****************************************************"
# echo "**  Creating default SSH Credentials "
# echo "*****************************************************"
#
