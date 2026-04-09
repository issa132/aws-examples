Stateless Firewalls like AWS NACLs are not aware of the state of the request.
In both directions they'll treat you like a stranger and stop you both ways and do a rule check

Stateful Firewalls like AWS Security Groups are aware of the state of the requests
For SGs they allow all outbound requests, responses for requests that originated outbound are allowed back through

# Route tables (RT) are used to determine where network traffic is directed
A route table contain a set of routes
Each subnet in your VPC must be implicitly or explicitly associated with a route table.
A subnet can only be associated with one route table at a time, but you can associate multiple subnets with the same route table.

# Main Route Table
A default route table created alongside every VPC which cannot be deleted. A subnet that is not explicitly associated with a route table will use the Main Route Table.

# Custom Route Table
A route table that you can create for your VPC. Eg. A custom route table could be used if you needed specific subnets to only route out to a VPN and not the IGW.


ipv6 are public so dont need Network access translation NAT

# Route table: 
# Target:

Local – The default local route that lets associate subnets within the VPC route to the other route.
Internet Gateway (IGW) – ingress and egress connections to the internet for IPv4 and IPv6
Virtual Private Gateway (VPG) — out to a private connection to an on-premise network
NAT Gateway – egress connections for private instances out to the internet for IPv4
Egress Only Internet Gateway — egress connections for private instances out to the internet for IPv6
Instance — out to a specific EC2 instance
Network Interface (ENI) — out to a specific Elastic Network Interface
Carrier Gateway – out to AWS partnered telecom carrier networks via AWS Wavelength
Core Network – out to managed wide-area networking (WAN) via AWS Cloud WAN
Gateway Load Balancer Endpoint — out to a Gateway Load Balancer (GWLB); GWLB is for third-party virtual appliances
Outposts Local Gateway — out to an Outpost, a physical server rack with AWS services in your own datacenter
Peering Connection — out to another Virtual Private Cloud (VPC)
Transit Gateway (TGW) — out to a transit hub for connecting multiple VPCs and on-premises network

# Gateway 
What is a Gateway?
A gateway (in the context of cloud services) is a networking service which sits between two different networks. Gateways often act as reverse proxies, firewall and load balancers.
# we have 
Internet Gateway: Inbound and Outbound public traffic for IPv4 and IPV6. allows both inbound and outbound internet traffic to your VPC. Default VPCs come with an IGW, for Non Default VPCs you must manually create your IGW and associate it.

Egress-Only Internet Gateway: Outbound private traffic for IpV6 blocking public access. Egress-Only Internet Gateways (EO-IGW) are specifically for IPv6 when you want to allow outbound traffic to the internet but prevent inbound traffic from the internet. 

NAT Gateway: Outbound private traffic for IpV4
Virtual Private Gateway: The endpoint into your AWS account for a VPN connection
Customer Gateway: The endpoint into your on-premise account for a VPN connection
Gateway Load Balancer (GWLB): Layer 3 (Network layer) load balancer to run and scale third-party virtual applications eg. Firewalls, IDS/IPS
Direct Connect Gateway: The endpoint connection to a fiber optic connection at co-location data center
AWS Backup Gateway: The endpoint connection for AWS managed backups
IoT Device Gateway: The endpoint connection to send IoT data in both directions
AWS Transit Gateway: Hub and spoke model to simplify VPC peering
Amazon API Gateway: Abstracts API endpoints to services
AWS Storage Gateway: Syncing, caching or extending local storage to cloud storage


