#!/bin/bash

echo 'Initializing minecraft server...'

# Perform a quick update on your instance:
sudo yum update -y

# Install git in your EC2 instance
sudo yum install git -y

# Install python3 on EC2 instance
sudo yum install python3 -y

# Install java 11
sudo yum install java-1.8.0-openjdk -y

# Install tmux
sudo yum install tmux -y

# Create minecraft user with home directory (group defaults to username)
sudo useradd -m minecraft

# Grab CCG repo
git clone https://github.com/jmorgancusick/custom-cloud-gaming.git /home/ec2-user/custom-cloud-gaming

# Place required scripts in home directory of minecraft user
sudo cp /home/ec2-user/custom-cloud-gaming/scripts/update_minecraft_server.py \
     /home/minecraft/update_minecraft_server.py
sudo cp /home/ec2-user/custom-cloud-gaming/scripts/start_minecraft_server.sh \
     /home/minecraft/start_minecraft_server.sh
sudo cp /home/ec2-user/custom-cloud-gaming/scripts/stop_minecraft_server.sh \
     /home/minecraft/stop_minecraft_server.sh

# Place python package in home directory
sudo cp -r /home/ec2-user/custom-cloud-gaming/jmc \
     /home/minecraft/jmc

# Make minecraft_server directory for minecraft user
sudo mkdir /home/minecraft/minecraft_server

# Make minecraft_server_jars directory for minecraft user
sudo mkdir /home/minecraft/minecraft_server_jars

# Make backups directory for minecraft user
sudo mkdir /home/minecraft/backups

# Make downloads directory for minecraft user
sudo mkdir /home/minecraft/downloads

# Pull the latest jar
sudo /home/minecraft/update_minecraft_server.py

# Create a symlink for the minecraft_server
sudo ln -s /home/minecraft/minecraft_server_jars/minecraft_server_latest.jar /home/minecraft/minecraft_server/server.jar

# Agree to eula.txt
echo 'eula=true' | sudo tee /home/minecraft/minecraft_server/eula.txt >/dev/null

# Change owner of all files
sudo chown -R minecraft:minecraft /home/minecraft

# Pull world backup
sudo runuser -l minecraft -c "export PYTHONPATH=/home/minecraft && /home/minecraft/jmc/minecraft/pull_server_backup.py --role-arn ${role_arn} --server-folder /home/minecraft/minecraft_server --s3-bucket ${s3_bucket} --s3-object ${s3_object} | systemd-cat -t minecraft"

# Set up job for uploading world backup and cleanup
sudo sh -c "crontab -u minecraft -l > /home/minecraft/tmp_cron"

sudo sh -c "echo '0 21 * * * export PYTHONPATH=/home/minecraft && /home/minecraft/jmc/minecraft/push_server_backup.py --role-arn ${role_arn} --server-folder /home/minecraft/minecraft_server --s3-bucket ${s3_bucket} --s3-object ${s3_object} 2>&1 | systemd-cat -t minecraft' >> /home/minecraft/tmp_cron"

sudo sh -c "echo '0 18 * * * find /home/minecraft/backups/*.tar.gz -mtime +5 -exec rm -v {} \; 2>&1 | systemd-cat -t minecraft' >> /home/minecraft/tmp_cron"

sudo sh -c "echo '0 18 * * * find /home/minecraft/minecraft_server/*.log -mtime +5 -exec rm -v {} \; 2>&1 | systemd-cat -t minecraft' >> /home/minecraft/tmp_cron"

sudo sh -c "echo '0 18 * * * find /home/minecraft/minecraft_server/logs/*.log.gz -mtime +5 -exec rm -v {} \; 2>&1 | systemd-cat -t minecraft' >> /home/minecraft/tmp_cron"

sudo sh -c "echo '0 18 * * * find /home/minecraft/minecraft_server/crash-reports/crash*.txt -mtime +5 -exec rm -v {} \; 2>&1 | systemd-cat -t minecraft' >> /home/minecraft/tmp_cron"

sudo crontab -u minecraft /home/minecraft/tmp_cron

sudo rm /home/minecraft/tmp_cron

# Set max journalctl size
sudo journalctl --vacuum-size=1G

# Move systemctl file
sudo cp /home/ec2-user/custom-cloud-gaming/resources/minecraft.service \
    /lib/systemd/system/minecraft.service

# Start the server
sudo systemctl daemon-reload
sudo systemctl enable minecraft
sudo systemctl start minecraft
sudo systemctl status minecraft -l

echo 'Done!'
