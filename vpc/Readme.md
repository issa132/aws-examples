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
Operates at the instance level with allow rules
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

