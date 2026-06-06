# Introduction to ECS
Elastic Container Service (ECS) EC2 is a container orchestration service to run containers across a multiple EC2 machines managed in a cluster
Auto Scaling group
└── ECS Cluster
    ├── EC2 Container
    │   ├── Task
    │   ├── Task
    │   ├── Task
    │   └── Service
    └── EC2 Container
        ├── Service
        └── Service

💡 Fargate is marketed as its own separate service but appears under ECS and most of the concepts that apply to ECS EC2 applies to Fargate

# Components of ECS
Cluster
Multiple EC2 instances which will house the docker containers.
Task Definition
A JSON file that defines the configuration of (up to 10) containers you want to run.
Task
Launches containers defined in Task Definition. Tasks do not remain running once workload is complete.
Service
Ensures tasks remain running eg. Web app.
Container Agent
Binary on each EC2 instance which monitors, starts and stops tasks.
ECS Controller / Scheduler
Responsible for scheduling the deployment and placement of your containers, Replace unhealthy containers
    You can create your own schedulers or use third-party schedulers

# ECS Fargate
ECS Fargate is a serverless orchestration container service. AWS manages the underlying server, so you don't have to scale or upgrade the EC2 server.

You can create an empty ECS cluster (no EC2's provisioned) and then launch Tasks as Fargate
You no longer have to provision, configure, and scale clusters of EC2 instances to run containers
You are charged for at least one minute, then it's by the second
You pay based on duration and consumption
Fargate must use awslogs networking mode, and will have an ENI in the VPC per task group
When using ELB to point to Fargate you have to use IP addresses since Fargate tasks do not have a hostname


ECS                              Fargate
Auto Scaling group               Auto Scaling group
└── ECS Cluster                  └── ECS Cluster
    ├── EC2 Container                ├── Task  Task  Service
    │   ├── Task Task Task Service   └── Task  Task  Service
    └── EC2 Container
        └── Service Service


# Configuring Fargate Tasks

In your Fargate Task Definition, you define the memory and vCPU

    Task memory (GB): 30GB
    Task CPU (vCPU): 4 vCPU


You will then add your containers and allocate the memory and vCPU required for each
When you run the Task, you can choose what VPC and subnet it will run in
Apply a Security Group to a Task
Apply an IAM role to the Task

*You can apply SG and IAM roles for both ECS and Fargate Tasks and Services

# ECS Execution Role
Execution Role is the role used to prepare or manage the container
Common permissions:

Access to Secrets Manager or SSM Parameter Store
Access to download private image from ECR
Full Access to CloudWatch Logs


yaml# CFN Example
ExecutionRole:
  Type: AWS::IAM::Role
  Properties:
    RoleName: CruddurServiceExecutionRole
    AssumeRolePolicyDocument:
      Version: '2012-10-17'
      Statement:
        - Effect: 'Allow'
          Principal:
            Service: 'ecs-tasks.amazonaws.com'
          Action: 'sts:AssumeRole'
    Policies:
      - PolicyName: 'cruddur-execution-policy'
        PolicyDocument:
          Version: '2012-10-17'
          Statement:
            - Sid: 'VisualEditor0'
              Effect: 'Allow'
              Action:
                - 'ecr:GetAuthorizationToken'
                - 'ecr:BatchCheckLayerAvailability'
                - 'ecr:GetDownloadUrlForLayer'
                - 'ecr:BatchGetImage'
                - 'logs:CreateLogStream'
                - 'logs:PutLogEvents'
              Resource: '*'
            - Sid: 'VisualEditor1'
              Effect: 'Allow'
              Action:
                - 'ssm:GetParameters'
                - 'ssm:GetParameter'
              Resource: !Sub
                'arn:aws:ssm:${AWS::Region}:${AWS::AccountId}:parameter/cruddur/${ServiceName}/*'
    ManagedPolicyArns:
      - arn:aws:iam::aws:policy/CloudWatchLogsFullAccess

## ECS Capacity Providers
Amazon ECS capacity providers manage the scaling of infrastructure for tasks in your clusters.
Each cluster can have one or more capacity providers and an optional capacity provider strategy.
Fargate has two predefined capacity providers (FARGATE and FARGATE SPOT) or you can create your own custom capacity provider.

bash
aws ecs create-capacity-provider \
--name FargateCapacityProvider \
--auto-scaling-group-provider managedScaling={"status": "ENABLED", "targetCapacity": 100} \
--auto-scaling-group-provider managedTerminationProtection="ENABLED"

# At the cluster level
aws ecs put-cluster-capacity-providers \
--cluster example-cluster \
--capacity-providers FargateCapacityProvider FARGATE FARGATE_SPOT \
--default-capacity-provider-strategy capacityProvider="FARGATE_SPOT",weight=1,base=0 \
capacityProvider="FARGATE",weight=1

# At the task level
aws ecs create-service \
# ...
--capacity-provider-strategy capacityProvider="FARGATE_SPOT",weight=1 \
capacityProvider="FARGATE",weight=1

# For ECS EC2 you create an Auto Scaling Group and associate that with your custom capacity provider. You then attach then custom capacity provider to ESC EC2
bashaws autoscaling create-auto-scaling-group --min-size 1 --max-size 10 --desired-capacity 2 \
# and other ASG flags...

aws ecs create-capacity-provider \
--name MyEC2CapacityProvider \
--auto-scaling-group-provider autoScalingGroupArn=ASG_ARN,managedScaling=
{"status":"ENABLED","targetCapacity":75},managedTerminationProtection="ENABLED"


# At the cluster level
aws ecs put-cluster-capacity-providers \
--cluster my-cluster \
--capacity-providers MyEC2CapacityProvider \
--default-capacity-provider-strategy capacityProvider="MyEC2CapacityProvider",weight=1,base=1

# At the task level
aws ecs create-service \
# ...
--capacity-provider-strategy capacityProvider="MyEC2CapacityProvider",weight=1,base=1

## For ECS EC2 you create an Auto Scaling Group and associate that with your custom capacity provider. You then attach then custom capacity provider to ESC EC2
bashaws autoscaling create-auto-scaling-group --min-size 1 --max-size 10 --desired-capacity 2 \
# and other ASG flags...

aws ecs create-capacity-provider \
--name MyEC2CapacityProvider \
--auto-scaling-group-provider autoScalingGroupArn=ASG_ARN,managedScaling=
{"status":"ENABLED","targetCapacity":75},managedTerminationProtection="ENABLED"


# At the cluster level
aws ecs put-cluster-capacity-providers \
--cluster my-cluster \
--capacity-providers MyEC2CapacityProvider \
--default-capacity-provider-strategy capacityProvider="MyEC2CapacityProvider",weight=1,base=1

# At the task level
aws ecs create-service \
# ...
--capacity-provider-strategy capacityProvider="MyEC2CapacityProvider",weight=1,base=1

# ECS Task Lifecycle
PROVISIONING → PENDING → ACTIVATING → RUNNING → DEACTIVATING → STOPPING → DEPROVISIONING → STOPPED

PROVISIONING — additional steps before the task is launched. Eg. Launching an Attaching ENIs
PENDING — waiting on the container agent to take further action
ACTIVATING — perform additional steps after the task is launched but before the task is running
RUNNING — task is successfully running
DEACTIVATING — perform additional steps before the task is stopped
STOPPING — waiting on the container agent to take further action
DEPROVISIONING — additional steps after the task has stopped. Eg. Detaching and deleting ENIs
STOPPED — task has been successfully stopped
DELETED — transition state when a task stops

# Task Definition JSON File Example

Family — a way to group similar task definitions (its how versioning works)
Execution Role — the role used to prepare or manage the container
Task Role — the role that is used by the running compute of the container
Network Mode
    Host — most basic mode, connect directly to the host machine
    Bridge — isolate between containers but they can still commute with each other
    AWSVPC — creates an ENI in your VPC with a private IP address
        Fargate can only use AWSVPC mode
    None — disable networking
    CPU and Memory — how much memory and compute
    Requires Compatibilities — EC2, FARGATE, EXTERNAL
    Container Definition — Defines the connection of containers to be provisioned on the compute



json
{
  "family": "backend-flask",
  "executionRoleArn": "arn:aws:iam::38754...",
  "taskRoleArn": "arn:aws:iam::3875430594...",
  "networkMode": "awsvpc",
  "cpu": "256",
  "memory": "512",
  "requiresCompatibilities": [
    "FARGATE"
  ],
  "containerDefinitions": [...]
}
Incomplete example

#
    Name: name of the container
    Image: a URI to the container image eg. ECR, DockerHub
    Essential: There always has to be one essential container, if this container fails all containers fail
    Health Check: Perform a healthcheck
    Port Mappings: Map the guest to host ports
    Log Configuration: Write logs to AWS CloudWatch
    Environment: Env Vars you want to set for your container
    Secrets: secrets pulled from Secrets Manager or SSM Parameter Store


json
{ // ...
  "containerDefinitions": [
    {
      "name": "backend-flask",
      "image": "387543059434.dkr.ecr.ca-central-1.amazonaws.com/backend-flask",
      "essential": true,
      "healthCheck": {
        "command": [
          "CMD-SHELL",
          "python /backend-flask/bin/health-check"
        ],
        "interval": 30, "timeout": 5, "retries": 3, "startPeriod": 60
      },
      "portMappings": [
        {
          "name": "backend-flask",
          "containerPort": 4567,
          "protocol": "tcp",
          "appProtocol": "http"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "cruddur",
          "awslogs-region": "ca-central-1",
          "awslogs-stream-prefix": "backend-flask"
        }
      },
      "environment": [
        {"name": "AWS_DEFAULT_REGION", "value": "ca-central-1"}
      ],
      "secrets": [
        {"name": "AWS_ACCESS_KEY_ID",
        "valueFrom": "arn:aws:ssm:ca-central-1:387543059434:parameter/..."},
      ]
    }
  ]}


#  Port Mappings


Bridge Mode

    container (guest) port maps to hosts different port
    The guest and host ports can be different
json
"portMappings": [
  {
    "containerPort": 3000,
    "hostPort": 80,
    "protocol": "tcp"
  }
]

Host Mode

    container (guest) port directly maps to the same host's port
    The guest and host ports will be the same
        You don't need to defined the host port because it will be the same value
json
"portMappings": [
  {
    "containerPort": 80,
    "protocol": "tcp"
  }
]

AWSVPC Mode

    Gives the container its own network interface with a direct public IP
    The guest and host port will be the same
        You don't need to defined the host port because it will be the same value

# ECS Exec
ECS Exec allows you to directly interact with containers without needing to first interact with the host container operating system, open inbound ports, or manage SSH keys.

ECS Exec works with both ECS EC2 containers and ECS Fargate containers

    ECS Exec commands are run as root
    ECS Exec commands cannot be executed via the AWS Management Console

        You must use a terminal


ECS Exec session has an idle timeout time of 20 minutes
ECS Exec must be turned on at the launch of a task

ECS Exec cannot be turned on for existing run tasks



Prerequisites:

    AWS CLI Installed
    Sessions Manager Plugin Installed
    The Task role must have permission
    You must meet version requirements for ECS or Fargate

{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ],
    "Resource": "*"
  }]
}

