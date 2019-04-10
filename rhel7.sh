#!/bin/bash -xe
# Redirect the below output to AWS console
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

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

echo "Set Yum to autoupdate at 2am UTC - change this if you arent in UTC!"
cat <<HEREDOC >> /etc/crontab
0 2 * * * root yum -y update
HEREDOC

echo "Update all software that shipped with the OS"
yum -y update

echo "Install dependencies - postgresql-libs is needed by postgrest"
yum -y install postgresql-libs

echo "Install postgrest"
cd /tmp
curl -L --remote-name https://github.com/PostgREST/postgrest/releases/download/v5.2.0/postgrest-v5.2.0-centos7.tar.xz
tar xfJ postgrest-v5.2.0-centos7.tar.xz
cp postgrest /usr/local/bin

echo "Define the postgrest service"
cat <<HEREDOC > /usr/local/bin/postgrest_service.sh
postgrest /usr/local/bin/postgrest.conf
HEREDOC

echo "Make the postgrest service executable"
chmod +x /usr/local/bin/postgrest_service.sh

echo "Install postgrest as a system service"
cat <<HEREDOC > /etc/systemd/system/postgrest.service
[Unit]
Description = Postgrest as an EC2 system service from https://github.com/dvasdekis/postgrest-ec2/
After = cloud-final.service
StartLimitInterval=0

[Service]
ExecStart = /usr/local/bin/postgrest_service.sh
User = ec2-user
Restart=always
RestartSec=1

[Install]
WantedBy = multi-user.target
HEREDOC

echo "Enable the service on boot"
systemctl enable postgrest.service

echo "Reboot the machine - installs kernel updates and starts postgrest service"
reboot
