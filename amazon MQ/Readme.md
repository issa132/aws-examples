# Amazon MQ
 
Amazon MQ is a managed message broker service for the opensource projects Apache ActiveMQ and RabbitMQ.

Active MQ is a powerful open-source messaging server that supports a wide range of protocols including AMQP, MQTT, STOMP, and JMS, offering robust features for JMS-centric, enterprise-integrated messaging scenarios.
Amazon MQ ActiveMQ supports: JMS, NMS, AMQP 1.0, STOMP, MQTT, and WebSocket

RabbitMQ is a highly reliable, scalable, and flexible messaging broker that supports advanced messaging protocols like AMQP, MQTT, and STOMP, making it ideal for complex routing scenarios and high-throughput requirements.
Amazon MQ RabbitMQ supports: AMQP 0-9-1

Amazon MQ vs SQS/SNS :
                Amazon MQ                               SQS / SNS          
Type            Broker géré (ActiveMQ/RabbitMQ)         Service AWS natif
Protocoles      AMQP, MQTT, STOMP, JMS...               API AWS propriétaire
Cas d'usage     Migration d'apps existantes             Applications cloud-native
Compatibilité   Standards ouverts                       AWS uniquement
Règle simple : si tu migres une application existante qui utilise déjà RabbitMQ ou ActiveMQ → utilise Amazon MQ. Si tu construis une nouvelle app sur AWS → utilise SQS/SNS.

Amazon MQ has a similar offering to SQS however MQ can handle more complex delivery rules with different performance garuntees
En résumé : SQS = simplicité et scalabilité massive. Amazon MQ = flexibilité et compatibilité avec des systèmes de messagerie existants.

# AMQP (Advanced Message Queuing Protocol) is an open standard wire-level protocol designed for messaging middleware that enables conforming client applications to communicate with conforming messaging middleware servers.

Explication simple :
Terme                       Signification
Open standard               Protocole ouvert, non propriétaire — n'importe qui peut l'implémenter
Wire-level protocol         Définit exactement comment les octets sont transmis sur le réseau
Messaging middleware        Logiciel intermédiaire (ex: RabbitMQ, ActiveMQ) qui transporte les messages
Conforming client           Toute app qui respecte le standard AMQP peut communiquer avec n'importe quel serveur AMQP
Analogie : AMQP est au messaging ce que HTTP est au web — un protocole standard que tout le monde peut utiliser, peu importe le langage ou la plateforme.       

# Messages are published to Exchanges
Exchanges distribute message copies to Queues using rules called Bindings
The Broker pushes messages to the subscribed consumers

Or the consumers pull messages from the queues


Messages can have metadata attached to them
Messages are only removed from the queue when a consumers ACKS the broker

    ACK is short for acknowledgement.



There are four types of exchanges:

Direct exchange (default)
Fanout exchange
Topic exchange
Headers exchange

# MQTT
MQTT (MQ Telemetry Transport) is a light-weight pub/sub messaging protocol. MQTT uses minimal network bandwidth and often used in Internet of Things (IoTs) or real-time messaging apps. Suitable for machine-to-machine (M2M) communication.

Cas d'usage typiques MQTT :

IoT — capteurs de température, objets connectés
M2M — communication entre machines sans intervention humaine
Temps réel — chat, notifications, tracking GPS
Réseaux instables — fonctionne même avec peu de bande passante (ex: réseaux mobiles 2G/3G)

En résumé : MQTT = protocole idéal quand les ressources sont limitées et la connexion instable.

# STOMP (Simple Text Oriented Messaging Protocol) is a simple, text-based wire-protocol that allows clients to communicate with almost any message broker.

👆 EASY: STOMP is so simple that it can be used with a telnet client.
En résumé : STOMP = le protocole le plus simple à utiliser, lisible par un humain, idéal pour tester ou déboguer rapidement une connexion à un broker de messages.
Un message broker est un intermédiaire qui reçoit, stocke et distribue des messages entre des applications.


# github.com/ruby-amqp/bunny

Bunny est la bibliothèque Ruby la plus populaire pour communiquer avec RabbitMQ via le protocole AMQP. C'est l'équivalent Ruby de ce que Shoryuken est pour SQS.


# Comparaison MQTT vs AMQP (Bunny) :
            MQTT                            AMQP (Bunny)
Concept     Topic                           Exchange + Queue
Connexion   MQTT::Client.connect            Bunny.new + connection.start
Envoi       client.publish(topic, message)  exchange.publish(msg, routing_key:)
Simplicité  ✅ Plus simple                  Plus verbeux
Cas d'usage IoT, M2M                        Enterprise messaging

dans le gemfile on ecrit: 
gem 'mqtt'
gem 'bunny'
gem 'stomp'
gem 'ox'
gem 'pry'


# github.com/njh/ruby-mqtt
# github.com/stompgem/stomp
# meschbach.com/kb/simple-ruby-stomp-client.html