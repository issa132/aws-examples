# The Pillars of Observability

What is Observability?
The ability to measure and understand how internal systems work in order to answer questions regarding performance, tolerance, security and faults with a system / application.
To obtain observability you need to use Metrics, Logs and Traces.
You have to use them together, using them in isolate does not gain you observability.
Metrics
A number that is measured over period of time.
eg. If we measured the CPU usage and aggerated it over a period of time we could have an Average CPU metric
Logs
A text file where each line contains event data about what happened at a certain time.
Traces
A history of request that is travels through multiple Apps/services so we can pinpoint performance or failure.
Alarms it sometimes considered the fourth Pillar of Observability. ex: envoyer une alerte, déclencher un autoscaling, etc.

# AWS CloudWatch is a monitoring solution for your AWS resources.
☂️ CloudWatch is an umbrella service meaning that it is really a collection of monitoring tools as follows:
Logs — any custom log data, Application Logs, Nginx Logs, Lambda Logs
Metrics — Represents a time-ordered set of data points. A variable to monitor. eg. Memory Usage
Events — trigger an event based on a condition eg. ever hour take snapshot of server (now known as Amazon EventBridge)
Alarms — triggers notifications based on metrics which breach a defined threshold
Dashboards — create visualizations based on metrics
ServiceLens — visualize and analyze the health, performance, availability of your app in a single place
Container Insights — collects, aggregates, and summarizes metrics and logs from your containerized apps and microservices
Synthetics — test your web-apps to see if they're broken
Contributor Insights — view the top contributors impacting the performance of your systems and applications in real-time

# CloudWatch Logs is the basis for many CloudWatch Services

Explication :
CloudWatch Logs est le fondement sur lequel s'appuient de nombreux autres services CloudWatch :
CloudWatch Logs (base)
        │
        ├──► Metrics (extraites des logs via Metric Filters)
        │
        ├──► Alarms (basées sur les metrics extraites)
        │
        ├──► ServiceLens (analyse les logs de traces)
        │
        ├──► Container Insights (agrège les logs de containers)
        │
        └──► Contributor Insights (analyse les patterns dans les logs)
En résumé : sans logs, la plupart des autres services CloudWatch ne peuvent pas fonctionner correctement — c'est la source de données primaire de tout l'écosystème de monitoring AWS.

# CloudWatch Logs
CloudWatch Logs is used to monitor, store, and access your log files.
CloudWatch is a centralized log management service.
Export Logs to S3
You can export Logs to S3 to do things like perform custom analysis.
Stream to Elasticsearch Service (ES)
You can stream logs to an ES cluster in near real-time to have more robust full text search or use with the ELK stack.
Stream CloudTrail Events to CloudWatch Logs
You can turn on CloudTrail to stream event data to a CloudWatch Log Group.
Log Security
By default, log groups are encrypted at rest using SSE. You can use your own Customer Master Key (CMKs) with AWS KMS.
Log Filtering
Logs can be filtered using a Filtering Syntax and CloudWatch Logs has as sub-service called CloudWatch Insights.
Log Retention
By default, logs are kept indefinitely and never expire. You can adjust the retention policy for each log group:

keeping the indefinite retention
choosing a retention period between 1 Day to 10 Years

Most AWS Services are integrated with CloudWatch Logs.
Logging of services sometimes needs to be turned on or requires the IAM Permissions to write to CloudWatch Logs.

# Log Streams
A log stream represents a sequence of events from a application or instance being monitored.
You can create Log Streams manually but generally this is automatically done by the service you are using.

Here is a Log Group for a Lambda function
You can see here the Log Streams are named after the running instance. Lambdas frequency run on new instances so the stream streams contain timestamps.
Exemple :

2020/07/06/[$LATEST]ebca38579fac4842b531b260d5c35e0e
2020/07/06/[$LATEST]7679ba0f37b14a3da994cd243963ca60
etc.


Here is a Log Group for an application logs running on EC2
You can see here the Log Streams are named after the running instance's Instance ID.
Exemple :

i-0761fcbbdcb19ffc8
i-09239615bc7f3f552
i-06c9e4fb3469e17a4
etc.


