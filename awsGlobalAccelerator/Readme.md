AWS Global Accelerator
AWS Global Accelerator can find the optimal path from the end user to your web-servers. Global Accelerator is deployed within Edge Locations, so you send user traffic to an Edge Location instead of directly to your web-application.
There are two accelerator types:

Standard — automatically route to the nearest healthy endpoint
Custom Routing — Route to specific EC2 instances


Components:
Listeners — Listens for traffic on a specific port and sends traffic to an endpoint group.
Endpoint Groups — A collection of endpoints within a specific AWS Region. Traffic dial can be used to change the percentage of traffic.
Endpoints — Represents a resource to send traffic to. An endpoint can be:

Network Load Balancer
Application Load Balancer
EC2 Instances
Elastic IP Addresses


Architecture flow:
Layer           Example         
Listener        TCP port 3000
Endpoint Group  us-east-1 or ca-central-1
Endpoints       ALB, NLB, EC2, Elastic IP


Global Accelerator has a speed comparison tool: https://speedtest.globalaccelerator.aws