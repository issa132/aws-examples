require 'mqtt'

host = 'localhost' # Adresse du broker MQTT
topic = 'test/topic' # Topic de publication (chemin hiérarchique)
message = "Hello World! MQTT"

begin
  MQTT::Client.connect(host) do |client| # Connexion au broker
    client.publish(topic, message) # Publie le message sur le topic
  end
rescue => e # Gestion d'erreur
  puts e.inspect
end

