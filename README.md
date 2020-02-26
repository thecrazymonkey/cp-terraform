Simple terraform hack to pre-create AWS EC2 VMs for all CP components and map them to Route 53.
Added setup for AWS hosted MIT Kerberos server (main cluster attaches to its security group)
Use pushhosts.sh script to provision /etc/hosts across all servers - note this is only needed if you 
want to test Kerberos security as reverse DNS is used to verify the clients in that case.
