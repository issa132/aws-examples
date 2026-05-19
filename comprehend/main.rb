require 'aws-sdk-comprehend'
require 'pry'

client = Aws::Comprehend::Client.new
text = "Hello World! This is Andrew Brown, doing a test with Comprehend"

resp = client.detect_sentiment({
  text: text,
  language_code: 'en'
})
# binding.pry
puts resp.sentiment