# In your Task Definition to avoid Zombie SSM agent children set initProcessEnabled for Linux

json
"containerDefinitions": [{
  // ....
  "linuxParameters": {
    "initProcessEnabled": true
  }
}],
Turn on ECS Exec when creating the service

bash
aws ecs create-service \
# .... other flags \
--enable-execute-command
Use ECS Exec to remotely execute a command

bash
aws ecs execute-command \
--cluster cluster-name \
--task task-id \
--container container-name \
--interactive \
--command "/bin/sh"


# Log Configuration
When configuring your containers in your Task Definition you can set a log driver.
A log driver tells where the container should log. awslogs will log to CloudWatch Logs
There are other third-party log drivers you can use.
ECS EC2 log driver support          Fargate log driver support
awslogs                             awslogs
fluentd                             splunk
gelf                                awsfirelens
json-file
journald
logentries
syslog
splunk
awsfirelens
Awslogs by default is blocking and you may want to configure it for nonblock or instead use AWS Firelens
AWS FireLens works with either Fluent Bit or Fluentd. That run as a sidecar container in the same ECS task. Firelens is used to avoid backpressure

json

"logConfiguration": {
  "logDriver": "awslogs",
  "options": {
    "awslogs-group": "my-ecs-logs",
    "awslogs-region": "us-west-2",
    "awslogs-stream-prefix": "ecs"
  }
}

