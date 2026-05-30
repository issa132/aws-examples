require 'aws-sdk-textract'
require 'pry'

client = Aws::Textract::Client.new region: 'ca-central-1'
bucket = 'textract-exp-41241'
name = 'tax-doc.png'

client = Aws::Textract::Client.new 
resp = client.analyze_document({
  document: { # required
    # bytes: "data",
    s3_object: {
      bucket: "S3Bucket", #bucket
      name: "S3ObjectName", #name
      version: "S3ObjectVersion",
    },
  },
  feature_types: ["TABLES"], # required, accepts TABLES, FORMS, QUERIES, SIGNATURES, LAYOUT
#  human_loop_config: {
#    human_loop_name: "HumanLoopName", # required
#    flow_definition_arn: "FlowDefinitionArn", # required
#    data_attributes: {
#      content_classifiers: ["FreeOfPersonallyIdentifiableInformation"], # accepts FreeOfPersonallyIdentifiableInformation, FreeOfAdultContent
#    },
#  },
#  queries_config: {
#    queries: [ # required
#      {
#        text: "QueryInput", # required
#        alias: "QueryInput",
#        pages: ["QueryPage"],
#      },
#    ],
#  },
#  adapters_config: {
#    adapters: [ # required
#      {
#        adapter_id: "AdapterId", # required
#        pages: ["AdapterPage"],
#        version: "AdapterVersion", # required
#      },
#    ],
#  },
})

# to see the result
binding.pry 