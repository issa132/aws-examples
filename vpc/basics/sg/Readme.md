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

