require 'stomp'

login = 'admin'
passcode = 'Testing123456!'
host = 'b-6b39d23f-d358-4850-bfd4-a7784795fa05-1.mq.us-east-1.amazonaws.com'
port = 61614

config = {
  hosts: [
    login: login,
    passcode: passcode,
    host: host,
    port: port,
    ssl: false
  ]
}

# str = 'stomp+ssl://admin:Testing123456!@b-6b39d23f-d358-4850-bfd4-a7784795fa05-1.mq.us-east-1.amazonaws.com:'

# client = Stomp::Client.new(str)
client = Stomp::Client.new(config)


dest = '/queue/test'
client.publish(dest, "Hello World! STOMP!")
client.close