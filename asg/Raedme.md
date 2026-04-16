An Auto Scaling Group (ASG) contains a collection of EC2 instances that are treated as a group for the purposes of automatic scaling and management.

Automatic scaling can occur via:

    Capacity Settings — set the expected range of capacity
        Manual Scaling
    Health Check Replacements — replace instances if they are determined unhealthy
        EC2 or ELB Health Checks

    Scaling Policies — set complex rules to determine when to scale up or down
        Simple Scaling
        Step Scaling
        Target Tracking Scaling
        Predictive Scaling

ASGS are used to scale EC2 instances. ECS with EC2 will work, EKS with EC2 will work. Fargate does not use ASGs.
EKS stands for Amazon Elastic Kubernetes Service.
It is a managed Kubernetes service provided by AWS that allows you to run Kubernetes (a container orchestration system) without having to install and manage your own Kubernetes control plane.
En résumé :

Kubernetes : système open-source pour automatiser le déploiement, la mise à l'échelle et la gestion de conteneurs (Docker, etc.)
EKS : version gérée par AWS de Kubernetes — AWS s'occupe du control plane (haute disponibilité, mises à jour, sécurité)

Cas d'usage typiques :

    Déployer des applications conteneurisées à grande échelle
    Microservices
    CI/CD pipelines
    Applications nécessitant une orchestration avancée de conteneurs

Différence avec ECS :

ECS (Elastic Container Service) = solution propriétaire AWS pour les conteneurs
EKS = Kubernetes standard sur AWS (plus portable, plus universel)

Et comme mentionné dans votre cours : avec EKS, vous pouvez utiliser des instances EC2 comme nœuds workers, mais si vous utilisez Fargate (mode serverless), les ASGs ne sont pas utilisés.
ECS stands for Amazon Elastic Container Service. C'est le service AWS propriétaire pour orchestrer des conteneurs Docker. 

# ASG – Capacity Settings

aws autoscaling update-auto-scaling-group \
--auto-scaling-group-name my-asg \
--min-size 2 \
--max-size 10

aws autoscaling set-desired-capacity \
--auto-scaling-group-name my-asg \
--desired-capacity 2 \
--honor-cooldown

# ASG – Health Check Replacements
Health Check Replacement is when an ASG replaces an if the instance is considered unhealthy. There are two types of health checks ASG can perform.

EC2 Health Check
If the EC2 instance fails either of its EC2 Status Checks.

ELB Health Check
ASG will perform a health check based on the ELB health check.
ELB pings an HTTP endpoint at a specific path, port and status code.
ELB = Elastic load balancer (ELB (Elastic Load Balancer) a pour but de distribuer le trafic entrant entre plusieurs instances EC2 (ou autres cibles).)

bashaws autoscaling update-auto-scaling-group \
--auto-scaling-group-name my-asg \
--health-check-type ELB \
--health-check-grace-period 600 \
--vpc-zone-identifier "subnet-5ea0c127,subnet-6194ea3b,subnet-c934b782"
Note : --health-check-grace-period 600 = délai de 600 secondes (10 min) avant que l'ASG commence à vérifier la santé d'une nouvelle instance.

An Elastic Load Balancer (ELB) can be attached to your Auto Scaling Group (ASG)

aws autoscaling attach-load-balancer-target-groups \
--auto-scaling-group-name my-asg \
--target-group-arns ...

ASG → CLB

Classic Load Balancers are associated directly to the ASG

ASG → Target Group → ALB, NLB

ALB, NLB or GWLB are associated indirectly via their Target Groups.


En résumé :
Load Balancer       Association avec ASG
CLB (Classic)       Directement à l'ASG
ALB, NLB, GWLB      Indirectement via un Target Group

Acronyme                Nom complet                     Couche                  Usage
ALB                 Application Load Balancer             7 (HTTP)          Apps web, microservices
NLB                 Network Load Balancer                 4 (TCP/UDP)       Haute performance
GWLB                Gateway Load Balancer                 3 (réseau)        Firewalls, sécurité réseau
CLB                 (Classic Load Balancer)Legacy         Layer 4 & 7 (not recommended)