ECS Service Connect makes it easy to setup a service mesh for service-to-service communication
Service Connect is an evolution of App Mesh, abstracting a lot of the configuration between App Mesh, Cloud Map and ELB
Service Connect will deploy a sidecar proxy container eg. Envoy
You can use the service discovery name to easily talk to other services.

ECS Service Connect
When you create your cluster you'll defined a ServiceConnectDefaults.
This creates a CloudMap Namespace
yamlResources:
  FargateCluster:
    Type: AWS::ECS::Cluster
    Properties:
      ClusterName: !Sub "${AWS::StackName}FargateCluster"
      CapacityProviders:
      ServiceConnectDefaults:
        Namespace: cruddur

When you create your service you configure it for Service Connect.
Providing the Namespace, Its Discover Name and Port Name
yamlResources:
  FargateService:
    Type: AWS::ECS::Service
    Properties:
      # other propreries....
      ServiceConnectConfiguration:
        Enabled: true
        Namespace: "cruddur"
        # TODO - If you want to log
        # LogConfiguration
        Services:
          - DiscoveryName: backend-flask
            PortName: backend-flask
            ClientAliases:
              - Port: !Ref ContainerPort


# ECS Optimized AMI
Amazon ECS-optimized AMIs are preconfigured with the requirements and recommendations to run your container workloads.

