# Postgrest on EC2
Creates an EC2 server with Postgrest running, pointing to your database (probably RDS).

To use this, you need to get a Postgrest config file to the instance, so that Postgrest can talk to your RDS instance.





## Option 2 - get it running manually:

1. Start an EC2 instance with a RHEL 7.x image (t2.micro with 10GB of local storage is plenty). 
    Ensure the instance can talk to the database - recommend that it's in the same VPC and availability zone.
    Add SSH permissions to the inbound rules of the [VPC security group](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html)

2. Log in as ec2-user and copy your [postgrest config file](https://postgrest.org/en/v5.2/install.html#configuration) to /home/ec2-user/postgrest_config

3. SSH in and run this:
`curl  -sSL https://raw.githubusercontent.com/dvasdekis/postgrest-ec2/master/rhel7.sh | sudo sh`

4. Remove SSH permissions from the inbound rules of the [VPC security group](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html). You ain't gonna need it.
