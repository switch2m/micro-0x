#!/bin/sh
sudo apt -y update
sudo apt -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt -y install ansible
sudo apt -y install python3-argcomplete
