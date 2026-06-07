# EKS Cloud
Amazon Elastic Kubernetes Service (Amazon EKS) is a managed service that eliminates the need to install, operate, and maintain your own Kubernetes control plane on AWS

Connect and manage your cluster via KubeCTLConnect and manage your cluster via KubeCTL
Use ALB to route traffic to your nodes via the AWS ALB Ingress ControllerUse ALB to route traffic to your nodes via the AWS ALB Ingress Controller

EKS can use for its compute nodes:

EC2 instances

    Managed Node groups — Auto scaling is fully managed by AWS
    Self-Managed Node Groups — Customer can self-manage scaling using EC2 Auto Scaling Groups
    Karpenter — cloud-native open-source autoscaler


Fargate instances
External instances (on-premise)

# EKS Connector
Amazon EKS Connector to register and connect any conformant Kubernetes cluster to AWS and visualize it in the Amazon EKS console. (Bring your own K8 cluster to EKS)
You install EKS Connector via helm in your targeted cluster

bash
helm -n eks-connector install eks-connector \
oci://public.ecr.aws/eks-connector/eks-connector-chart \
--set eks.activationCode="<your-activation-code>" \
--set eks.activationId="<your-activation-id>" \
--set eks.agentRegion="<your-region>"

# EKS CTL
EKS CTL is a CLI Tool for easily setting up K8s clusters on AWS.

EKs can deploy:
    EC2-backed nodes
    Fargate-backed nodes
To a private cluster on AWS Outposts

bash
eksctl create cluster
By default EKS CTL will use the following settings:

    auto-generated name, eg., fabulous-mushroom-1527688624
    two m5.large worker nodes
    EC2 Instances configured with AWS EKS AMI
    Deployed in us-west-2 region
    a dedicated VPC
    EKS CTL can be configure via a configuration file:

bash
eksctl create cluster -f cluster.yaml

yaml
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig

metadata:
  name: basic-cluster
  region: eu-north-1

nodeGroups:
  - name: ng-1
    instanceType: m5.large
    desiredCapacity: 10
  - name: ng-2
    instanceType: m5.xlarge
    desiredCapacity: 2

# EKS Distro
EKS Distro (EKS-D) est une distribution Kubernetes basée sur et utilisée par EKS pour créer des clusters K8s fiables et sécurisés.

https://distro.eks.amazonaws.com

Cas d'utilisation :

    Déploiements hybrides — cohérence entre AWS et on-prem.
    Développement et tests — environnement de prod et dev identiques.
    Extension des services AWS — intégration AWS aux configurations sur site.


Méthodes d'installation :

    Communauté : kubeadmn, kinit, kops
    Partenaires tiers ex. Pulumi, DataDog, SysDig, Kubestack
    EKS Anywhere

EKS-D comprend les composants suivants :

    CNI plugins
    CoreDNS
    etcd
    CSI Sidecars
    aws-iam-authenticator
    Kubernetes Metrics Server
    Kubernetes

Une méthode d'installation supportée pour EKS-D est disponible avec EKS Anywhere (EKS-A).

# EKS Anywhere
Amazon EKS Anywhere (EKS-A) est une option de déploiement pour Amazon EKS permettant de créer et d'opérer facilement des clusters K8s sur site avec vos propres VMs ou hôtes bare metal.

    EKS-A déploie Amazon EKS Distro comme distribution K8s.
    EKS Anywhere vous permet de gérer vos clusters déployés depuis la AWS Management Console.


Admin Machine est requise pour exécuter les opérations du cycle de vie du cluster :

    N'a pas besoin de fonctionner en continu
    Les artefacts critiques du cluster sont sauvegardés sur la machine admin lors de la création, ex. fichier kubeconfig, clés SSH, le yaml complet de spécification du cluster


Le cluster peut être déployé sur :

    VMware vSphere
    Bare Metal (using Tinkerbell)
    AWS Snowball Edge
    Apache CloudStack
    Nutanix
    Docker (clusters de développement)

EKS Anywhere is open-source and free.
EKS Anywhere Enterprise Subscriptions for 24/7:

    1-year term at $24,000 per cluster
    3-year term at $18,000 per cluster per year

# Traces and Spans
A trace is a data/execution path through the system, and can be thought of as a directed acyclic graph (DAG) of spans.
A span represents a logical unit of work in Jaeger that has an operation name, the start time of the operation, and the duration.
Spans may be nested and ordered to model causal relationships.

