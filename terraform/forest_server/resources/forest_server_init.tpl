#!/bin/bash

echo 'Initializing forest server...'

# Perform a quick update on your instance:
sudo yum update -y

# Install git in your EC2 instance
sudo yum install git -y

# Install tmux
sudo yum install tmux -y

# Create forest user with home directory (group defaults to username)
sudo useradd -m forest

# Grab CCG repo
git clone https://github.com/jmorgancusick/custom-cloud-gaming.git /home/ec2-user/custom-cloud-gaming

# Place required scripts in home directory of forest user
sudo cp /home/ec2-user/custom-cloud-gaming/scripts/start_forest_server.sh \
     /home/forest/start_forest_server.sh
sudo cp /home/ec2-user/custom-cloud-gaming/scripts/stop_forest_server.sh \
     /home/forest/stop_forest_server.sh

# Make forest_server directory for forest user
sudo mkdir /home/forest/forest_server

# Set up server

# Change owner of all files
sudo chown -R forest:forest /home/forest

# Move systemctl file
sudo cp /home/ec2-user/custom-cloud-gaming/resources/forest.service \
    /lib/systemd/system/forest.service

# Start the server
sudo systemctl daemon-reload
sudo systemctl enable forest
sudo systemctl start forest
sudo systemctl status forest -l

echo 'Done!'
