# Amazon Textract
Amazon Textract is a OCR (extract text from scanned documents) service. When you have paper forms, and you want to digitally extract the data.
Textract can:

    OCR documents

        Can retain layout coordinates
        Convert to a table
        Detect forms
        Query against the OCR data
        Detect signatures


    OCR expenses eg. Receipts
    Analyze IDs (driver licenses or passports)
    Analyze Lending (mortgage documents)
    Custom Queries — train your own models with uploaded samples

Voici un exemple :
ruby
textract_client = Aws::Textract::Client.new
bucket_name = 'your-bucket-name'
document_name = 'your-document-name'

begin
  response = textract_client.analyze_document(
    document: {
      s3_object: {
        bucket: bucket_name,
        name: document_name
      }
    },
    # Specify the features you want to analyze
    feature_types: ['TABLES', 'FORMS']
  )
  puts response.to_h
rescue Aws::Textract::Errors::ServiceError => e
  puts "Error calling Amazon Textract:"
  puts e.message
end
Il s'agit d'un exemple d'analyse de document avec le AWS Ruby SDK V3, utilisant le service Amazon Textract pour extraire des tableaux et des formulaires depuis un fichier stocké dans S3.

# Gemfile 
# frozen_string_literal: true

source "https://rubygems.org"

# gem "rails"
gem 'aws-sdk-textract'
gem 'ox'
gem 'pry'


# docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/Textract/Client.html

aws s3 mb s3://textract-exp-41241 --region ca-central-1
aws s3 cp tax-doc.png s3://textract-exp-41241

# docs.aws.amazon.com/textract/latest/dg/API_HumanLoopConfig.html