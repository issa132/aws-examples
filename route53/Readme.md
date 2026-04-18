Route 53 is a Domain Name Service (DNS) — think GoDaddy or NameCheap but with integrations with AWS Services.
You can:

    Register and manage domains
    Create various record sets on a domain
    Implement complex traffic flows e.g. Blue/green deploy, failovers
    Continuously monitor records via health checks
    Resolve VPC's outside of AWS


A hosted zone is a container for record sets, scoped to route traffic for a specific domain or subdomains.
There are two types of Zones:

Public Hosted Zones — How you want to route traffic inbound from the Internet

aws route53 create-hosted-zone \
  --name example.com \
  --caller-reference "2014-04-01-18:47" \
  --hosted-zone-config Comment="Main Domain"


Private Hosted Zones — How you want to route traffic within an Amazon VPC

aws route53 create-hosted-zone \
  --name vpc.example.com \
  --vpc VPCRegion=ca-central-1,VPCId=vpc-c3be22b9 \
  --caller-reference "2014-04-01-18:47" \
  --hosted-zone-config PrivateZone=true


# Record Sets are a collection of records which determine where to send traffic.

Record Sets are always changed in batch via the API.
# take blog.example.com" domain and point it to this domain: news.example.com
bash
aws route53 change-resource-record-sets \
  --hosted-zone-id YOUR_HOSTED_ZONE_ID \
  --change-batch '{"Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "blog.example.com",
      "Type": "CNAME",
      "TTL": 300,
      "ResourceRecords": [{
        "Value": "news.example.com"
      }]
    }
  }]}'

There are three action types:

CREATE : Creates a resource record set that has the specified values.
DELETE : Deletes an existing resource record set that has the specified values.
UPSERT : If a resource set doesn't exist, Route 53 creates it. If a resource set exists, Route 53 updates it with the values in the request.

AWS has its own special Alias Record which extends DNS functionality. It will route traffic to specific AWS resources.
Alias records are smart where they can detect the change of an IP address and continuously keep that endpoint pointed to the correct resource.
In most cases, you want to be using Alias when routing traffic to AWS resources.
Alias Records are Type A records with the Alias Target configured.

aws route53 change-resource-record-sets \
  --hosted-zone-id "Z3AQBSTGFYJSTF" \
  --change-batch '{"Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "example.com",
      "Type": "A",
      "AliasTarget": {
        "DNSName": "s3-website-us-east-1.amazonaws.com",
        "HostedZoneId": "Z3AQBSTGFYJSTF"
      }
    }
  }]}'

Alias Target can point to:
AWS Service                     Example       
CloudFront                d111111abcdef8.cloudfront.net
Elastic Beanstalk         example.elasticbeanstalk.com
ELB load balancer         example-1.us-east-2.elb.amazonaws.com
S3 website endpoint       s3-website.us-east-2.amazonaws.com
Resource record set       www.example.com
VPC endpoint              example.us-east-2.vpc2.amazonaws.com
API Gateway               d-abcde1234.execute-api.us-west-2.amazonaws.com


# A visual editor lets you create sophisticated routing configurations for your resources using existing routing types.
Supports versioning so you can roll out or roll back updates.

# There are 7 different types of Routing Policies available inside Route 53:
Simple Routing — default routing policy, multiple addresses result in a random selection
Weighted Routing — route traffic based on weighted values to split traffic
Latency-Based Routing — route traffic to region resource with the lowest latency
Failover Routing — route traffic if primary endpoint is unhealthy to the secondary endpoint
Geolocation Routing — route traffic based on the location of your users
Geo-proximity Routing — route traffic based on the location of your resources and, optionally, shift traffic from resources in one location to resources in another
Multi-value Answer Routing — responds to DNS queries with up to eight healthy records selected at random


# Simple Routing Policies are the most basic routing policies in Route 53 — Default Policy.

You have 1 record and provide multiple IP addresses
When multiple values are specified for a record, Route 53 will return all values back to the user in a random order

For example, if you had a record for 'www.exampro.co' with 3 different IP address values, users would be directed randomly to 1 of them when visiting the domain.
bash
aws route53 change-resource-record-sets \
  --hosted-zone-id YOUR_HOSTED_ZONE_ID \
  --change-batch '{"Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "www.exampro.co",
      "Type": "A",
      "TTL": 300,
      "ResourceRecords": [
        { "Value": "34.229.79.211" },
        { "Value": "18.212.245.88" },
        { "Value": "3.208.76.48" }
      ]
    }
  }]}'
Key concept: Simple Routing does no health checking and has no intelligence — it just returns all IPs randomly. For health-aware routing, use Failover or Multi-value Answer routing instead.


# Weighted Routing Policies let you split up traffic based on different 'weights' assigned.
This allows you to send a certain percentage of overall traffic to one server and have any other traffic be directed to a completely different server.
json