Here is a Log Group for AWS Glue.
You can see here the Log Streams are named after the Glue Jobs.
Exemple :

exampro-events-crawler
exampro-waf-logs
exampro-leads-crawler
dynamodb-events-tracking
cloudtrail

Log Group = conteneur → Log Stream = flux d'événements d'une source spécifique.

# Log Events
Represents a single event in a log file. Log events can be seen within a Log Stream.

La hiérarchie complète CloudWatch Logs :
Log Group
└── Log Stream (une source/instance)
    └── Log Event (un événement individuel)
    └── Log Event
    └── Log Event
        ...
Les 3 niveaux :
Niveau      Description                     Exemple
Log Group   Conteneur                       principal/aws/lambda/my-functionLog 
Stream      Flux d'une source spécifique    i-0761fcbbdcb19ffc8
Log Event   Un seul événement horodaté      [2024-03-16 10:23:01] ERROR: timeout

Analogie :

Log Group = un classeur
Log Stream = un cahier dans le classeur
Log Event = une ligne dans le cahier

# CloudWatch Logs Insights
Cheat sheets, Practice Exams and Flash cards 👉 www.exampro.co/ssa-c03
CloudWatch Logs Insights enables you to interactively search and analyze your CloudWatch log data and has the following advantages:

more robust filtering then using the simple Filter events in a Log Stream
Less burdensome then having to export logs to S3 and analyze them via Athena.

CloudWatch Logs Insights supports all types of logs.
CloudWatch Logs Insights is commonly used via the console to do ad-hoc queries against logs groups.
CloudWatch Insights has its own language called:

CloudWatch Logs Insights Query Syntax

sql
filter action="REJECT"
| stats count(*) as numRejections by srcAddr
| sort numRejections desc
| limit 20


Query par défaut :
sql
fields @timestamp, @message
| sort @timestamp desc
| limit 20

# A single request can query up to 20 log groups.
  Queries time out after 15 minutes, if they have not completed.
  Query results are available for 7 days.

# CloudWatch Insights – Discovered Fields
Cheat sheets, Practice Exams and Flash cards 👉 www.exampro.co/ssa-c03
When CloudWatch Insights reads a logs, it will first analyze the log events and try to structure the content by generating fields that you can then use in your query.
CloudWatch Logs Insights inserts the @ symbol at the start of fields that it generates.
Five system fields will be automatically generated:
Champ           Description
@message        the raw unparsed log event.
@timestamp      the event timestamp contained in the log event's timestamp field.
@ingestion      Timethe time when the log event was received by CloudWatch Logs.
@logStream      the name of the log stream that the log event was added to.
@log            is a log group identifier in the form of account-id:log-group-name.

Règle : tout champ commençant par @ = généré automatiquement par CloudWatch Insights. Les autres champs sont extraits du contenu du log.

# CloudWatch Logs Insights automatically discovers fields in logs from AWS services such as:
Amazon VPC Flow Logs
@timestamp, @logStream, @message, accountId, endTime, interfaceId, logStatus, startTime, version, action, bytes, dstAddr, dstPort, packets, protocol, srcAddr, srcPort
Amazon Route 53
@timestamp, @logStream, @message, edgeLocation, hostZoneId, protocol, queryName, queryTimestamp, queryType, resolverIp, responseCode, version
AWS Lambda
@timestamp, @logStream, @message, @requestId, @duration, @billedDuration, @type, @maxMemoryUsed, @memorySize With X-Ray: @xrayTraceId and @xraySegmentId
AWS CloudTrail
eventVersion, eventTime, eventSource, eventName, awsRegion, sourceIPAddress, userAgent ...
There are more, you have to check the JSON in the CloudTrail events to see full list.
JSON Logs
The fields of a JSON log will be turned into fields.
Other Types of Logs
Fields that CloudWatch Logs Insights doesn't automatically discover you can use the parse command to extract and create ephemeral fields for use in that query.

# A CloudWatch Metric represents a time-ordered set of data points.
Its a variable that is monitored over time.
CloudWatch comes with many predefined metrics that are generally name spaced by AWS Service.
EC2 Per-Instance Metrics

