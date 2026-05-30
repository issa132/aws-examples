# Amazon Translate neural machine learning text translation service. Uses deep learning models to deliver more accurate and natural sounding translations.
Processing modes:

    Real-time translation
    Async batch processioning
    Give it text
    Choose a source language
    Choose a target language

ruby
client = Aws::Translate::Client.new

text_to_translate = "Hello, how are you?"
begin
  response = client.translate_text({
    text: text_to_translate,
    source_language_code: 'en',
    target_language_code: 'es'
  })
  puts "Translated Text: #{response.translated_text}"
rescue Aws::Translate::Errors::ServiceError => e
  puts "Error translating text: #{e.message}"
end

# aws sts get-caller-identity
# docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/Translate/Client.html


# gem file

source "https://rubygems.org"

# gem "rails"
gem "aws-sdk-translate"
gem 'pry'
gem 'nokogiri'

resp 
resp.translate_text