{"Changes": [{
  "Action": "UPSERT",
  "ResourceRecordSet": {
    "Name": "example.com",
    "Type": "A",
    "TTL": 300,
    "WeightedRoutingPolicy": {
      "WeightedRecords": [
        {"Value": "34.229.79.211", "Weight": 10},
        {"Value": "18.212.245.88", "Weight": 20},
        {"Value": "3.208.76.48",   "Weight": 30}
      ],
      "FallbackBehavior": "NON_FAILOVER"
    }
  }
}]}

Traffic % = individual weight ÷ total weight (60)

Use case example: If you had an ALB running experimental features, you could test against a small amount of traffic at random to minimize the impact of effect — e.g. 85% to ALB Stable and 15% to ALB Experimental.

# Latency Based Routing allows you to direct traffic based on the lowest network latency possible for your end-user based on region.
Requires a latency resource record to be set for the EC2 or ELB resource that hosts your application in each region.
json

{"Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "example.com",
      "Type": "A",
      "AliasTarget": {
        "DNSName": "dualstack.myalb1.us-east-1.elb.amazonaws.com",
        "EvaluateTargetHealth": false,
        "HostedZoneId": "YOUR_LOAD_BALANCER_1_HOSTED_ZONE_ID"
      },
      "SetIdentifier": "us-east-1",
      "Region": "us-east-1",
      "LatencyRoutingPolicy": { "Region": "us-east-1" }
    }
  },
  {
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "example.com",
      "Type": "A",
      "AliasTarget": {
        "DNSName": "dualstack.myalb2.us-west-1.elb.amazonaws.com",
        "EvaluateTargetHealth": false,
        "HostedZoneId": "YOUR_LOAD_BALANCER_2_HOSTED_ZONE_ID"
      },
      "SetIdentifier": "us-west-1",
      "Region": "us-west-1",
      "LatencyRoutingPolicy": { "Region": "us-west-1" }
    }
  }
]}

Use case example: You have two copies of your web app backed by ALB — one in California (US-WEST-1) and another in Montreal (CA-CENTRAL-1). A request from Toronto will be routed to Montreal since it will have lower latency.
Route 53 automatically picks the lowest latency region for each user.

# Failover Routing Policies allow you to create active/passive setups in situations where you want a primary site in one location and a secondary data recovery site in another.
Route 53 automatically monitors health checks from your primary site to determine the health of end-points. If an end-point is determined to be in a failed state, all traffic is automatically directed to the secondary location.
json

{"Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "example.com",
      "Type": "A",
      "SetIdentifier": "Primary",
      "FailoverRoutingPolicy": {
        "FailoverBehavior": "PRIMARY"
      },
      "TTL": 300,
      "ResourceRecords": [{"Value": "34.229.79.211"}]
    }
  },
  {
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "example.com",
      "Type": "A",
      "SetIdentifier": "Secondary",
      "FailoverRoutingPolicy": {
        "FailoverBehavior": "SECONDARY"
      },
      "TTL": 300,
      "ResourceRecords": [{"Value": "18.212.245.88"}]
    }
  }
]}

Key concept: Route 53 uses health checks to continuously monitor the primary endpoint. The failover is automatic — no manual intervention needed.

# Geolocation Routing Policies allow you to direct traffic based on the geographic location of where the request originated from.
For example, this would let you route all traffic coming from North America to servers located in North American regions, where queries from other regions could be directed to servers hosted in that region (potentially with pricing and language specific to that region).
json
{"Changes": [{
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "example.com",
      "Type": "A",
      "SetIdentifier": "US-East",
      "GeoLocationRoutingPolicy": {
        "CountryCode": "US"
      },
      "TTL": 300,
      "ResourceRecords": [{"Value": "34.229.79.211"}]
    }
  },
  {
    "Action": "UPSERT",
    "ResourceRecordSet": {
      "Name": "example.com",
      "Type": "A",
      "SetIdentifier": "EU-West",
      "GeoLocationRoutingPolicy": {
        "CountryCode": "EU"
      },
      "TTL": 300,
      "ResourceRecords": [{"Value": "3.208.76.48"}]
    }
  }
]}

Key concept: Unlike Latency-Based Routing which picks the fastest region, Geolocation Routing picks based on where the user is, regardless of latency — useful for compliance, localization, and region-specific pricing.

# Multi-Value Answer Policies let you configure Route 53 to return multiple values such as IP addresses for your web servers, in response to DNS queries.
Multiple values can be specified for almost any record. Route 53 automatically performs health checks on resources and only returns values of ones deemed healthy.
Similar to Simple Routing, however, with an added health check for your record set resources.
json
{"Changes": [{
  "Action": "UPSERT",
  "ResourceRecordSet": {
    "Name": "example.com",
    "Type": "A",
    "TTL": 60,
    "MultiValueAnswerRoutingPolicy": {
      "EvaluateTargetHealth": false
    },
    "ResourceRecords": [
      { "Value": "34.229.79.211" },
      { "Value": "18.212.245.88" },
      { "Value": "3.208.76.48" }
    ]
  }
}]}