# --------------
IPv6 Egress Only Internet Gateway Lab with Session Manager
Create a new VPC
1.1 Create a new VPC using the AWS CLI with the Amazon provided ipv6 block option enabled
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --amazon-provided-ipv6-cidr-block
{
    "Vpc": {
        "CidrBlock": "10.0.0.0/16",
        "DhcpOptionsId": "dopt-5d501035",
        "State": "pending",
        "VpcId": "vpc-0d78b5507bb574697",
        "OwnerId": "982383527471",
        "InstanceTenancy": "default",
        "Ipv6CidrBlockAssociationSet": [
            {
                "AssociationId": "vpc-cidr-assoc-0e0abdb31772842ce",
                "Ipv6CidrBlock": "",
                "Ipv6CidrBlockState": {
                    "State": "associating"
                },
                "NetworkBorderGroup": "ca-central-1",
                "Ipv6Pool": "Amazon"
                ...

1.2 Wait a moment for the allocation then check the assigned CIDR block for the VPC
# create the subnet: 
aws ec2 create-subnet --vpc-id <VPC ID> --ipv6-cidr-block <VPC IPv6 CIDR Block>/64 --cidr-block 10.0.2.0/24
aws ec2 modify-subnet-attribute --subnet-id subnet-0d58b032267081a74 --enable-dns64
aws ec2 create-egress-only-internet-gateway --vpc-id vpc-00c108911b6b6e2dd
aws ec2 attach-internet-gateway --internet-gateway-id igw-0b0c1187fb818077c --vpc-id vpc-00c108911b6b6e2dd
# allocate adress
aws ec2 allocate-address
# create NAT gateway 
aws ec2 create-nat-gateway --subnet-id <SUBNET ID> --allocation-id <ELASTIC IP ALLOCATION ID>
aws ec2 create-nat-gateway --subnet-id subnet-0d58b032267081a74 --allocation-id eipalloc-08d982cd2b6f21b59
# create a route table
aws ec2 create-route-table --vpc-id vpc-00c108911b6b6e2dd
aws ec2 create-route --route-table-id <ROUTE TABLE ID> --destination-ipv6-cidr-block ::/0 --egress-only-internet-gateway-id <EGRESS GATEWAY ID>
aws ec2 create-route --route-table-id rtb-0d1cd79567fd780cb --destination-ipv6-cidr-block ::/0 --egress-only-internet-gateway-id eigw-028dcac1bbcd15151
Destination             Target
::/0                    eigw-028dcac1bbcd15151
64:ff9b::/96            nat-0f937f44d77c2cade
2600:1f11:54f:c300::/56 local
0.0.0.0/0               igw-0b0c1187fb818077c
10.0.0.0/16             local

7.5 Add the role to the instance profile
aws iam add-role-to-instance-profile --instance-profile-name EC2SessionManagerProfile --role-name EC2SessionManagerRole

Launch an instance into your subnet with an IPv6 address
8.1 Launch an Amazon Linux 2023 instance into the subnet
aws ec2 run-instances --image-id ami-0156b61643fdfee5c \
  --instance-type t3.micro \
  --count 1 \
  --iam-instance-profile Name=EC2SessionManagerProfile \
  --network-interfaces DeviceIndex=0,Ipv6AddressCount=1,SubnetId=<SUBNET ID>


Elastic IP (EIP) address in AWS is a static IPv4 address
A Static IP is an address that always stays the same.

Use Case 1
When you restart a EC2 instance its IP address will change.
This dynamic nature could break external connections relying on the IP address.

Use Case 2
When an EC2 instance fails you might want to use the same IP address on a fail-over instance. An Elastic IP allows you to remap that static IP address.

* Elastic IPs are region specific
* Elastic IPs are drawn from Amazon's pool of IPv4 addresses
* Elastic IPs are charge $1 for each that is allocated and are unassociated
* Elastic IPs also include the public IPV4 address charge
* Elastic IPs can be associated or unassociated
     - To an instance eg. EC2
     - To a primary network card eg. ENI

In IPv6, VPC addressing is already globally unique, and therefore Elastic IP addresses are not required.

Allocate an EIP

aws ec2 allocate-address --domain vpc
{
    "PublicIp": "54.228.5.3",
    "AllocationId": "eipalloc-0a33f63bceded1dff4",
    "PublicIpv4Pool": "amazon",
    "NetworkBorderGroup": "eu-west-1",
    "Domain": "vpc"
}

With --network-border-group you can pick very specific Availability Zones, Local Zones or Wavelength Zones.

Associate an EIP

aws ec2 associate-address \
--instance-id i-1234567890abcdef0 \
--allocation-id eipalloc-0a33f63bceded1dff4

We then need to associate the Elastic IP to an instance. You could also use --network-interface-id to associate to a network interface.

Disassociate an EIP
aws ec2 disassociate-address \
--association-id eipalloc-0a33f63bceded1dff4

Deallocate (release) an EIP
aws ec2 release-address \
--allocation-id eipalloc-0a33f63bceded1dff4


Reassociation
aws ec2 associate-address \
--instance-id i-1234567890abcdef0 \
--allocation-id eipalloc-0a33f63bceded1dff4 \
--allow-reassociation

With --allow-reassociation you can tell an address to always attempt to reassociate with the same instance or network interface in the case of failure or restart. You can also tell it to explicitly not to with --no-allow-reassociation


Recover
aws ec2 allocate-address \
--domain vpc \
--address "54.228.5.3"

You can attempt to (if available) recover or specify address during allocation.


Custom
aws ec2 allocate-address \
--domain vpc \
--public-ipv4-pool ipv4pool-ec2-1234567890abcdef0

Bring-your-own (BYO) IPV4 address pool, and allocate one from that pool


# IPv6
IPv6 was developed to provide a solution for the eventual exhaustion of all IPv4 addresses.
AWS services provides support for IPv6 but its configuration and access will vary per service

2001:0db8:85a3:0000:0000:8a2e:0370:7334

A service will be configured for either:
    IPv6 Only

    OR

    Dual Stack (IPv4 and IPv6)

A service endpoint is the way to access IPv6:
    Public Endpoint Support

    AND / OR

    Private Endpoint Support

IPv4 only VPCs can be migrated to operate in Dual Stack mode (Ipv4 and IPv6)
Steps to Migrate a IPv4 Only VPC to dualstack

* Add new IPv6 CIDR block to VPC
* Create or Associate IPv6 Subnets
    IPv4 Subnets can't be migrated
* Update Route Table for IPv6 to IGW
* Upgrade SG rules to include IPv6 address ranges
* Migrate EC2 instance type if it does not support IPV6

You cannot disable IPv4 support for your VPC and subnets; this is the default IP addressing system for Amazon VPC and Amazon EC2.

# AWS Direct Connect is the AWS solution for establishing dedicated network connections from on-premises locations to AWS. Helps reduce network costs and increase bandwidth throughput. (great for high-traffic networks)
Provides a more consistent network experience than a typical internet-based connection. (reliable and secure)

Connection Requirements:

 Your network is co-located with an existing AWS Direct Connect location
 You are working with an AWS Direct Connect partner who is a member of the AWS Partner Network (APN).
 You are working with an independent service provider to connect to AWS Direct Connect

A co-location (aka carrier-hotel) is a data center where equipment, space, and bandwidth are available for rental to retail customers

# VPC Endpoints allow you to privately connect your VPC to other AWS and other services

Think of a secret tunnel where you don't have to leave the AWS network
VPC Endpoints provide the following benefits

Eliminates the need for:
    Internet Gateway (IGW)
    NAT device
    VPN connection
    AWS Direct Connect

Instances in the VPC do not require a public IPv4 address
Traffic between your VPC and other services does not leave the AWS network.
Horizontally scaled, redundant, and highly available VPC component.
Allows secure communication between instances and services without adding availability risks or bandwidth constraints on your traffic.

There are 3 Types of VPC Endpoints

Interface Endpoints
Gateway Endpoints
Gateway Load Balancer Endpoints

# AWS PrivateLink is a broader service that allows you to securely connect your VPC to:

    Supported AWS Services
    AWS services hosted in other AWS Accounts
    supported AWS Marketplace partner services
without the need of an IGW, NAT, VPN, or AWS Direct Connect connection

# Interface Endpoints are Elastic Network Interfaces (ENI) with a private IP address. They serve as an entry point for traffic going to a supported service.
Access services hosted on AWS easily and securely by keeping your network traffic within the AWS network.
The Elastic Network Interface (ENI) is an entry point for traffic destined to the service.

# Gateway Load Balancer (GWLB) Endpoints powered via PrivateLink allows you to distribute traffic to a fleet of network virtual appliances.
Deploy, scale and manage: Firewalls, Intrusion Detection and Prevention Systems (IDS/IPS), and Deep Packet Inspection Systems.

You can send traffic to GWLB by making simple configuration updates in your VPCs' route tables.

# A Gateway Endpoint provides reliable connectivity to Amazon S3 and DynamoDB without requiring an internet gateway or a NAT device for your VPC.
Gateway endpoints do not use AWS PrivateLink. Gateway endpoints have no additional charge. Gateway endpoints support the following services: Amazon DynamoDB and Amazon S3.

To create a Gateway Endpoint, you must specify the VPC in which you want to create the endpoint and the service to which you want to establish the connection.


# VPC Flow Logs allow you to capture IP traffic information through your VPC.
aws ec2 create-flow-logs \
    --resource-type VPC \
    --resource-ids vpc-xxxxxxxx \
    --traffic-type ALL \
    --log-destination-type cloud-watch-logs \
    --log-destination arn:aws:logs:region:account-id:log-group:log-group-name \
    --deliver-logs-permission-arn arn:aws:iam::account-id:role/role-name
Flow Logs can be scoped for the following: VPC and Subnets, Elastic Network Interface (ENIs), Transit Gateway, and Transit Gateway Attachment.
You can monitor traffic for: ACCEPT (traffic was accepted), REJECT (traffic that was rejected), and ALL (all accepted and rejected traffic).
Logs can be delivered to either: Amazon S3 bucket, CloudWatch Logs, or Kinesis Data Firehose.


# AWS VPN lets you establish a secure and private tunnel from your network or device to the AWS global network.
AWS Site-to-Site VPN securely connects an on-premises network or branch office site to a VPC.
AWS Client VPN securely connects users to AWS or on-premises networks.

# Internet Protocol Security (IPsec) is a secure network protocol suite that authenticates and encrypts the packets of data to provide secure encrypted communication between two computers over an Internet Protocol network. It is used in virtual private networks (VPNs).

# AWS Site-to-Site has the following components:
VPN Connection — secure connection between VPC and on-premises equipment. VPN tunnel — encrypted connection for your data. Customer gateway (CGW) — provides information to AWS about your customer gateway device. Customer gateway device — a physical device or software application on your side of the Site-to-Site VPN connection. Target gateway — a generic term for the VPN endpoint on the Amazon side of the Site-to-Site VPN connection. Virtual private gateway (VGW) — VPN endpoint on the Amazon side of your Site-to-Site VPN connection that can be attached to a single VPC. Transit gateway — a transit hub that can be used to interconnect multiple VPCs and on-premises networks, and as a VPN endpoint for the Amazon side of the Site-to-Site VPN connection.

# You can optionally enable acceleration for your Site-to-Site VPN connection via AWS Global Accelerator. 
You can attach your Site-to-Site VPN to AWS Cloud WAN. 
You can attach your Site-to-Site VPN to AWS Transit Gateway.

Limitations: IPv6 traffic is not supported for VPN connections on a virtual private gateway.
An AWS VPN connection does not support Path MTU Discovery. 
It is recommended that you use non-overlapping CIDR blocks for your networks.

# Virtual Private Gateway (VGW)
VPN endpoint on the Amazon side of your Site-to-Site VPN connection that can be attached to a single VPC.
When you create a VGW you need to assign an Amazon Autonomous System Number (ASN) or custom ASN.
What is an ASN? An Autonomous System Number (ASN):  is a unique identifier that is globally allocated to each autonomous system (AS) that participates in the Internet.

# Customer Gateway (CGW)
A Customer Gateway is a resource that you create in AWS that represents the customer gateway device in your on-premises network.
When you configure your CGW you'll set: 
    BPG ASN for your customer gateway device, 
    IP address of customer gateway external device, and 
    Private certificate provisioned by AWS Certificate Manager (ACM).
You will also need to provide additional configuration to your customer gateway device which will establish the connection between AWS and your on-premise network.

# A transit gateway is a transit hub that you can use to interconnect your VPCs and your on-premises networks.

# AWS Client VPN is a fully managed client-based VPN service that enables you to securely access AWS resources and resources in your on-premises network.”
Amazon Web Services Client VPN lets users connect securely (over the internet) to both:
    AWS-hosted resources (like EC2 instances, databases, etc.)
    Your own internal (on-premises) network


# A Transit Gateway VPN can support both IPv4 and IPv6 traffic inside the tunnels — not just one or the other. AWS Transit Gateway supports dual-stack configurations, allowing IPv4 and IPv6 traffic simultaneously within the same VPN tunnels.

# You could use AWS Client VPN to securely connect to an RDS Instance that is only in a private subnet"

# What is Network Address Translation (NAT)?
A method of mapping an IP address space into another by modifying network address information in the IP header of packets while they are in transit across a traffic-routing device
If you have a private network and you need to help gain outbound access to the internet, you would need to use a NAT gateway to re-map the Private IPs
If you have two networks that have conflicting network addresses, you can use a NAT to make the addresses more agreeable

# NAT Gateway is a fully managed NAT service to allow instances in your private subnet to establish outbound connections

A NAT Gateway is redundant within a single subnet
You need a NAT Gateway per subnet
You pay:
Per hour per NAT Gateway eg. $0.045
Per GB data processed $0.045
Eg. 1 Month and 3 NATs = $98.55


# NAT Gateway has two connection modes:
Public (Default)

Instances in private subnets can connect to the internet through a public NAT gateway
Cannot receive unsolicited inbound connections from the internet
You must associate an Elastic IP (EIP) address

Private

Instances in private subnets can connect to other VPCs or your on-premises network through a private NAT gateway
You can route traffic from the NAT gateway through a transit gateway or a virtual private gateway
You cannot associate an elastic IP address with a private NAT gateway

# NAT Instances (legacy) is an AWS managed IAM to launch a NAT onto an individual EC2 instances. NAT Instances required the customer to handle scaling

# Jumpboxes are security hardened virtual machines that provide secure access to private subnets.

EC2 instances that are security hardened
Access private subnet resources via SSH or RCP
Known as jumboxes because you are jumping from one box to access another.
Known as bastions since it's something that gives protection against attack

NATs cannot/should not be used as Bastions
NAT Gateways/Instances are only intended for EC2 instances to gain outbound access to the internet for things such as security updates.

# Amazon VPC Lattice is a fully managed application networking service that you use to connect, secure, and monitor the services for your application.
Easily turn your AWS resources into services for a micro-services architecture.

# A transit gateway is a network transit hub that you can use to interconnect your virtual private clouds (VPCs) and on-premises networks.

# Traffic Mirroring sends a copy network traffic from a source ENI to target ENI, or UDP-enabled NLB or GWLB

# AWS Network Firewall is a stateful, managed, network firewall and IDS/IPS for VPCs

# VPC Peering allows you to connect one VPC with another over a direct network route using private IP addresses.
VPC peering connection is not a gateway
VPC peering connection not a VPN connection
VPC peering connection does not rely on a separate piece of physical hardware
There is no single point of failure for communication or a bandwidth bottleneck.

# Create the peering connection
Provide the two VPCs and it will return back a peering connection ID

aws ec2 create-vpc-peering-connection \
--vpc-id requester-vpc-id \
--peer-vpc-id accepter-vpc-id


Accept the peering connection
aws ec2 accept-vpc-peering-connection \
--vpc-peering-connection-id pcx-XXXXXXX

Enable the routing of traffic between the two VPCs. Update your route tables so traffic can flow between the VPCs. You'll need to create a route in each of the VPCs
aws ec2 create-route \
--route-table-id rtb-requester \
--destination-cidr-block accepter-vpc-cidr \
--vpc-peering-connection-id pcx-XXXXXXX

aws ec2 create-route \
--route-table-id rtb-accepter \
--destination-cidr-block requester-vpc-cidr \
--vpc-peering-connection-id pcx-XXXXXXX

You can update the inbound or outbound rules for your VPC security groups to reference security groups in the peered VPC.
aws ec2 describe-security-group-references \
--group-id sg-bbbb2222

Vpc Peering 
