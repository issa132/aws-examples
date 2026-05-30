# AWS Glue

AWS Glue serverless data integration service that makes it easy for analytics users to discover, prepare, move, and integrate data from multiple sources.
Use cases for:

    Analytics
    machine learning
    application development

discover and connect to more than 70 diverse data sources and manage your data in a centralized data catalog.
Visually create, run, and monitor extract, transform, and load (ETL) pipelines to load data into your data lakes
Immediately search and query cataloged data using:

    Amazon Athena
    Amazon EMR
    Amazon Redshift Spectrum

What it can do:

    Data discovery
    Modern ETL or ELT
    Cleansing
    Transforming
    Centralized cataloging

# There are three engines for AWS Glue Jobs:

    Python Shell Engine
    Ray Job
    Spark Job

AWS Glue Jobs can be create in:

    Visual ELT (AWS Glue Studio)
    Jupyter Notebooks
    Script Editor (within AWS)

AWS Glue ETL jobs are charged based on the number of data processing units (DPUs)
AWS Glue allocates 10 DPUs to each Spark job
2 DPUs to each Spark Streaming job.
AWS Glue allocates 6 M-DPUs to each Ray job
A combination of Work Type and Number of Workers will determine DPUs

# AWS Glue Studio
 
AWS Glue Studio allows to visually build ETL pipelines.
Also known as the Visual ETL

# A pipeline is composed of nodes:
Sources:

    The data you plan to use

Transforms:

    What you want to do to the data

Targets:

    Where you want to send the data

You can version control your pipelines using:

    AWS Code Commit
    GitHub
    GitLab
    BitBucket

AWS Glue Studio is for visually preparing a Glue Job with little to no coding

# The Visual ETL will produce a python script that you can download and execute using python to run the script in your ELT tool or it will be used a job via AWS Glue jobs
You'll have to install the required AWS Glue Libraries
https://github.com/awslabs/aws-glue-libs

# AWS Glue Data Catalog
 
AWS Glue Data Catalog is a fully managed, Apache Hive Metastore-compatible catalog service that makes it easy for customers to store, annotate, and share metadata about their data.
Data Catalog is serverless, so its pay what you use.
AWS Glue Data Catalog integrates with:

    Amazon S3
    Amazon RDS
    Amazon Redshift
    Amazon Athena
    AWS Glue ETL
    Amazon EMR

AWS Glue database is a container for multiple AWS Glue tables
AWS Glue table is the metadata definition that represents your data, including its schema. A table can be used as a source or target in a job definition.

AWS Glue Crawler can discover schema formats to define your AWS Glue tables.

There are two table formats:

Standard AWS Glue table

    You must specific the data format:

        Avro, CSV, Json, XML, Parquet, ORC

    Data can be sourced from:

        Amazon S3, Kinesis, Kafka


Apache Iceberg table

    Uses its own expressive SQL data format



# AWS Glue Data Catalog – Crawlers
AWS Glue Data Crawler is a tool that is used to analyze a targeted data source to determine its schema and generate AWS Glue Data Tables.
Data Sources that Data Crawler can be connected to:

Amazon S3
Java Database Connectivity (JDBC)

    Amazon RedShift
    Snowflake
    Amazon RDS

DynamoDB
MongoDB Client

    MongoDB server, MongoDB Atlas, DocumentDB

Delta Lake
Apache Iceberge Tables stored in S3
Hudi Tables stored in S3

Data Crawler can run on a scheduleData Crawler can run on a schedule
Data Crawlr can be run on demand

# S3 Bucket
aws s3 mb s3://glue-data-catalog-6163

# Download Data File

We can get data from here:

https://catalog.data.gov/dataset/electric-vehicle-population-data

```sh
curl https://data.wa.gov/api/views/f6w7-q2d2/rows.csv?accessType=DOWNLOAD -o data/vehicle.csv
curl https://data.wa.gov/api/views/f6w7-q2d2/rows.csv?accessType=DOWNLOAD -o vehicle.csv
```

# Upload data to S3 bucket

```sh
aws s3 cp data/vehicle.csv s3://glue-data-catalog-6163/data/vehicle.csv
```

# AWS Glue Database

```sh
aws glue create-database --database-input Name=mydatabase
```

# Create IAM Role
aws iam create-role \
--role-name MyGlueServiceRole \
--assume-role-policy-document file://json/trust-policy.json

# aws iam put-role-policy \
--role-name MyGlueServiceRole \
--policy-name MyS3AccessPolicy \
--policy-document file://json/policy.json

# aws iam attach-role-policy \
--role-name MyGlueServiceRole \
--policy-arn arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole


# Create Glue Crawler

https://awscli.amazonaws.com/v2/documentation/api/latest/reference/glue/create-crawler.html
docs.aws.amazon.com/glue/latest/dg/crawler-configuration.html


aws glue create-crawler \
--name my-on-demand-crawler \
--role MyGlueServiceRole \
--database-name mydatabase \
--targets '{"S3Targets": [{"Path": "s3://mybucket/path/to/csv/"}]}' \
--table-prefix mycrawler_ \
--classifiers []