# Open Telemetry
Open Telemetry (OTEL) is a collection of open-source tools, APIs and SDKs to instrument, generate, collect, and export telemetry data.
Open Telemetry standardizes the way telemetry data (metrics, logs and traces) are generated and collected.

Wire protocol
A wire protocol refers to a way of getting data from point to point. Eg. SOAP, AMQP

# Open Telemetry – Instrumentation
Instrumentation is the act of embedding a monitoring library into your existing application in order to capture monitoring data such as: metrics, traces or logging.
Open Telemetry supports a variety of languages:

    C++
    .NET
    Erlang / Elixir
    Go
    Java
    Javascript
    Php
    Python
    Ruby
    Rust
    Swift

For certain frameworks there are plug-and-play libraries to quickly instrument your apps:

    Spring
    ASP.NET Core
    Express
    Quarkus

# Open Telemetry – Collector
The Open Telemetry collector is an agent installed on the target machine, or as a dedicated server and is a Vendor-agnostic way to receive, process and export telemetry data.

    It removes the need to run, operate, and maintain multiple agents/collectors.
    This works with improved scalability and supports open-source observability data formats (e.g. Jaeger, Prometheus, Fluent Bit, etc.) sending to one or more open-source or commercial back-ends.
    The local Collector agent is the default location to which instrumentation libraries export their telemetry data.


# AWS Distro for OpenTelemetry
AWS Distro for OpenTelemetry (ADOT) is a secure, production-ready, AWS-supported distribution of the OpenTelemetry project.
https://aws-otel.github.io/

Send correlated logs, metrics, and traces to or from more observability backends such as:

    Amazon Managed Service for Prometheus (AMP)
    Amazon Managed Streaming for Apache Kafka (MSK)
    Amazon CloudWatch
    AWS X-Ray
    Amazon Open Search
    Any OpenTelemetry Protocol (OTLP) compliant backend


Observe apps running in:

    EC2
    ECS EC2
    Fargate
    EKS
    AWS App Runner
    AWS Lambda
    On-premise

# Prometheus
Prometheus is an open-source systems monitoring and alerting toolkit originally built at SoundCloud. Prometheus collects and stores its metrics as time series data. Prometheus is a timeseries database.
Prometheus's main features are:

    A multi-dimensional data model with time series data identified by metric name and key/value pairs
    PromQL, a flexible query language to leverage this dimensionality
    No reliance on distributed storage; single server nodes are autonomous
    Time series collection happens via a pull model over HTTP
    Pushing time series is supported via an intermediary gateway
    Targets are discovered via service discovery or static configuration
    Multiple modes of graphing and dashboarding support

Prometheus values reliability. You can always view what statistics are available about your system, even under failure conditions.

If you need 100% accuracy, such as for per-request billing, Prometheus is not a good choice as the collected data will likely not be detailed and complete enough.

# Prometheus – Architecture
Prometheus scrapes metrics from instrumented jobs, either directly or via an intermediary push gateway for short-lived jobs.

It stores all scraped samples locally and runs rules over this data to either aggregate and record new time series from existing data or generate alerts.

Grafana or other API consumers can be used to visualize.

Key components:

Pushgateway — receives metrics pushed by short-lived jobs at exit
Prometheus server — contains Retrieval, TSDB, and HTTP server
Service discovery — discovers targets via Kubernetes or file_sd
Alertmanager — pushes alerts to PagerDuty, Email, etc.
Prometheus web UI — exposes data via PromQL
Grafana / API clients — used for data visualization and export
Jobs/exporters — act as Prometheus targets on Node (HDD/SSD)

# Amazon Managed Service for Prometheus
Amazon Managed Service for Prometheus (AMP) is a Prometheus-compatible monitoring service for container infrastructure and application metrics.
AMP is a fully-managed Prometheus Server Environment

AMP makes it easy for customers to securely monitor container environments at scale.

You can use Amazon Managed Service for Grafana (AMSG) to visualize data within AMP.
You can also use AWS Distro for OpenTelemetry (ADOT) to ingest application metrics from your environment with AMP.

# Grafana
Grafana is an open source analytics and interactive visualization web application. Grafana is commonly used along with a timeseries database like: InfluxDB, Prometheus or Graphite.

# Amazon Managed Service for Grafana
Amazon Managed Grafana (AMG) is a fully managed and secure data visualization service that you can use to instantly query, correlate, and visualize operational metrics, logs, and traces from multiple sources.

