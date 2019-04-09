#!/bin/bash

#################### OPTIONAL - Uncomment below if used ########################
# echo "You can use this space to define your Postgrest config"
# echo "But you should make sure this file is stored somewhere secure!"
# echo "The below may be printing your DB password in plain text"
#
#
# cat <<HEREDOC > /usr/local/bin/postgrest.conf
# db-uri       = "postgres://user:pass@host:5432/dbname"
# db-schema    = "api"
# db-anon-role = "anon"
# HEREDOC
#
#
###################### OPTIONAL - Uncomment above if used ########################

# Update all software that shipped with the OS
yum -y update

# Set Yum to autoupdate at 2am
cat <<HEREDOC > /etc/crontab.d/update-yum.crontab
SHELL=/bin/bash 
PATH=/sbin:/bin:/usr/sbin:/usr/bin 
MAILTO=root
HOME=/
0 2 * * *  yum -y update
HEREDOC

# Install dependencies - postgresql-libs is needed by postgrest
yum -y install postgresql-libs

# Install postgrest
cd /tmp
curl -L --remote-name https://github.com/PostgREST/postgrest/releases/download/v5.2.0/postgrest-v5.2.0-centos7.tar.xz
tar xfJ postgrest-v5.2.0-centos7.tar.xz
cp postgrest /usr/local/bin

# Define the postgrest service
cat <<HEREDOC > /usr/local/bin/postgrest_service.sh
postgrest /usr/local/bin/postgrest.conf
HEREDOC

# Make the postgrest service executable
chmod +x /usr/local/bin/postgrest_service.sh

# Install postgrest as a system service
cat <<HEREDOC > /etc/systemd/system/postgrest.service
[Unit]
Description = Postgrest as an EC2 system service from https://github.com/dvasdekis/postgrest-ec2/
After = cloud-final.service

[Service]
ExecStart = /usr/local/bin/postgrest_service.sh
User = ec2-user

[Install]
WantedBy = multi-user.target
HEREDOC

# Enable the service on boot
systemctl enable postgrest

# Reboot the machine - installs kernel updates and starts postgrest service
reboot
