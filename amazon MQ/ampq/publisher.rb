require 'bunny'

connection = Bunny.new #Crée une connexion RabbitMQ (localhost par défaut)
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