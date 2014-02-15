katello-ec2-deploy
==================

Helpful deployment scripts for Katello on EC2

Deployment RHEL 6.X
-------------------

You can deploy to an already running RHEL system.  Note you have to specify a Red Hat Portal username and password as well as a 'poolid' to subscribe your system to.

This poolid should grant you access to Red Hat Enterprise Linux and is found via the `subscription-manager list --available` command, similar to:

```
# subscription-manager list --available
+-------------------------------------------+
Available Subscriptions
+-------------------------------------------+
..
Subscription Name: Red Hat Enterprise Linux Server, Self-support (8 sockets) (Up to 1 guest)
SKU:               RH00000
Pool ID:           <YOUR POOLID HERE>
Quantity:          75
Service Level:     SELF-SUPPORT
Service Type:      L1-L3
Multi-Entitlement: No
Ends:              03/05/2014
System Type:       Physical
```

Also you will need a key and URL to access the EC2 instance because the script will use ssh to access the instance. After having in hand all information, execute the commands below in your local machine to deploy to an EC2 instance:

```shell
git clone https://github.com/elyezer/katello-ec2-deploy.git
cd katello-deploy
./bootstrap.sh <RH Portal Username> <RH Portal Password> <poolid> <keypath> <instanceurl>
```
