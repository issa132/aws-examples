# Amazon Kendra
Cheat sheets, Practice Exams and Flash cards 👉 www.exampro.co/ssa-c03
Amazon Kendra is a enterprise machine learning search engine service. Uses natural language to suggest answers to question instead of just simple keyword matching

Instead of keyword-based search, Amazon Kendra uses semantic and contextual understanding capabilities to a search query. Its like interacting with a human.

Amazon Lex chatbot can be used as an interface to Amazon Kendra
Amazon Kendra has the following components:

    Index — a table that holds the index of your documents to make it searchable
    Data Source — Where your documents are stored eg. S3, Sharepoint, Box, Postgres, you need to define a schema.

         Data Source Template Schemas — AWS provides around 40 schema templates for common AWS services or third-party cloud storage services

    Document Addition API — An API to add documents directly to an index



# Create Index

bash
aws kendra create-index \
--name my-index \
--description "My Index" \
--role-arn arn:aws:iam::123456789012:role/KendraRoleForMyIndex
--engine???
# pour le --role-arn ici tu dois creer un kendra role
# Create a Data Source

bash
aws kendra create-data-source \
  --index-id index id \
  --name data source name \
  --role-arn arn:aws:iam::123456789012:role/KendraRoleFordDataSource \
  --type S3 \
  --configuration '{"S3Configuration":{"BucketName":"my-bucket "}}'
# different data source would use a template to defined the schema
# --type TEMPLATE \
# --configuration '{"TemplateConfiguration":{"Template":{JSON schema}}}'

# Sync the data source to the Index (update the index)
bash
aws kendra start-data-source-sync-job \
  --id <data_source_id> \
  --index-id <index_id>


# Query Kendra Index for results
bash
aws kendra query \
  --index-id <index_id> \
  --query-text "Do you have any afforadble self sealing stem bolts for purchase?"

# https://docs.https://docs.aws.amazon.com/kendra/latest/dg/iam-roles.html#iam-roles-index
# https://awscli.https://awscli.amazonaws.com/v2/documentation/api/latest/reference/kendra/create-index.html


## Create bucket

aws s3 mb s3://kendra-exp-223 --region us-east-1

## Creating our Index
sh
aws kendra create-index \
--edition DEVELOPER_EDITION \
--name my-index \
--description "My Index" \
--region us-east-1 \
--role-arn arn:aws:iam::982383527471:role/KendraIndexRole


## Creating our Data Source

aws kendra create-data-source \
--index-id 62b0d9f1-b38b-44a6-8152-ff7427fdff08 \
--name my-data-source \
--role-arn arn:aws:iam::982383527471:role/KendraDataSourceRole \
--type S3 \
--configuration '{"S3Configuration":{"BucketName": "kendra-exp-223"}}' \
--region us-east-1

# https://docs.aws.amazon.com/kendra/latest/dg/index-document-types.html

# oliver twist book
# https://e-school.kmutt.ac.th/elibrary/Upload/EBook/DSIL_Lib_E1312881157.pdf

aws s3 cp oliver-twist.pdf s3://kendra-exp-223 --region us-east-1

## sync 
aws kendra start-data-source-sync-job \
--id e3ceb99f-8574-4ff7-95c7-2e113c2ffc75 \
--index-id 62b0d9f1-b38b-44a6-8152-ff7427fdff08 \
--region us-east-1



aws s3 sync . s3://kendra-exp-223 --region us-east-1