CPUUtilization
DiskReadOps
DiskWriteOps
DiskReadBytes
DiskWriteBytes
NetworkIn
NetworkOut
NetworkPacketsIn
NetworkPacketsOut

# Ce que EC2 ne monitore PAS nativement :
Métrique                Disponible ?    Solution
CPUUtilization          ✅ Oui          Natif
NetworkIn/Out           ✅ Oui          Natif
DiskRead/Write          ✅ Oui          Natif
RAM/Memory              ❌ Non          CloudWatch 
AgentDisk Space         ❌ Non          CloudWatch Agent
Swap Usage              ❌ Non          CloudWatch Agent
Règle clé pour l'examen : la mémoire RAM n'est pas une métrique EC2 native — il faut installer le CloudWatch Agent pour la surveiller.

# Custom Metrics and High Resolutions
Cheat sheets, Practice Exams and Flash cards 👉 www.exampro.co/ssa-c03
You can publish your own Custom Metrics using the AWS CLI or SDK.
bash
aws cloudwatch put-metric-data \
  --metric-name Enterprise-D \
  --namespace Starfleet \
  --unit Bytes \
  --value 231213412 \
  --dimensions HullIntegrity=100, Shield=70, Thrusters=maximum
High Resolution Metrics
When you publish a custom metric, you can define the resolution as either:

standard resolution (1 minute)
high resolution (> 1 minute to 1 second)

With High Resolution you can track in intervals of:

1 second
5 seconds
10 seconds
30 seconds
multiple of 60 seconds.

# CloudWatch – Availability of Data
When an AWS Services emits data to CloudWatch the availability of the data varies based on the AWS Service:
                        EC2                     Other Services          
Basic Monitoring        5 minute interval       1 minute / 3 minute / 5 minute
Detailed Monitoring     1 minute interval       N/A

Majority of AWS services data availability is 1 minute

Points clés à retenir :
                EC2 Basic       EC2 Detailed            Autres services
Intervalle      5 min           1 min                   1 min (majoritaire)
Coût            ✅ Gratuit      💰 Payant              Inclus
Activation      Par défaut      Manue                   lPar défaut

Règles pour l'examen :

EC2 Basic = 5 minutes par défaut — gratuit
EC2 Detailed = 1 minute — payant, à activer manuellement
Autres services AWS = 1 minute par défaut pour la majorité
Si tu as besoin de métriques EC2 plus fréquentes que 1 min → Custom Metrics High Resolution

CloudWatch Agent and Host Level Metrics
Some metrics you might think are tracked by default for EC2 instances are not, and require installing the CloudWatch Agent.
Host Level Metrics
These are what you get without installing the Agent :

CPU Usage
Network Usage
Disk Usage
Status Checks

Underlying Hypervisor status
Underlying EC2 instance status



Agent Level Metrics
These are what you get when installing the Agent :

Memory utilization
Disk Swap utilization
Disk Space utilization
Page file utilization
Log collection

The CloudWatch Agent is also used to collect various logs from an EC2 instance and send them to a CloudWatch Log Group.

Règle examen : si la question mentionne RAM ou Disk Space sur EC2 → réponse = CloudWatch Agent.

CloudWatch Agent – Log Collection
The CloudWatch Agent can send logs running on your EC2 instance to a CloudWatch Log Group.
To send logs:

the Agent Configuration needs to be updated to include the logs
the CloudWatch Agent service needs to be restarted.

The Agent's configuration file is located at /etc/awslogs/awslogs.conf
ini
[exampro_application_log]
log_group_name = /exampro/rails/logs/production
log_stream_name = {instance_id}
datetime_format = %Y-%m-%dT%H:%M:%S.%f
file = /var/www/my-app/current/log/production.log*
You specify the location of the log file and what log group you want the log to be sent to.

# Restart CloudWatch Agent so it will send the added log files

bash
sudo service awslogsd stop
sudo service awslogsd start

# What is an Event Bus?
An event bus receives events from a source and routes events to a target based on rules
Event
  ↓
[Event Bus]
  ├── Rule → [Event][Event] → Target
  └── Rule → [Event][Event][Event][Event] → Target
EventBridge is a serverless event bus service that is used for application integration by streaming real-time data to your applications.
