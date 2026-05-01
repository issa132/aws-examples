# Introduction to SQS
What is a Messaging System?
Used to provide asynchronous communication and decouple processes via messages / events
From a sender and receiver ( producer and consumer)
What is a Queueing System?
A Queueing system is a messaging system that generally will delete messages once they are consumed.
Simple communication. Not Real-time. Have to pull. Not reactive.
Simple Queueing Service (SQS)
Fully managed queuing service that enables you to decouple and scale microservices, distributed systems, and serverless applications
Use Case: You need to queue up transaction emails to be sent e.g. Signup, Reset Password.

# SQS – Use Case

App publishes messages to the queue
Another app pulls the queue and finds the message, and does something
Another app reports that they completed their task and marks the message for completion
Original app pulls the queue and sees the message is no longer in the queue.

Both apps are using the AWS SDK to push messages and pull the queue.

# SQS – Sending Large Messages
To send large messages to SQS you can use the the libraries:

Amazon SQS Extended Client Library for Java/Python

https://github.com/awslabs/amazon-sqs-python-extended-client-lib
These libraries are useful for messages that are larger than the current maximum of 256 KB, with a maximum of 2 GB.
Both libraries save the actual payload to an S3 bucket, and publish the reference of the stored S3 object to the SNS topic.

import boto3
import sns_extended_client

sns = boto3.client('sns')
sns.large_payload_support = 'bucket-name'

# boto SNS.Topic resource
resource = boto3.resource('sns')
topic = resource.Topic('topic-arn')
platform_endpoint = resource.PlatformEndpoint('endpoint-arn')
platform_endpoint.large_payload_support = 'my-bucket-name'

# If you want to keep it always enabled.
platform_endpoint.always_through_s3 = True

# publish the large message
sns.publish(
  Message="message",
  MessageAttributes={
    "S3Key": {
      "DataType": "String",
      "StringValue": "--S3--Key--",
    },
  },
)


there is standard queue and FIFO queue

you cant convert a standard queue to a fifo queue

# SQS – FIFO Queue
AWS SQS First-In-First-Out (FIFO) guarantees the order of messages when being consumed
→ | 1 | 2 | 3 | 4 | 5 | →

Limited to 300 transactions per second (TPS)
Messages have a unique deduplication ID to ensure there are no duplicate messages in the queue

    Since there are no duplicates FIFO ensures Exactly-once processing


Messages are ordered based on Message Group Id.
To ensure order is preserved each Producer should use their own unique Message Group Id.
To request (poll) messages your Consumer has to specify a Message Group Id
Its possible to read upto 10 messages a time.
SQS FIFO manages data in partitions across multiple AZs, but its all managed for you by AWS.

    Each partition supports 3,000 messages per second with batching
    Or up to 300 messages per second for send, receive, and delete operations

# Sending message to a FIFO queue. Note that you have to provide:

message_group_id
Message_deduplication_id

ruby
require 'aws-sdk-sqs'

sqs_client = Aws::SQS::Client.new(region: 'us-west-2')

queue_url = 'https://sqs.us-west-2.amazonaws.com/123456789012/my-queue.fifo'

message_body = 'Hello, FIFO World!'
message_group_id = 'myMessageGroup1'
message_deduplication_id = 'myMessageDeduplicationId1'

begin
  sqs_client.send_message(
    queue_url: queue_url,
    message_body: message_body,
    message_group_id: message_group_id,
    message_deduplication_id: message_deduplication_id
  )
  puts "Message sent to FIFO queue successfully."
rescue Aws::SQS::Errors::ServiceError => e
  puts "Error sending message to FIFO queue: #{e}"
end

# SQS – FIFO Queue
High Throughput can be enabled on SQS FIFO queue to allows for 3,000 messages per second with batching (10x greater than SQS FIFO queue without High Throughput)
To enable High Throughput you set FifoThroughputLimit=perMessageGroupId
bash
aws sqs set-queue-attributes \
--queue-url "https://sqs.ca-central-1.amazonaws.com/123456789012/my-queue.fifo" \
--attributes \
FifoQueue=true,\
ContentBasedDeduplication=true,\
DeduplicationScope="messageGroup"\
FifoThroughputLimit="perMessageGroupId"

# docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-function.html
# docs.aws.amazon.com/lambda/latest/dg/with-sqs-example-use-app-spec.html

# awscli.amazonaws.com/v2/documentation/api/latest/reference/sqs/index.html
# awscli.amazonaws.com/v2/documentation/api/latest/reference/sqs/send-message.html#examples

# docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-message-metadata.html#sqs-message-attributes
# awscli.amazonaws.com/v2/documentation/api/latest/reference/sqs/receive-message.html#examples
# awscli.amazonaws.com/v2/documentation/api/latest/reference/sqs/get-queue-attributes.html#examples
# awscli.amazonaws.com/v2/documentation/api/latest/reference/sqs/receive-message.html#output

bundle init
bundle install # install the gem 
bundle exec ruby send.rb
resp.messages
resp.messages.first.receipt_handle

# docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/SQS/Client.html#delete_message-instance_method
resp = client.delete_message({
  queue_url: "String", # required
  receipt_handle: "String", # required
})

# github.com/ruby-shoryuken/shoryuken
Il s'agit du lien vers le dépôt GitHub de Shoryuken, une bibliothèque Ruby populaire pour traiter les messages Amazon SQS de manière asynchrone, souvent utilisée comme alternative à Sidekiq mais pour SQS.

# Attribute-based access control (ABAC) is an authorization process that defines permissions based on tags that are attached to users and AWS resources.

SQS supports ABAC by allowing you to control access to your Amazon SQS queues based on the tags and aliases that are associated with an Amazon SQS queue.

Possible condition tags :

aws:ResourceTag
aws:RequestTag
aws:TagKeys

Example of denying production resources (tagged with prod) from sending, receiving or delete messages to a queue
json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAccessForProd",
      "Effect": "Deny",
      "Action": "sqs:*",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/environment": "prod"
        }
      }
    }
  ]
}

Cette politique IAM refuse toutes les actions SQS (sqs:*) sur les ressources taguées environment: prod, illustrant l'utilisation de l'ABAC pour protéger les environnements de production.

# SQS – Access Policy
Access Policy allows you grant to grant other principals permission to the SQS Queue.
Common actions :

SendMessage
ReceiveMessage
Delete Message

json{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowSNSPublish",
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:region:account-id:queue-name",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "arn:aws:sns:region:account-id:topic-name"
        }
      }
    }
  ]
}
Example of letting an SNS Topic send messages to the queue

Résumé : Cette politique permet à un topic SNS spécifique d'envoyer des messages (sqs:SendMessage) vers une file SQS, en vérifiant via la condition ArnEquals que la source est bien le bon topic SNS.


# SNS vs SQS
SNS (Simple Notification Service)
Push-based — envoie des messages à plusieurs destinataires simultanément
Caractéristique   Détail
Modèle            Pub/Sub (Publication/Abonnement)
Direction         1 → Plusieurs (fan-out)
Destinataires     SQS, Lambda, HTTP, Email, SMS...
Persistance       ❌ Pas de stockage — si personne n'écoute, le message est perdu
Livraison         Push (pousse vers les abonnés)

