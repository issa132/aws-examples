# On-Demand
On-Demand is a Pay-As-You-Go (PAYG) model, where you consume compute and then you pay.
When you launch an EC2 instance it is by default using On-Demand Pricing.
On-demand has no up-front payment and no long-term commitment.
You are charged by the second (minimum of 60 seconds) or the hour:
Per-second for:
    Linux, Windows, Windows with SQL Enterprise, Windows with SQL Standard, and Windows with SQL Web Instances that do not have a separate hourly charge

Per-hour:
    Full hour for all other instance types

When looking up pricing it will always show EC2 pricing is the hourly rate.
On-Demand is for applications where the workload is short-term, spikey or unpredictable. When you have a new app for development or you want to run an experiment.

# Reserved Instances (RI)
Designed for applications that have a steady-state, predictable usage, or require reserved capacity. Reduced Pricing is based on Term x Class Offering x RI Attributes x Payment Option.

Term — The longer the term the greater savings.
    You commit to a 1 Year or 3 Year contract. Reserved Instances do not renew automatically.
    When they expire your instance will use On-Demand with no interruption to service.

Class — The less flexible the greater the savings.
    Standard — Up to 75% reduced pricing compared to on-demand. You can modify RI Attributes.
    Convertible — Up to 54% reduced pricing compared to on-demand. You can exchange RI based on RI Attributes if greater or equal in value.
    Scheduled — AWS no longer offers Scheduled RI.

Payment Options — The greater upfront the greater the savings.
    All Upfront — Full payment is made at the start of the term.
    Partial Upfront — A portion of the cost must be paid upfront and the remaining hours in the term are billed at a discounted hourly rate.
    No Upfront — You are billed a discounted hourly rate for every hour within the term, regardless of whether the Reserved Instance is being used.

RIs can be shared between multiple accounts within an AWS Organization. Unused RIs can be sold in the Reserved Instance Marketplace.

# RI Limits
There is a limit to the number of Reserved Instances that you can purchase per month.
Per month you can purchase:
    20 Regional Reserved Instances per Region
    20 Zonal Reserved Instances per AZ

Regional Limits
You cannot exceed your running On-Demand Instance limit by purchasing regional Reserved Instances. The default On-Demand Instance limit is 20.
Before purchasing RI ensure your On-Demand limit is equal to or greater than your RI you intend to purchase.

# Capacity Reservations
EC2 instances are backed by different kinds of hardware, and so there is a finite amount of servers available within an Availability Zone per instance type or family.

You go to launch a specific type of EC2 instance but AWS has ran out of that server!

Capacity Reservation is a service of EC2 that allows you to request a reserve of EC2 instance type for a specific Region and AZ.

The reserved capacity is charged at the selected instance type's On-Demand rate whether an instance is running in it or not.The reserved capacity is charged at the selected instance type's On-Demand rate whether an instance is running in it or not.
You can also use your regional reserved instances with your Capacity Reservations to benefit from billing discounts.

# RI Marketplace
EC2 Reserved Instance Marketplace allows you to sell your unused Standard RI to recoup your RI spend for RI you do not intend or cannot use.
    Reserved Instances can be sold after they have been active for at least 30 days and once AWS has received the upfront payment (if applicable).
    You must have a US bank account to sell Reserved Instances on the Reserved Instance Marketplace.
    There must be at least one month remaining in the term of the Reserved Instance you are listing.
    You will retain the pricing and capacity benefit of your reservation until it's sold and the transaction is complete.
    Your company name (and address upon request) will be shared with the buyer for tax purposes.
    A seller can set only the upfront price for a Reserved Instance. The usage price and other configuration (e.g., instance type, Availability Zone, platform) will remain the same as when the Reserved Instance was initially purchased.
    The term length will be rounded down to the nearest month. For example, a reservation with 9 months and 15 days remaining will appear as 9 months on the Reserved Instance Marketplace.
    You can sell up to $20,000 in Reserved Instances per year. If you need to sell more Reserved Instances.
    Reserved Instances in the GovCloud region cannot be sold on the Reserved Instance Marketplace.

# Spot Instances
AWS has unused compute capacity that they want to maximize the utility of their idle servers.

It's like when a hotel offers booking discounts to fill vacant suites or planes offer discount to fill vacant seats.

Spot Instances provide a discount of 90% compared to On-Demand Pricing. Spot Instances can be terminated if the computing capacity is needed by other On-Demand customers.
Designed for applications that have flexible start and end times or applications that are only feasible at very low compute costs.
    Load balancing workloads — Launch instances of the same size, in any Availability Zone. Good for running web services.
    Flexible workloads — Launch instances of any size, in any Availability Zone. Good for running batch and CI/CD jobs.
    Big data workloads — Launch instances of any size, in a single Availability Zone. Good for MapReduce jobs.

AWS Batch is an easy and convenient way to use Spot Pricing.
Termination Conditions
    Instances can be terminated by AWS at anytime.
    If your instance is terminated by AWS, you don't get charged for a partial hour of usage.
    If you terminate an instance you will still be charged for any hour that it ran.

# Dedicated Instances
Dedicated Instances is designed to meet regulatory requirements. When you have strict server-bound licensing that won't support multi-tenancy or cloud deployments you use Dedicated Hosts.
Multi-Tenant — think of everyone living in an apartment
    When multiple customers are running workloads on the same hardware. Virtual Isolation is what separates customers.

Single-Tenant — think of everyone having their own house
    When a single customer has dedicated hardware. Physical Isolation is what separates customers.

Dedicated can be offered for:
    On-demand
    Reserved (up to 60% savings)
    Spot (up to 90% savings)

You choose tenancy when you launch your EC2 (Notice there is a Dedicated Host):
    Shared — Run a shared hardware instance
    Dedicated — Run a Dedicated instance
    Dedicated host — Launch this instance on a Dedicated host

Enterprises and Large Organizations may have security concerns or obligations against sharing the same hardware with other AWS Customers.

# AWS Savings Plan
Savings Plans offer you the similar discounts as Reserved Instances (RI) but simplifies the purchasing process.
There are 3 types of Savings Plans:
    Compute Savings Plans — Applies to EC2 instance usage, AWS Fargate, and AWS Lambda service usage, regardless of region, instance family, size, tenancy, and operating system.
    EC2 Instance Savings Plans — Applies to instance usage within the committed EC2 family and region, regardless of size, tenancy, and operating system.
    SageMaker Savings Plan — Applies to SageMaker service usage, regardless of region, instance family, and component.

You can choose two different terms:
    1 Year
    3 Year

You choose the following Payment Options:
    All Upfront
    Partial Upfront
    No Upfront

You choose an hourly commitment (e.g. $0.092).

# AWS Savings Plan

AWS Savings Plan has 3 different savings types:

Compute Compute Savings Plans provide the most flexibility and help to reduce your costs by up to 66%. These plans automatically apply to EC2 instance usage, AWS Fargate, and AWS Lambda service usage regardless of instance family, size, AZ, region, OS, or tenancy.

EC2 Instances Provide the lowest prices, offering savings up to 72% in exchange for commitment to usage of individual instance families in a region. Automatically reduces your cost on the selected instance family in that region regardless of AZ, size, OS or tenancy. Give you the flexibility to change your usage between instances within a family in that region.

SageMaker Helps you reduce SageMaker costs by up to 64%. Automatically apply to SageMaker usage regardless of instance family, size, component, or AWS region.