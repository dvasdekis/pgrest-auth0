# pgrest-auth0
Creates a server with a Postgrest 

To use this, you need to get a Postgrest config file to the instance, so that Postgrest can talk to your RDS instance.





## Instructions to get it running manually:

1. Put your instance config somwhere publically-accessible, but secret ()

2. Start with a RHEL 7.x image

3. SSH in and run the below
`curl  -sSL https://raw.githubusercontent.com/dvasdekis/pgrest-auth0/master/rhel7.sh | sudo sh`