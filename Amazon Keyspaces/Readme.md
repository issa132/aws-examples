# Amazon Keyspaces
Amazon Keyspaces is a fully managed Apache Cassandra database. Cassandra is an open-source NoSQL key/value database similar to DynamoDB in that is columnar store database but has some additional functionality. When you want to use Apache Cassandra.

Cluster — a collection of nodes
Nodes — holds 2 – 4 TB of data
    All nodes read and write
    Nodes represent smallest unit of a database
    Data is replicated on multiple nodes

Ring — Nodes are arranged in a ring where all nodes connect to each other
Keyspace — a namespace that specifies data replication on nodes
Table — tabular data of columns and rows with a primary key
    Cassandra is queried using the Cassandra Query Language (CQL)
    Interacting with Cassandra is typically performed via an SDK in your programming language of choice
Amazon Keyspaces allows you to perform the following the AWS Management Console:
    Create Keyspaces
    Create Tables
    CQL editor (query via the UI)

# Cassandra Query Language
Cassandra Query Language (CQL) is a language similar to SQL and the primary language to interact with a Cassandra database.

Create Keyspace
sql
CREATE KEYSPACE IF NOT EXISTS exampleKeyspace
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3};

Create Table
sql
CREATE TABLE IF NOT EXISTS exampleKeyspace.users (
  user_id uuid PRIMARY KEY,
  first_name text,
  last_name text,
  email text
);

Insert Data
sql
INSERT INTO exampleKeyspace.users (user_id, first_name, last_name, email)
VALUES (uuid(), 'John', 'Doe', 'johndoe@example.com');

Query Data
sql
SELECT *
FROM exampleKeyspace.users
WHERE user_id = 12345678-1234-5678-1234-567812345678;

Update Data
sql
UPDATE exampleKeyspace.users
SET first_name = 'Jane'
WHERE user_id = 12345678-1234-5678-1234-567812345678;

# 
CREATE TABLE "mykeyspaces2"."users"(
  "id" int,
  "first_name" ascii,
  "last_name" ascii,
  PRIMARY KEY(("id"))
)
WITH CUSTOM_PROPERTIES = {
  'capacity_mode': {
    'throughput_mode': 'PAY_PER_REQUEST'
  },
  'point_in_time_recovery': {
    'status': 'enabled'
  },
  'encryption_specification': {
    'encryption_type': 'AWS_OWNED_KMS_KEY'
  }
}

INSERT INTO mykeyspaces2.users (id, first_name, last_name) VALUES (1, 'Andrew', 'Brown');

# What is a Graph Database?
A graph database is a database composed of a data structure that uses vertices (nodes, dots) which form relationship to other vertices via edges (arcs, lines)

Use Cases for Graph Database:

    Fraud detection
    Real-time recommendation engines
    Master data management (MDM)
    Network and IT operations
    Identity and access management (IAM)
    Traceability in Manufacturing
    Contact Tracing
    Data Lineage for GDPR
    Customer 360-degree analysis (marketing)
    Product recommendations
    Social Media graphing
    Feature Engineering (ML)

