AWS Virtual Private Cloud (VPC) is a logically isolated virtual network.
AWS VPC resembles a traditional network you'd operate in your own datacenter.

# Internet Gateway (IGW)
A gateway that connects your VPC out to the internet
# Virtual Private Gateway (VPN Gateway)
A gateway that connects your VPC to a private external network
# Route Tables
determines where to route traffic within a VPC
# NAT Gateway
Allows private instances (eg. Virtual Machines) to connect to services outside the VPC
# Network Access Control Lists (NACLs)
Acts as a stateless virtual firewall for compute within a VPC
Operates at the subnet level with allow and deny rules
# Security Groups (SG)
Acts as a stateful virtual firewall for compute within a VPC
Operates at the instance level with allow rules. Security Groups are associated with EC2 instances
Each SG contains two different sets of rules:
    Inbound rules (ingress traffic, entering)
    Outbound rules (egress traffic, leaving)
A Security Group (Sg) can contain multiple instances in different subnets.
SGs are not bound by subnets, but are bound by VPC
there is only allow rules. all traficks are blocks by default. 

# Allow IP Addresses
You can specify the source to be an IPv4 or Ipv6 range or a specific IP
A specific IP

# Allow to Another Security Groups
You can specify the source to be another security group

# Nested Security Groups
An instance can belong to multiple Security Groups, and rules are permissive (instead of restrictive). If you have one security group with no Allow and add an Allow to another, it will be Allow.

# Create the security groups
# Add rules to the security group
# Associate EC2 instance to the security group.

 
You can have up to 10,000 Security Groups in a Region (default is 2,500)
You can have 60 inbound rules and 60 outbound rules per security group
16 Security Groups per Elastic Network Interface (ENI) (default is 5)

# Security groups do not filter traffic destined to and from the following:

Amazon Domain Name Services (DNS)
Amazon Dynamic Host Configuration Protocol (DHCP)
Amazon EC2 instance metadata
Amazon ECS task metadata endpoints
License activation for Windows instances
Amazon Time Sync Service
Reserved IP addresses used by the default VPC route

# Public Subnets
Subnets allow instances to have public IP addresses
# Private Subnets
Subnets that disallow instances to have public IP addresses
# VPC Endpoints
Privately connect to AWS support services
# VPC Peering
Connecting VPCs to other VPCs


# VPCs are Region Specific. They do not span regions

    You can use VPC Peering to connect VPCs across-regions


You can create up to 5 VPC per region (adjustable).
Every region comes with a default VPC
You can have 200 subnets per VPC
Upto 5 IPv4 CIDR Blocks per VPC (adjustable to 50)
Upto 5 IPv6 CIDR Blocks per VPC (adjustable to 50)
Most Components Cost nothing:
    VPCs, Route Tables, NACLs, Internet Gateways, Security Groups and Subnets, VPC Peering


Some things cost money: eg. NAT Gateway,
    VPC Endpoints, VPN Gateway, Customer Gateway
    IPV4 Addresses, Elastic IPs

DNS hostnames (should your instance have domain name addresses)

CIDR.xyz

AWS has a default VPC in every region
A default VPC is configure by default with:

* An IPV4 CIDR block at the address 172.31.0.0/16. 65,536 IPv4 addresses
* A subnet (size of /20) for each possible Availability Zone (AZ) 4,096 IPv4 addresses
* An Internet Gateway (IGW)
* A default Security Group (SG)
* Create a default Network access control list (NACL)
* Default DHCP options set
* A Route Table with a route out to the internet via IGW


If you delete the Default VPC (by accident or intentionally) and you want to recreate a default VPC. You can run the follow AWS CLI command:
aws ec2 create-default-vpc --region ca-central-1


To Delete a VPC you need to delete multiple VPC resource before you can delete:

Security groups (SGs) and Network ACLs (NACLs)
Subnets
Route tables (RTs)
Gateway endpoints
Internet gateways (IGWs)
Egress-only internet gateways (EO-IGWs)

aws ec2 delete-security-group --group-id sg-id
aws ec2 delete-network-acl --network-acl-id acl-id
aws ec2 delete-subnet --subnet-id subnet-id
aws ec2 delete-route-table --route-table-id rtb-id
aws ec2 detach-internet-gateway --internet-gateway-id igw-id --vpc-id vpc-id
aws ec2 delete-internet-gateway --internet-gateway-id igw-id
aws ec2 delete-egress-only-internet-gateway --egress-only-internet-gateway-id eigw-id

aws ec2 delete-vpc --vpc-id vpc-id

The default route or catch-all-route represents all possible IP addresses
Think of this route as giving access from anywhere or to the internet without restriction

When we specify 0.0.0.0/0 in our Route Table for IGW, we are allowing internet access
When we specify 0.0.0.0/0 in our Security Group's Inbound Rules, we are allowing all traffic from the internet to access our public resources

AWS Resource Access Manager (RAM) allows you to share resources across your AWS Accounts.
You share VPCs by sharing subnets

# Network Access Controls (NACLs) acts as a ''stateless'' virtual firewall at the subnet level

NACLS have both ALLOW and DENY rules.
A default NACL is created with every VPC

Subnets are associated with NACLs.
A subnet can only belong to a single NACL.

The key difference of NACL's vs Security Groups is that NACLs have both allow and deny rule.
With NACL's you could block a single IP address. You can't do this with SGs




