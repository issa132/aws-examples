AWS Database Migration Service (DMS) allows you to quickly and securely migrate one database to another. DMS can be used to migrate your on-premise database to AWS.
Possible Sources:

Oracle Database
Microsoft SQL
MySQL
MariaDB
PostgreSQL
MongoDB
SAP ASE
IMDB Db2
Azure SQL Database
Amazon RDS
Amazon S3 (database dumps)
Amazon Aurora
Amazon DocumentDB

Possible Targets:

Oracle Database
Microsoft SQL
MySQL
MariaDB
PostgreSQL
Redis
SAP ASE
Amazon Redshift
Amazon RDS
apache kafka

How it works:
Source database → Source endpoint → Replication task → Target endpoint → Target database
AWS Schema Conversion is used in many cases to automatically convert a source database schema to a target database schema.
For data warehouses you can use the desktop app AWS Schema Conversion Tool.

# Migration Methods
Homogenous data migration

    Migrate data with native database tools. Eg. pg_dump, pg_restore
    You create a migration project in DMS and it will perform the migration using a serverless compute

        Uses a pay as you go model

Instance Replication

    Provision an instance with chosen instance type to perform the replications between databases

Serverless Replication (DMS Serverless)

    A serverless offering where you pay as you go, with some limitations:

        Does not have public IPs
        Must use VPC endpoints to access specific AWS services. Eg. S3, Kinesis, DynamoDB, OpenSearch
        Limited selection of possible sources and targets
        Doesn't support views with selection and transformation rules

# tableplus.com

# An endpoint is simply an address or connection point that allows two systems to communicate with each other.
Think of it like a door — it's the specific entry/exit point where data goes in or comes out.

In different contexts:
In databases (like DMS):

The source endpoint = the address/credentials of the database you're copying FROM
The target endpoint = the address/credentials of the database you're copying TO
Example: my-database.us-east-1.rds.amazonaws.com

In APIs:

A URL that your app calls to get or send data
Example: https://api.example.com/users — this is an endpoint that returns a list of users

In networking:

Any device or address that is the final destination of communication
Example: your laptop, a server, a load balancer

In AWS:

A URL or connection point for an AWS service
Example: an S3 endpoint, a VPC endpoint, an RDS endpoint
Simple analogy:

Think of a restaurant. The endpoint is the front door — it's the specific place where customers (requests) enter and food (responses) comes out. Without the door, you can't get in or out.

# docs.aws.amazon.com/dms/latest/userguide/CHAP_Tasks.CustomizingTasks.TableMapping.SelectionTransformation.Selections.html

# create policies that can capture everything from the bucket: 
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement1",
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::dms-migration-45646",
        "arn:aws:s3:::dms-migration-45646/*"
      ]
    }
  ]
}

# then create a role and attach it to the policie
AWS Schema Conversion Tool
AWS Schema Conversion Tool (AWS SCT) is a stand-alone desktop app to convert your database schema to another database engine.
AWS SCT can be installed on:

Windows
Linux (Fedora or Ubuntu)
Mac (Not available for Mac)