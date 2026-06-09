# # Amazon MSK
Amazon Managed Streaming for Apache Kafka (Amazon MSK) is a fully managed service that enables you to build and run applications that use Apache Kafka to process streaming data.

Amazon MSK utilizes Zookeeper servers.
    Amazon MSK does not support KRaft

There are two types of nodes:
    Broker nodes — handles storage and processing of messages
    ZooKeeper nodes (Znodes) — manages the overall structure of the cluster

Amazon MSK comes in two types of clusters:
    Provisioned — you manage the broker instances
    Serverless — you pay for what you use, and you don't have to manage instances

Kafka has direct integrations with:
    Amazon S3
    EventBridge Pipes

# Amazon MSK – Bootstrap Brokers
Bootstrap brokers refers to a list of brokers endpoints that an Apache Kafka client can use as a starting point to connect to the cluster.
bashaws kafka get-bootstrap-brokers --cluster-arn ClusterArn

# {
#     "BootstrapBrokerStringPublicSaslIam": "...",
#     "BootstrapBrokerStringSaslIam": "..."
# }

    BootstrapBrokerStringPublicSaslIam is for public access
    BootstrapBrokerStringSaslIam string for access from within AWS.


Depending on how many AZs you've deployed your cluster in, there will be a comma separated list with an endpoint for each AZ.

# Amazon MSK – Zookeeper Connection String
ZooKeeper connection string URL is used with Kafka to specify the host and port of the ZooKeeper ensemble that Kafka should connect to for managing cluster metadata and coordination:

    Broker Registration
    Topic Configuration
    Cluster Membership
    Quota Management
    Access Control Lists (ACLs)

bash
bin/kafka-topics.sh --create \
--zookeeper "ZookeeperConnectString" \
--replication-factor 2 \
--partitions 1 \
--topic my-topic

We can get the Zookeeper Connection String URL using describe-cluster:
bash
aws kafka describe-cluster \
--cluster-arn ClusterArn \
--query ClusterInfo.ZookeeperConnectString
We cannot call the describe-clusters against MSK Serverless Cluster

Starting from Kafka 2.8, there is a mode called KRaft (Kafka Raft Metadata mode) which allows Kafka to run without ZooKeeper.

# Amazon MSK Connect

MSK Connect is a feature of Amazon MSK that makes it easy for developers to stream data to and from their Apache Kafka clusters.
MSK Connect uses Kafka Connect open-source framework for connecting Apache Kafka clusters with external systems such as databases, search indexes, and file systems

You can download Kafka Connect plugins (or create your own) Upload to S3 and then create a plugin in MSK Connect
bash
aws kafkaconnect create-custom-plugin \
--name mongodb \
--description "MongoDB Kafka Connector" \
--content-location '{
  "s3Location":{
  "bucketArn": "<arn-of-your-s3-bucket>",
  "fileKey": "mongo-kafka-connector.jar
  }
}'

Then you create a connector specifying the plugin and configuration information to your source
bash
aws kafkaconnect create-connector \
--kafka-cluster clusterArn=<kafka-cluster-arn> \
--kafka-client-authentication-type NONE \
--kafka-cluster-encryption-in-transit-type PLAINTEXT \
--plugin name=<plugin-name>,revision=<plugin-revision> \
--service-execution-role-arn <your-execution-role-arn> \
--connector-configuration '
{
  "name": "MongoDBSourceConnector",
  "config": {
    "connector.class": "com.mongodb.kafka.connect.MongoSourceConnector",
    "tasks.max": "1",
    "topics": "mongoDBTopic",
    "connection.uri": "mongodb://yourMongoDBInstance",
    // other necessary configuration properties
  }
}'

# What is Apache Kafka?


Apache Kafka is an open-source streaming platform to create high-performance data pipelines, streaming analytics, data integration, and mission-critical applications.
Kafka was originally developed by LinkedIn, and open-sourced in 2011

Java / Scala — Kafka was written in Scala and Java. To use Kafka you need to write Java code.

In Kafka data is stored in partitions on a Kafka Cluster which can span multiple machines (distributed computing)
Producers publish messages in a key and value format using the Kafka Producer API
Consumers can listen for messages and consume them using the Kafka Consumer API
Messages are organized into Topics. Producers will push messages to topics and consumers will listen on topics.


We can interact with Kafka using Kafka-CLI scripts
We can use a programming SDK for Kafka in various languages


Diagramme :
Producer    Producer    Producer
    \           |           /
         Kafka Cluster
    ┌─────────────────────────┐
    │  Topic    Topic   Topic │
    │ [Partition][Partition][Partition] │
    │ [Partition][Partition][Partition] │
    │ [Partition][Partition][Partition] │
    └─────────────────────────┘
    /           |           \
Consumer    Consumer    Consumer

# What is Apache Zookeeper?
 

Apache ZooKeeper is an open-source server for highly reliable distributed coordination of cloud applications

Open-source projects that use Zookeeper :

    Apache Hadoop
    Apache Kafka
    Apache Solr
    Apache Hbase
    Apache Accumulo
    Apache Druid
    Apache Helix


Zookeeper exposes common services - such as naming, configuration management, synchronization, and group services - in a simple interface so you don't have to write them from scratch

Diagramme :
            ZooKeeper Service
┌─────────────────────────────────────────┐
│  Server   Server  [Leader]  Server  Server │
│      ↕       ↕       ↕       ↕       ↕   │
└─────────────────────────────────────────┘
      ↑       ↑       ↑       ↑       ↑
   Client  Client  Client  Client  Client  ...

Un des serveurs est élu Leader, les autres sont des Followers. Les clients se connectent à n'importe quel serveur du cluster.

# Kafka CLI


The Kafka CLI scripts are downloaded alongside Kafka. → https://kafka.apache.org/downloads
Kafka CLI is different from other CLI tools in that it's a series of scripts instead of one binary.

Note
Kafka's testing framework is called Trogdor, a reference to the Homestar Runner character.

# docs.aws.amazon.com/msk/latest/developerguide/serverless-getting-started.html
