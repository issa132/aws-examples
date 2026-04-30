# docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/SQS/Client.html
# docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/SQS/Client.html#send_message-instance_method
require 'aws-sdk-sqs'

client = Aws::SQS::Client.new

queue_url = "https://sqs.ca-central-1.amazonaws.com/982383527471"
resp = client.send_message({
  queue_url: queue_url,
  message_body: "Hello Ruby!", # required
  delay_seconds: 1,
  message_attributes: {
    "Fruit" => {
      string_value: "Apple",
      data_type: "String", # required
    },
  }
})