An attached ELB means that the ASG can use the Load Balancer's health check instead of EC2


# ASG – Simple Scaling Policy

Simple Scaling Policies changent simplement la capacité (augmenter ou diminuer) d’un certain montant lorsqu’une alarme CloudWatch est déclenchée.

# Scale Out
aws autoscaling put-scaling-policy \
--policy-name my-simple-scale-out-policy \
--auto-scaling-group-name my-asg \
--scaling-adjustment 30 \
--adjustment-type PercentChangeInCapacity

# Scale In , remove one instance when scaling out
aws autoscaling put-scaling-policy \
--policy-name my-simple-scale-in-policy \
--auto-scaling-group-name my-asg \
--scaling-adjustment -1 \
--adjustment-type ChangeInCapacity \
--cooldown 180

# When using Simple Scaling Policy it's recommended to set a cooldown period.
# It's recommended to not use Simple Scaling Policy and cooldown and instead use Step or Target Tracking policies.

# Here's the AWS CLI command to create a CloudWatch alarm for an Auto Scaling Group scale-out policy: 
# --alarm-actions — Replace <arn-to-scale-out-policy> with your actual scaling policy ARN
aws cloudwatch put-metric-alarm \
  --alarm-name "my-asg-scale-out-alarm" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 300 \
  --threshold 70 \
  --comparison-operator GreaterThanThreshold \
  --dimensions Name=AutoScalingGroupName,Value=my-asg \
  --evaluation-periods 2 \
  --alarm-actions <arn-to-scale-out-policy> \
  --unit Percent

# To get your scale-out policy ARN, run:
aws autoscaling describe-policies --auto-scaling-group-name my-asg


# Here's the Step Scaling Policy command with explanation:
bashaws autoscaling put-scaling-policy \
  --auto-scaling-group-name my-asg \
  --policy-name my-step-scale-out-policy \
  --policy-type StepScaling \
  --adjustment-type PercentChangeInCapacity \
  --metric-aggregation-type Average \
  --step-adjustments MetricIntervalLowerBound=0.0,MetricIntervalUpperBound=15.0,ScalingAdjustment=10 \
                     MetricIntervalLowerBound=15.0,MetricIntervalUpperBound=25.0,ScalingAdjustment=20 \
                     MetricIntervalLowerBound=25.0,ScalingAdjustment=30 \
  --min-adjustment-magnitude 1

--min-adjustment-magnitude 1 — Ensures at least 1 instance is always added/removed, even if the percentage rounds to 0

Here's the Target Tracking Scaling Policy command with explanation:

aws autoscaling put-scaling-policy \
  --policy-name cpu50-target-tracking-scaling-policy \
  --auto-scaling-group-name my-asg \
  --policy-type TargetTrackingScaling \
  --target-tracking-configuration file://config.json

config.json:

{
  "TargetValue": 50.0,
  "PredefinedMetricSpecification": {
    "PredefinedMetricType": "ASGAverageCPUUtilization"
  }
}

Here's the ASG Termination Policies breakdown:
CLI Command:
bashaws autoscaling update-auto-scaling-group \
  --auto-scaling-group-name my-asg \
  --termination-policies \
  "OldestLaunchConfiguration" \
  "ClosestToNextInstanceHour"

You can chain multiple policies — AWS evaluates them in order until it identifies which instance to terminate.


All Predefined Policies:
Policy                                  Description
Default                             AWS default logic — balances AZs first, then picks oldest launch template
AllocationStrategy                  Terminates based on the instance type allocation strategy (useful for Spot)
OldestLaunchTemplate                Terminates instances using the oldest launch template 
versionOldestLauncConfiguration     Terminates instances using the oldest launch configuration (legacy)
ClosestToNextInstanceHour           Terminates the instance closest to its next billing hour — saves cost
NewestInstance                      Terminates the most recently launched instanceOldestInstanceTerminates the oldest running instance