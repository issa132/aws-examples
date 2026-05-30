require 'aws-sdk-translate'
client = Aws::Translate::Client.new

text = "Hello, This is Andrew Brown, Utilizing Amazon Translate."
resp = client.translate_text({
  text: text,
  source_language_code: "en", # required
  target_language_code: "es" #, # required
#  settings: {
#    formality: "FORMAL", # accepts FORMAL, INFORMAL
#    profanity: "MASK", # accepts MASK
#    brevity: "ON", # accepts ON
#  },
})

puts resp.translate_text
