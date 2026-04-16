# What is a Load Balancer?
Physical hardware or virtual software that accepts incoming traffic and then distributes the traffic to multiple targets. They can balance the load via different rules. These rules vary based on the types of load balancers.

Elastic Load Balancer (ELB) is a suite of load balancers used to balance/distribute traffic to multiple EC2, ECS, Fargate and EKS instances.

Layer               Name                    Example
7               Application                ✅HTTP
6               Presentation                TLS
5               Session                     NetBIOS          
4               Transport                   TCP/UDP
3               Network                     IP, IPSec
2               Data Link                   Ethernet
1               Physical                    Ethernet

Application Load Balancer (ALB)
ALB is designed to balance HTTP and HTTPS traffic. It operates at Layer 7 of the OSI Model. It has a feature called Request Routing, which allows you to add routing rules to your listeners based on the HTTP protocol. It supports WebSockets and HTTP/2 for real-time, bidirectional communication applications. It can handle authorization and authentication of HTTP requests. It can only be accessed via its hostname. If you need a static IP, forward an NLB to ALB.
AWS Web Application Firewall (WAF) can be placed in front of ALB for OWASP protection. AWS Certificate Manager (ACM) can be attached to listeners to serve custom domains over SSL/TLS for HTTPS. Global Accelerator can be placed in front of ALB to improve global availability. Amazon CloudFront can be placed in front of ALB to improve global caching of common HTTP requests. Amazon Cognito can be used to authenticate users via incoming HTTP requests.
Use Cases:

    Microservices and Containerized Applications
    E-commerce and Retail Websites
    Corporate Websites and Web Applications
    SaaS Applications

# Network Load Balancer (NLB)
NLB is designed to balance TCP/UDP. It operates at Layer 4 of the OSI Model. It can handle millions of requests per second while still maintaining extremely low latency. Global Accelerator can be placed in front of ALB to improve global availability. It preserves the client source IP. It is used when a static IP address is needed for a load balancer.
Use cases:

    High-Performance Computing and Big Data Applications
    Real-Time and Multiplayer Gaming Platforms
    Financial Trading Platforms
    IoT and Smart Device Ecosystems
    Telecommunications Networks

# Classic Load Balancer (CLB)
CLB is AWS's first load balancer (legacy). 
It can balance HTTP, HTTPS, or TCP traffic, but not at the same time. 
It can use Layer 7-specific features of the OSI Model such as sticky sessions. 
It can also use strict Layer 4 (OSI Model) balancing for purely TCP applications.
⚠️ Not recommended for use, instead use NLB or ALB.

