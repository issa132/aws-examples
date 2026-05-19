# Amazon Athena


Amazon Athena is an interactive query service that makes it easy to analyze data directly from S3

Athena is based off the open-source distributed query engine Apache Presto

Athena can do two things:

Athena SQL: lets you run SQL queries on S3 Buckets
    Athena uses Tinro SQL which is a fork of Apache Presto
    Can commonly access via the AWS Management console to enter queries
    JDBC or ODBC drivers to interact with Athena
    Query with the AWS CLI or AWS SDKs

Apache Spark on Amazon Athena: also interactively run data analytics using Apache Spark
    Access via Jupyter compatible notebooks with Apache Spark

Athena is serverless so you only pay for what you use.

Athena integrates with the following AWS services:

CloudFormation, CloudFront, CloudTrail, DataZone, ELB, EMR, AWS Glue Data Catalog, IAM, QuickSight, S3 Inventory, Step Functions, Systems Manager Inventory, VPC

# Athena SQL Components
 

    Workgroup — saved queries which you grant permissions to other users to access
    Data source – a group of databases (sometimes called a catalog)
    Database – a group of tables (sometimes called a schema)
    Table – data organized as a group of rows or columns
    Dataset — the raw data of the table

Data Definition Language (DDL)
    A subset of SQL to define schema.
    eg CREATE, ALTER, DROP
Data Manipulation Language (DML)
    A subset of SQL to manipulate datasets.
    eg. INSERT, UPDATE, DELETE
Data Query Language (DQL)
    A subset of SQL to select datasets.
    Ee. SELECT

The workflow for Athena is often to dump the query results to the destination S3 Bucket. (It means that when you run a query in Athena, the results are automatically saved/written to an S3 bucket that you specify.)

# Athena SQL — Table
 
Tables can be created two ways:

    Using SQL create table statement
    Using AWS Glue Wizard

Tables can be created automatically using AWS Glue crawler will crawl the data to produce a table schema.
Athena tables are AWS Glue Data Catalog tables and so they will exist in both services when creating an Athena table.
When you query FROM you'll use AWSDataCatalog
sqlSELECT *
FROM "AWSDataCatalog"."your_database_name"."your_table_name"
WHERE "your_column_name" = 'your_value'
LIMIT 10;
Tables are likely to be created in the default database called "default"
Using SQL you'll specify:

How to parse each row of data (possibly with regex)
Specific the location of the data.

sql
CREATE EXTERNAL TABLE IF NOT EXISTS cloudfront_logs (
    `Date` Date,
    Time STRING,
    Location STRING,
    Bytes INT,
    RequestIP STRING,
    Method STRING,
    Host STRING,
    Uri STRING,
    Status INT,
    Referrer STRING,
    OS String,
    Browser String,
    BrowserVersion String
) ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
"input.regex" = "^(?!#)([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)\\s+([^ ]+)[^\(]+][^)]*).*(.*$"
) LOCATION 's3://athena-examples-MyRegion/cloudfront/plaintext/';

# 13:31
Athena SQL — SerDe
 

SerDe is a serialization and deserialization libraries for parsing data from different data formats, such as CSV, JSON, Parquet, and ORC

It is the SerDe you specify, and not the DDL, that defines the table schema.
In other words, the SerDe can override the DDL configuration that you specify in Athena when you create your table.

There are several built-in SerDe supported by Athena.

sql
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe' # csv
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde' # csv
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' # avro
ROW FORMAT SERDE 'com.amazonaws.glue.serde.GrokSerDe' # grok
ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe' # json
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe' # json
ROW FORMAT SERDE 'com.amazon.ionhiveserde.IonHiveSerDe' # json
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe' # regex
STORED AS ORC # ORC
STORED AS PARQUET # Parquet

# 13:34
Amazon CodeGuru

Cheat sheets, Practice Exams and Flash cards 👉 www.exampro.co/ssa-c03

Amazon CodeGuru is a machine-learning code analysis service. CodeGuru performs code-reviews and will suggest changes to improve the quality of code. It can show visual code profiles (show the internals of your code) to pinpoint performance.

CodeGuru has three services:

    CodeGuru Security — detect, track and fix code security issues in code
        Code Security Analytics Scan
        Code Quality Analytics Scan
        Secrets Detection Scan
CodeGuru Profiler — find and fix inefficacies in code
CodeGuru Reviewer — associate a repo for continuous code change recommendations

CodeGuru supports the following languages:

    Java
    JavaScript
    Python
    C#
    TypeScript
    Ruby
    Go
    IaC
    CloudFormation
    Terraform
    AWS SDK (TypeScript or Python)

GitHub Actions is used to automate continuous checks for GitHub repos.

# https://github.https://github.com/aws-samples/aws-codeguru-profiler-demo-application

# AWS CodeStar:  AWS CodeStar Quickly develop, build, and deploy applications on AWS

# Amazon Comprehend
 
Amazon Comprehend is a Natural Language Processor (NLP) service.
Find relationships between text to produce insights.
Looks at data such as Customer emails, support tickets, social media and makes predictions

Amazon Comprehend can analyze text and extract the following:

    Entities — eg. Person, Organization, Location
    Key Phrases — Text the appears important eg. You need to pay the amount of $220.00 by August 8
    Language — eg. confidence of the language being spoken eg. English
    PII (Personally identifiable information) — eg. Eg. Andrew Brown, andrew@exampro.co
    Sentiment — attitude towards the text — eg. 0.20 Negative
    Targeted sentiment — specific words and their attitude eg. Awful 1.0 Negative
    Syntax — identity parts of a language eg. Hello Proper Noun
    Custom Models — upload your training data to analyze and extra custom text.

        Amazon Comprehend Flywheel — automates the training of model versions for custom models.


    Amazon Comprehend is Serverless and you pay based on Size of request in units eg. 1 unit = 100 characters
    Real-time analysis can be performed via a endpoint (or custom endpoint for custom models)
    Analysis jobs allow for batch jobs

