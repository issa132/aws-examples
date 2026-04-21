# AWS Batch
AWS Batch plans, schedules, and executes your batch computing workloads across the full range of AWS compute services, can utilize Spot Instance to save money.
Jobs — a named unit of work, eg. Shell script, docker container image
Job Definitions — defines how to run the job eg. Amount of compute and memory
Job Queues — a collection of jobs that determine job priority
Job Scheduler — evaluates when, where, and how to run jobs that are submitted to a job queue.

Defaults to First-In-First-Out (FIFO)

AWS Batch can run jobs on:

    EC2
    Fargate
    EKS
Array Jobs — a job that shares common parameters, such as the job definition, vCPUs, and memory
Mulit-node parallel Jobs — run single jobs that span multiple Amazon EC2 instances
GPU Jobs — jobs that run on EC2 GPU-based instance types

Job Dependencies — Allows you to specific a job Id to another job.
Only when that other job complete with the job be scheduled to process

# Register Job

aws batch register-job-definition \
  --job-definition-name square-job \
  --type container \
  --container-properties '{"image": "my-docker-image"}'


# Register Job

aws batch register-job-definition \
  --job-definition-name square-job \
  --type container \
  --container-properties '{"image": "982383527471.dkr.ecr.ca-central-1.amazonaws.com/square"}'

# Register Job
# docs.aws.amazon.com/cli/latest/reference/batch/register-job-definition.html#examples
# docs.aws.amazon.com/cli/latest/reference/batch/create-job-queue.html#examples

aws batch register-job-definition \
--job-definition-name square-job \
--type container \
--container-properties '{
    "image": "982383527471.dkr.ecr.ca-central-1.amazonaws.com/square",
    "vcpus": 1,
    "memory": 128
}'
# create compute environnement


# you have to create a job queue first
# docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-batch-computeenvironment.html
aws batch create-job-queue \
--job-queue-name my-job-queue \
--state ENABLED \
--priority 10 \
--compute-environment-order

aws batch create-job-queue \
--job-queue-name my-job-queue \
--state ENABLED \
--priority 1 \
--compute-environment-order order=1,computeEnvironment=arn:aws:batch:ca-central-1:982383527471:compute-environment/ComputeEnv

# ComputeEnv c est le nom du batch environnement que j' ai crée dans l'espace graphique de aws



{
  "jobQueueName": "LowPriority",
  "state": "ENABLED",
  "priority": 10,
  "computeEnvironmentOrder": [
    {
      "order": 1,
      "computeEnvironment": "M4Spot"
    }
  ]
}



# Submit Job

aws batch submit-job \
  --job-name my-job \
  --job-definition square-job \
  --job-queue my-job-queue



gitpod /workspace/AWS-Examples/batch (main) $ docker ps
CONTAINER ID   IMAGE   COMMAND   CREATED   STATUS   PORTS   NAMES
gitpod /workspace/AWS-Examples/batch (main) $ docker images
REPOSITORY   TAG      IMAGE ID       CREATED          SIZE
app          latest   881c3f42eaf4   2 minutes ago    996MB
gitpod /workspace/AWS-Examples/batch (main) $

gitpod /workspace/AWS-Examples/batch (main) $ docker tag square:latest 982383527471.dkr.ecr.ca-central-1.amazonaws.com/square:latest
gitpod /workspace/AWS-Examples/batch (main) $ docker tag square:latest 982383527471.dkr.ecr.ca-central-1.amazonaws.com/square:latest
gitpod /workspace/AWS-Examples/batch (main) $ docker push 982383527471.dkr.ecr.ca-central-1.amazonaws.com/square:latest

# docs.aws.amazon.com/AmazonECS/latest/APIReference/API_ContainerDefinition.html