SQS (Simple Queue Service)
Pull-based — les consommateurs viennent chercher les messages
Caractéristique     Détail
Modèle              Queue (File d'attente)
Direction           1 producteur → 1 consommateur
Types               Standard (au moins 1 fois) / FIFO (exactement 1 fois)
Persistance         ✅ Stockage jusqu'à 14 jours
Livraison           Pull (le consommateur lit)

Comparaison directe
                SNS                     SQS
Modèle          Pub/Sub                 Queue
Livraison       Push                    Pull
Destinataires   Multiples               Un seul consommateur
Stockage        ❌ Non                 ✅ Oui (14 jours)
Ordre garanti   ❌ Non                 ✅ Oui (FIFO)
Cas d'usage   Notifications, alertes    Découplage, traitement asynchrone

Combinaison SNS + SQS (Fan-out)
Le pattern le plus courant en production :
         ┌──── SQS Queue A (traitement commandes)
SNS ─────┤
         └──── SQS Queue B (envoi emails)
SNS diffuse le message → chaque SQS le traite indépendamment à son rythme. C'est exactement ce que montre l'image précédente !

# SQS – Message Metadata

Message Metadata allows you to attach metadata to your SQS messages
Possible logical data types :

String
Number
Binary
Custom

Just append a custom-type label to any data type eg.

Number.byte, Number.short
Binary.gif, Binary.png






Commande CLI :
bash
aws sqs send-message \
  --queue-url "https://sqs.region.amazonaws.com/1234567890l2/my-queue" \
  --message-body "Your message text" \
  --message-attributes file://message-attributes.json
Fichier message-attributes.json :
json{
  "OrderID": {
    "DataType": "String",
    "StringValue": "123456789"
  },
  "CustomerEmail": {
    "DataType": "String",
    "StringValue": "customer@example.com"
  },
  "PurchaseDate": {
    "DataType": "String",
    "StringValue": "2024-03-16"
  },
  "IsPriority": {
    "DataType": "String",
    "StringValue": "true"
  },
  "OrderTotal": {
    "DataType": "Number",
    "StringValue": "99.99"
  },
  "OrderItems": {
    "DataType": "Binary",
    "BinaryValue": "T3JkZXJJdGVtc0JpbmFyeURhdGE="
  }
}

Résumé : Les métadonnées SQS permettent d'enrichir les messages avec des attributs structurés (String, Number, Binary) sans modifier le corps du message, utile pour le filtrage ou le routage.

# SQS – Visibility Timeout

Visibility timeout is a period of time message will be invisible after they are read/consumed by an application to avoid being read and processed by other applications.

Default : 30 seconds
Min : 0 seconds
Max : 43200 seconds (12 heures)

Set VisibilityTimeout via the AWS CLI :
bashaws sqs set-queue-attributes \
  --queue-url "https://sqs.region.amazonaws.com/123456789012/my-queue" \
  --attributes '{"VisibilityTimeout":"120"}'
a message is hidden only after it is consumed from the queue.

Comment ça fonctionne :
┌─────────────┐     1. Lit le message      ┌─────────────┐
│  SQS Queue  │ ─────────────────────────► │ Consommateur│
│             │                            │             │
│  [Message]  │ ◄─ Message invisible ─────►│  Traitement │
│  (caché)    │    pendant X secondes      │             │
└─────────────┘                            └─────────────┘
       │
       │ 2a. Traitement réussi → delete_message
       │ 2b. Timeout expiré → message redevient visible
       ▼
  Autres consommateurs peuvent le lire à nouveau
Cas d'usage : éviter qu'un message soit traité deux fois en parallèle par plusieurs workers.

# SQS – Delay Queues

Delay queues let you postpone the delivery of new messages to consumers for a number of second when your app needs more time.

👻 Any messages that you send to a delay queue remain invisible to consumers for the duration of the delay period.


Default Value : 0 seconds
Max Value : 900 seconds (15 minutes)
Standard queue : per-queue delay setting will only apply the new messages in the queue
FIFO queue : per-queue delay setting will apply to all messages in the queue

Set DelaySeconds via the AWS CLI :
bash
aws sqs set-queue-attributes \
  --queue-url "https://sqs.region.amazonaws.com/123456789012/my-queue" \
  --attributes '{"DelaySeconds":"60"}'

Différence avec le Visibility Timeout :
                Delay Queue               Visibility Timeout
Quand ?         À l'envoi du message      Après la lecture du message
Invisible pour  Tous les consommateurs    Autres consommateurs
Max             900 sec (15 min)          43200 sec (12h)
But             Retarder le traitement    Éviter le double traitement

Cas d'usage : attendre que l'application soit prête avant de traiter un message (ex: initialisation d'une ressource).

# SQS – Message Timers

Message Timers let you specify an initial invisibility period for an individual message when sending to the queue.
Set DelaySeconds via the AWS CLI :
bash
aws sqs send-message \
  --queue-url "https://sqs.region.amazonaws.com/123456789012/my-queue" \
  --message-body "Your message text" \
  --delay-seconds 10

🧑 Both Delay Queue and Message Timers use the property called DelaySeconds

FIFO queues don't support timers on individual messages.

Delay Queue vs Message Timers :
                    Delay Queue                         Message Timer   
Portée              Toute la queue                      Un seul message
Configuré sur       La queue (set-queue-attributes)     Le message (send-message)
FIFO support        ✅ Oui                             ❌ Non
Propriété           DelaySeconds                        DelaySeconds
Cas d'usage         Retard global uniforme              Retard personnalisé par message
En résumé : Message Timers = Delay Queue mais au niveau individuel du message, uniquement pour les queues Standard.
Niveau individuel du message:  Cela signifie que le délai s'applique message par message, et non à toute la queue.

# benefits of temporary queues:

serve as lightweight communication channels for specific threads or processes. (Créées pour un thread/processus spécifique, sans surcharge)
can be created and deleted without incurring additional cost. (Pas de coût supplémentaire à la création/suppression)
are API-compatible with static (normal) Amazon SQS queues. (Même API que les queues SQS normales — pas de code spécial)


Cas d'usage typique : le pattern Request/Response — une queue temporaire est créée pour recevoir la réponse d'une requête spécifique, puis supprimée une fois la réponse reçue.

# SQS – Short vs Long Polling
Polling is the method by which we retrieve messages from the queues.
Short Polling (default)                                                               Long Polling      
returns messages immediately, even if the message queue being polled is empty.        waits until message arrives in queue or till long poll timeout expires.
When you need a message right away                                                    When you need to save money by reducing how often you poll

WaitTimeSeconds determines polling :

Short Polling: 0 seconds
Long Polling: > 0 seconds
Max long polling is 20 seconds.


