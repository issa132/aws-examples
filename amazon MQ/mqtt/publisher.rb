require 'mqtt'

host = 'mqtts://admin:Testing123456!@b-6b39d23f-d358-4850-bfd4-a7784795fa05-1.mq.us-east-1.amazonaws.com:8883'
#host = 'localhost' # Adresse du broker MQTT
topic = 'test/topic' # Topic de publication (chemin hiérarchique)
message = "Hello World! MQTT"

begin
  MQTT::Client.connect(host) do |client| # Connexion au broker
    client.publish(topic, message) # Publie le message sur le topic
  end
rescue => e # Gestion d'erreur
  puts e.inspect
end