When you launch EC2 instance via ECS EC2 Management Console it will automatically use an Amazon EC2 Optimize AMI by default

Features of ECS Optimized AMIs:

    Comes with Docker installed
    Comes with ECS Container Agent Installed
    OS-level optimized for containers
    There is a variant of ECS Optimized with GPUs

To change the AMI (if you needed the GPU variant) would be adjusted in the launch template
bas
haws ec2 create-launch-template \
  --launch-template-name "ECSEc2LaunchTemplate" \
  --version-description "Version1" \
  --launch-template-data \
  '{
    "ImageId": "ami-0abcdef1234567890",


# ECS Optimized Bottlerocket AMI
Bottlerocket is a Linux-based open-source operation system that is purpose-built by AWS for running containers on Virtual Machines or bare metal hosts

    Bottlerocket doesn't include a package manager
    Software can only be run as containers
    Updates are both applied and can be rolled back in a single step, which reduces the likelihood of update errors.

Bottlerocket AMIs also don't support the following services and features:

    ECS Anywhere
    Service Connect
    Amazon EFS in encrypted mode and awsvpc network mode

# Registering ECS EC2 Instances to Cluster
To add an ECS EC2 instance to a cluster you have to set this
toml
 userdata.toml
[settings.ecs]
cluster = "my-cluster-name"

bash
aws ec2 run-instances \
  --key-name ecs-bottlerocket-example \
  --subnet-id subnet-08fc749671b2d077c \
  --image-id <bottlerocket_ami> \
  --instance-type t3.large \
  --region ca-central-1 \
  --user-data file://userdata.toml \
  --iam-instance-profile Name=ecsInstanceRole

# 02:54
ECS Anywhere
Amazon ECS Anywhere allows you to register external VMs residing from your on-premise network to your ECS Cluster.

  $0.01025 per hour for each managed ECS Anywhere on-premises instance
  You can register an external instance to a single cluster
  External instances require an IAM role that allows them to communicate with AWS APIs
  ECS Exec is supported on external instances
  awsvpc network mode isn't supported
  Service load balancing isn't supported
  Service discovery isn't supported
  ECS capacity providers aren't supported
  ECS Anywhere uses the launch type EXTERNAL
  SELinux isn't supported
  EFS volumes aren't supported
  You can run ECS Anywhere on Windows but you need a Windows License

Data center                          Amazon Web Services
└── On-premises server or VM         └── Region
    ├── ECS Agent  ─────────────────────► Amazon ECS
    ├── SSM Agent  ─────────────────────► AWS Systems Manager
    └── Containers


# To install you need to:

  create SSM Activation pair
  download the install script to your machine
  run the install script

bash
# Create an Systems Manager activation pair
aws ssm create-activation --iam-role ecsAnywhereRole | tee ssm-activation.json

# Download Install Script
curl --proto "https" -o "/tmp/ecs-anywhere-install.sh" \
"https://amazon-ecs-agent.s3.amazonaws.com/ecs-anywhere-install-latest.sh"

# Run the Install Script
sudo bash /tmp/ecs-anywhere-install.sh \
  --region $REGION \
  --cluster $CLUSTER_NAME \
  --activation-id $ACTIVATION_ID \
  --activation-code $ACTIVATION_CODE

The Install scripts runs and starts the ECS Service agent which you can manage via systemctl
bashsudo systemctl start ecs.service

