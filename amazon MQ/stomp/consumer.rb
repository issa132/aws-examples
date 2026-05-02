require 'stomp'

login = ''
passcode = ''
host = ''
port = ''

#onfig = {
# hosts: [
#   login: login,
#   passcode: passcode,
#   host: host,
#   port: port,
#   ssl: false
# ]
# }

connection_string = 'stomps://admin:Testing123456!@b-6b39d23f-d358-4850...'

#client = Stomp::Client.new(config)
client = Stomp::Client.new(connection_string)
client.subscribe(dest) do |message|
  client.acknowledge(message)
end

