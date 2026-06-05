# Introduction to DynamoDB
What is NoSQL?
NoSQL is a database that is neither relational and does not use SQL to query the data for results

What is a Key/Value Store?
A form of data storage which has a key which references a value and nothing more

json
{Title: "S01E019 DS9 Duet"}
Key → Title
Value → "S01E019 DS9 Duet"

What is a Document Store?
A form of data storage which has a nested data structure

json
{
  Series: 'DS9',
  Episodes: [
    {
      Season: 1,
      Episodes: 19,
      Title: 'Duet'
    }
  ]
}
↑ Nested Data

DynamoDB is a NoSQL key/value and document database for internet-scale applications.

Features

  Fully managed
  Multi-region
  Multi-master
  Durable database
  Built-in security
  Backup and restore
  In-memory caching


Provisioned Capacity
Specify your read and write capacity per second. It just works at whatever capacity you need without tweaking anything.

Provides

  Eventual Consistent Reads (default)
  Strongly Consistent Reads

All data is stored on SSD storage and is spread across 3 different AZs. 

# Anatomy of DynamoDB
Term        Definition  
Tables      Tables contains rows and columns
Items       The rows of data
Attributes  The columns of data
Keys        Identifying names of your data (le nom des colonnes)
Values      The actual data itself

Example Table
IMDB ID (Key)   Year    Title 
tt0079945       1979    Star Trek: The Motion Picture

## DynamoDB – Read Consistency
Data is stored across 3 Availability Zones (AZ-A, AZ-B, AZ-C) on SSD.
When data needs to be updated, it has to write updates to all copies. Data can be inconsistent when reading from a copy that has yet to be updated.
You can choose the read consistency in DynamoDB to meet your needs.

# Eventual Consistent Reads (DEFAULT)

When copies are being updated, it is possible for you to read and be returned an inconsistent copy
Reads are fast, but there is no guarantee of consistency
All copies of data eventually become generally consistent within a second


# Strongly Consistent Reads

When copies are being updated, and you attempt to read, it will not return a result until all copies are consistent
You have a guarantee of consistency, but the trade-off is higher latency (slower reads)
All copies of data will be consistent within a second

# DynamoDB – Partitions
What is a Partition?
AWS's definition: A partition is an allocation of storage for a table, backed by solid state drives (SSDs) and automatically replicated across multiple Availability Zones within an AWS Region.
Simple definition: A partition is when you slice your table up into smaller chunks of data (a partition). It speeds up reads for very large tables by logically grouping similar data together.

DynamoDB automatically creates partitions for you as your data grows.
DynamoDB starts off with a single partition.
There are ✌️ two cases where DynamoDB will create new partitions:

For every 10 GB of data
When you exceed the RCUs or WCUs for a single partition

Each Partition has a maximum of 3000 RCUs (Read Capacity Units) and 1000 WCUs (Write Capacity Units)

DynamoDB evenly splits the RCUs and WCUs across Partitions

# DynamoDB – Primary Keys
When you create a table, you have to define a Primary Key.
The primary key determines where and how your data will be stored in partitions.
⚠️ The primary key cannot be changed later


Partition Key — determines which partition data should be written to → e.g. ID (String)
Sort Key (optional) — determines how data should be sorted on a partition → e.g. Date (String)

Using only a Partition Key is called a Simple Primary Key
Using both a Partition and Sort is called a Composite Primary Key

DynamoDB doesn't have a Date datatype, so for dates you have to use a string.

DynamoDB – Primary Key Design
                      Simple Primary Keys                         Composite Primary Keys
Components          Only Partition Key                            Partition Key + Sort Key
Uniqueness rule     No two items can have the same Partition Key  Two items can have the same Partition Key, but Partition and Sort Key combined must be unique

✌️ Two things when designing your Primary Key✌️ Two things when designing your Primary Key

  Distinct – The key should be as distinct (unique) as possible
  Uniform – The key should evenly divide data

# DynamoDB – Query

Query allow you to find items in a table based on primary key values
You can query any table or secondary index that has a composite primary key (partition and sort key)
By default, reads as Eventually Consistent (if you want Strongly Consistent set ConsistentRead True)
By default, returns all attributes for items
You can return specific attributes by using ProjectExpression
By default, is sorted ascending (Use ScanIndexForward False to reverse or to descend)


bash # we assume that v1 is our primary key
aws dynamodb query \
  --table-name MusicCollection \
  --projection-expression "SongTitle" \
  --key-condition-expression "Artist = :v1" \
  --expression-attribute-values file://expression.json \
  --return-consumed-capacity TOTAL


json
# expression.json
{
  ":v1": {"S": "Wheatus"}
}

# DynamoDB – Scan

  Scan through all items and then return one or more items through filters
  By default, returns all attributes for items
  Scans can be performed on tables and secondary indexes
  Can return specific attributes by using ProjectExpression
  Scan operations are sequential. You can speed up a scan through parallel scans using Segments and Total Segments parameters


bash
aws dynamodb scan \
  --table-name MusicCollection \
  --filter-expression "Artist = :a" \
  --projection-expression "#ST, #AT" \
  --expression-attribute-names file://names.json \
  --expression-attribute-values file://values.json
json# names.json
{
  "#ST": "SongTitle",
  "#AT": "AlbumTitle"
}

# values.json
{
  ":a": {"S": "Wheatus"}
}


🚧 Avoid Scans When Possible

  Scans are much less efficient than running a query
  As a table grows, scans take longer to complete
  A large table can use all your provisioned throughput in a single scan


# docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-function.html
# docs.aws.amazon.com/serverless-application-model/latest/developerguide/sam-resource-simpletable.html
first build it and deploy it
# docs.docs.aws.amazon.com/cli/latest/reference/dynamodb/
# awscli.amazonaws.com/v2/documentation/api/latest/reference/dynamodb/put-item.html#examples


