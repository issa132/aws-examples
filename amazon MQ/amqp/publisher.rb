require 'bunny'

connection = Bunny.new #Crée une connexion RabbitMQ (localhost par défaut)
connection.start

connection_string = "amqps://admin:Testing123456!@b-7cc94b99-4432-4a9c-ae14-9ab61199a0d7.mq.us-east-1.amazonaws.com:5671"
connection = Bunny.new(connection_string)
connection.start


channel = connection.create_channel
queue = channel.queue('hello') # Déclare une queue nommée hello
exchange = channel.default_exchange

begin
  exchange.publish("Hello World!", routing_key: queue.name)  # Envoie le message "Hello World!" vers la queue hello
  channel.close
  connection.close
rescue => e
  puts e.inspect
  channel.close
  connection.close
  exit(0)
end