Key concept: Multi-Value Answer is not a replacement for a load balancer, but it adds a layer of resilience by filtering out unhealthy endpoints before returning DNS results.

# Route 53 – Health Checks
Checks health every 30s by default. Can be reduced to every 10s
A health check can initiate a failover if the status is returned unhealthy
A CloudWatch Alarm can be created to alert you of status unhealthy
A health check can monitor other health checks to create a chain of reactions
Can create up to 50 health checks for AWS endpoints within or linked to the same AWS account


# Route 53 Resolver
Amazon Route 53 Resolver is a DNS server that allows you to resolve DNS queries between your on-premise network and your VPC.
Route 53 Resolver was originally known as the .2 resolver and Amazon DNS Server.

Inbound Resolver endpoints allow DNS queries to your VPC from your on-premises network or another VPC.
Outbound Resolver endpoints allow DNS queries from your VPC to your on-premises network or another VPC.

Resolver Rules can apply to:

Private Hosted Zones
Public Domains
VPC Local Domain Names


# DNSSEC with Route 53
Domain Name System Security Extensions (DNSSEC) are a suite of extension specifications by the Internet Engineering Task Force (IETF) for securing data exchanged in the Domain Name System (DNS) in Internet Protocol (IP) networks.
DNSSEC signing lets DNS resolvers validate that a DNS response came from Amazon Route 53 and has not been tampered with.
You need to create a KSK signing key and enable it.

Step 1 — Create the Key Signing Key (KSK):
bash
aws route53 create-key-signing-key \
  --region us-east-1 \
  --hosted-zone-id $hostedzone_id \
  --key-management-service-arn $cmk_arn \
  --name $ksk_name \
  --status ACTIVE \
  --caller-reference $unique_string

Step 2 — Enable DNSSEC on the hosted zone:
bash
aws route53 enable-hosted-zone-dnssec \
  --hosted-zone-id $hostedzone_id \
  --region us-east-1

Key parameters:
Parameter                         Description
--key-management-service-arn      ARN of the AWS KMS key used to sign DNS records
--status ACTIVE                   Activates the KSK immediately
--caller-reference                Unique string to identify the request
--region us-east-1                DNSSEC requires us-east-1 region specifically


# Zonal Shift

Zonal shift is a capability in Amazon Route 53 Application Recovery Controller (Route 53 ARC).

Shifts a load balancer resource away from an impaired Availability Zone to a healthy AZ with a single action.

Zonal shifts are only supported on Application Load Balancers and Network Load Balancers with cross-zone load balancing turned off.
Zonal shift isn't supported when you use an Application Load Balancer as an accelerator endpoint in AWS Global Accelerator.
You can start a zonal shift for a specific load balancer only for a single Availability Zone. You can't start a zonal shift for multiple Availability Zones.
How it works:

                              Detail
Service	                      Route 53 ARC (Application Recovery Controller)
Supported LBs	                ALB and NLB (cross-zone load balancing must be off)
Action	                      Moves traffic away from impaired AZ to healthy AZ
Scope	                        Only 1 AZ at a time per load balancer
Not supported	                ALB used as AWS Global Accelerator endpoint

Key concept: Zonal Shift is a fast, single-action recovery tool — when an AZ is degraded, you immediately reroute all traffic to healthy AZs without waiting for auto-healing.

3 Route 53 Profiles
Route 53 Profiles lets you apply and manage DNS-related Route 53 configurations across many VPCs and in different AWS accounts.
Resources you can associate with a profile:

Private hosted zones
Route 53 Resolver rules
DNS Firewall rule groups

Step 1 — Create a profile:
bash
aws route53profiles create-profile --name myprofile

Step 2 — Associate a resource to the profile:
bash
aws route53profiles associate-resource-to-profile \
  --name test-resource-association \
  --profile-id rp-4987774726example \
  --resource-arn arn:aws:route53resolver:us-east-1:123456789012:firewall-rule-group/rslvr-frg-cfe7f72example \
  --resource-properties "{\"priority\": 102}"

Step 3 — Associate the profile to a VPC:
bash
aws route53profiles associate-profile \
  --name test-association \
  --profile-id rp-4987774726example \
  --resource-id vpc-0af3b96b3example

Key concept:
Step    Action    
1       Create a profile
2       Add DNS resources to the profile (hosted zones, resolver rules, firewall groups)
3       Associate the profile to one or more VPCs across accounts

Key benefit: Instead of configuring DNS settings per VPC individually, Route 53 Profiles lets you define once and apply consistently across many VPCs and AWS accounts.

