# Postgrest on EC2
Creates an EC2 server with Postgrest running, pointing to your database (probably RDS).

### What does the shell script (rhel7.sh) do?
It sets the instance to autoupdate, and installs postgrest as a system service, pointing to your database.


## Install Option 1 - paste rhel7 as user-data (easier, less secure):

1. Copy [the rhel7.sh file](https://raw.githubusercontent.com/dvasdekis/postgrest-ec2/master/rhel7.sh) into the user-data field on a new RHEL7 EC2 instance

2. Update the first few lines of the pasted user-data in the AWS console to [your intended postgrest.conf file](https://postgrest.org/en/v5.2/install.html#configuration), and uncomment them

3. Remove SSH permissions from the inbound rules of the [VPC security group](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html). You ain't gonna need it.

## Install Option 2 - get it running manually (harder, more secure):

1. Start an EC2 instance with a RHEL 7.x image (t2.micro with 10GB of local storage is plenty). 
    Ensure the instance can talk to the database - recommend that it's in the same VPC and availability zone.
    Add SSH permissions to the inbound rules of the [VPC security group](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)

2. Log in as ec2-user and copy your [postgrest config file](https://postgrest.org/en/v5.2/install.html#configuration) to /usr/local/bin/postgrest.conf

3. SSH in and run this:
`curl  -sSL https://raw.githubusercontent.com/dvasdekis/postgrest-ec2/master/rhel7.sh | sudo sh`

4. Remove SSH permissions from the inbound rules of the [VPC security group](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html). You ain't gonna need it.

