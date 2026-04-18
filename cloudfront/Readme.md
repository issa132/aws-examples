# Introduction to CloudFront
Content Delivery Network (CDN) — A CDN is a distributed network of servers that delivers web pages and content to users based on their geographical location, the origin of the webpage, and a content delivery server.
CloudFront is a CDN that can be used to deliver:

Static content
Dynamic content
Streaming Videos
Web Sockets

How it works: Content is pushed from an Origin to multiple Edge Locations around the world (Canada, India, England, New Zealand, etc.), so users are served from the nearest Edge Location — e.g. a user in Toronto is served from the Canada Edge Location, and a user in Wellington from the New Zealand Edge Location.

Amazon CloudFront can be fronted with AWS WAF for OWASP TOP 10 protection (ASAP)


Key concepts:
Term                    Description
Origin                  The source of your content (S3, ALB, EC2, etc.)
Distribution            The CloudFront configuration that maps origin to edge locationsEdge 
Location                The globally distributed cache servers closest to users
CDN                     Reduces latency by serving cached content from nearby locations


Amazon CloudFront can stream Videos On Demand using ISS Microsoft Smooth Streaming.

CloudFront — Core Components
Origin — The location where all of the original files are located. For example an S3 Bucket, EC2 Instance, ELB, or Route 53.
Edge Location — Compute located strategically close to end users.
Regional Caches — Compute located in broad geographic locations to speed up requests for edge locations.
Distribution — A collection of Edge locations and Regional Cache that defines how cached content should behave.

How they work together:
Component                   Role
Origin                      Source of truth — holds the original content
Distribution                CloudFront config — defines caching rules and behavior
Regional Cache              Mid-tier cache between origin and edge locations
Edge Location               Closest point to the user — serves cached content

Request flow:
User (Toronto) → Edge Location (Canada) → Regional Cache → Origin (if cache miss)

This layered caching approach minimizes trips back to the origin, reducing latency and load on the origin server.


# CloudFront – Lambda@Edge
Lambda@Edge are lambda functions to override the behaviour of requests and responses.
Functions are deployed at Regional Edge Caches.
Supported languages: Python and Node.js

There are 4 functions for Lambda@Edge:

Viewer request — When CloudFront receives a request from a viewer
Origin request — Before CloudFront forwards a request to the origin
Origin response — When CloudFront receives a response from the origin
Viewer response — Before CloudFront returns the response to the viewer


Use Cases:
Viewer Request:

Redirect HTTP to HTTPS
Inspect cookies for user authentication
Modify headers for A/B testing

Origin Request:

Rewrite URLs for SEO or routing
Inject headers for origin authentication
Selective content serving based on user-agent

Viewer Response:

Add security headers (e.g., CSP, HSTS)
Set cookies for client-side tracking
Customize error messages

Origin Response:

Modify headers to control caching
Update URLs in HTML for versioning
Customize error responses from the origin

# CloudFront Functions
CloudFront Functions are lightweight edge functions for high-scale, latency-sensitive CDN customizations. CloudFront Functions are cheaper, faster, but more limited than Lambda@Edge functions.
Functions are deployed at Edge Locations.
Supported languages: JavaScript (ECMAScript 5.1 compliant)
There are 2 functions for CloudFront Functions:

Viewer request — When CloudFront receives a request from a viewer
Viewer response — Before CloudFront returns the response to the viewer

Use cases:

Cache key normalization
Header manipulation
Status code modification and body generation
URL redirects or rewrites
Request authorization


CloudFront Functions vs Lambda@Edge:
Feature                     CloudFront Functions            Lambda@Edge
Speed                       Faster                          Slower
Cost                        Cheaper                         More expensive
Flexibility                 More limited                    More powerful
Deployment                  Edge Locations                  Regional Edge Caches                      
Trigger points              Viewer only (2)                 Viewer + Origin (4)
Languages                   JavaScript only                 Python, Node.js

Rule of thumb: Use CloudFront Functions for simple, lightweight tasks. Use Lambda@Edge for complex logic that needs access to the origin request/response.

# CloudFront – Origin
CloudFront Origin is the source where CloudFront will send requests.
Domain Name: the address to the origin
Origin Path: the path at the specified address


Configurations for Origins:
    S3OriginConfig
        Amazon S3


CustomOriginConfig
    AWS Elemental MediaStore Container
    Application Load Balancer
    Lambda function URL
    HTTP Server (e.g. Amazon EC2 or another custom origin)
    CloudFront Origins Group



json
"Origins": {
  "Quantity": 1,
  "Items": [
    {
      "Id": "awsexamplebucket.s3.amazonaws.com-cli-example",
      "DomainName": "awsexamplebucket.s3.amazonaws.com",
      "OriginPath": "",
      "CustomHeaders": {
        "Quantity": 0
      },
      "S3OriginConfig": {
        "OriginAccessIdentity": ""
      }
    }
  ]
},

You provide this configuration when creating the distribution.


Config Type         Use For 
S3OriginConfig      S3 buckets only
CustomOriginConfig  Everything else — ALB, EC2, Lambda URLs, MediaStore

