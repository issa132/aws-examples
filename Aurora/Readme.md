02:55
Introduction to Aurora
Amazon Aurora is a fully managed relational database cluster that

    combines the speed and availability of high-end databases
    with the simplicity and cost-effectiveness of open-source databases.
Aurora can run either MySQL-compatible or Postgres-compatible engines

Aurora MySQL is 5x better performance than traditional MySQL	Aurora Postgres is 3x better performance than traditional Postgres

1/10th the costs of other solutions offering similar performance and availability.
Aurora contains most of the other features RDS and has its own exclusive features


# Aurora – Scaling
Durability and Fault Tolerance

    Aurora Backup and Failover are handled automatically
    Snapshots of data can be shared with other AWS accounts

Storage is self-healing, in that data blocks and disks are continuously scanned for errors and repaired automatically.

Availability

    Aurora deploys in a minimum of 3 availability zones each contain 2 copies of your data at all times.
    That means there are 6 copies
    Lose up to 2 copies of your data without affecting write availability.
    Lose up to 3 copies of your data without affecting read availability.

Storage

    A cluster starts with 10GB of storage and scale in 10GB increments up to 64TB or 128 TB depending on DB engine version.
    Storage is autoscaling.
    Computing resources can scale up to 32 vCPUs and 244GB of memory.

Security

    TLS/SSL certificate can be applied to encrypt security connections so termination occurs at the database
    Data is encrypted-at-rest by default and cannot be turned off. Can use KMS keys

# Aurora Provisioned
Aurora Serverless Provisioned is the default compute configuration for Aurora.
Aurora DB cluster contains a primary DB instance that performs reads and writes, and, optionally, up to 15 Aurora Replicas (reader DB instances).
Creating an Aurora DB provisioned cluster via the AWS CLI
bash
aws rds create-db-cluster \
  --db-cluster-identifier myauroracluster \
  --engine aurora-mysql \
  --engine-version 5.7.12 \
  --master-username masteruser \
  --master-user-password masterpassword \
  --backup-retention-period 7 \
  --preferred-backup-window 07:00-09:00 \
  --preferred-maintenance-window Sun:23:00-Mon:01:00
The primary DB instance will not be created for by default you have to create your instances after creating your cluster

 
The first DB instance you create in your cluster will be writer instance.
bash
aws rds create-db-instance \
  --db-instance-identifier my-writer-instance \
  --db-instance-class db.r4.large \
  --engine aurora-mysql \
  --db-cluster-identifier my-cluster
All other instances created afterwards will be a reader instance (Aurora replica)

bash
aws rds create-db-instance \
  --db-instance-identifier my-reader-instance \
  --db-instance-class db.r4.large \
  --engine aurora-mysql \
  --db-cluster-identifier my-cluster

# Aurora Serverless V2
Aurora Serverless V2 fully-manages the autoscaling configuration for Amazon Aurora

    Capacity is adjusted automatically based on application demand
    You're charged only for the resources that your DB clusters consume
    suitable for the most demanding, highly variable workloads
    Aurora "Serverless" V2 does not scale to zero and must maintain at least 0.5 ACUs
    Only certain Aurora Instances classes are available to use with Aurora Serverless V2

Aurora capacity unit (ACU)
ACU's is the unit of measurement Aurora Serverless V2 uses to determine cost vs capacity.
1 ACU is about 2GiB of memory, CPU and networking.

    Capacity ranges between 0.5 ACUs and 128 ACUs

When you configure your Aurora Cluster for Serverless V2 you set a Minimum and Maximum ACU capacity
bash
aws rds create-db-cluster \
  --db-cluster-identifier my-cluster \
  --region us-east-1 \
  --engine aurora-mysql \
  --engine-version 8.0.mysql_aurora.3.04.1 \
  --serverless-v2-scaling-configuration MinCapacity=1,MaxCapacity=4 \
  --master-username myuser \
  --manage-master-user-password

When you create a Writer instance you need to specify the db class as being db.serverless
bash
aws rds create-db-instance \
  --db-cluster-identifier my-serverless-v2-cluster \
  --db-instance-identifier my-serverless-v2-instance \
  --db-instance-class db.serverless \
  --engine aurora-mysql

# Aurora Global Database
Amazon Aurora Global Database is a Aurora database spanning multiple regions for global low-latency and high availability.

    Has a primary cluster in 1 region
    Has up-to 5 secondary DB clusters in different regions
    Write operation occur on the Primary cluster
    Data is replicated to secondary cluster (typically under a second)
    Global Database is only available in specific regions and specific database versions

 
You need to create a global cluster

bash
aws rds create-global-cluster \
  --region primary_region \
  --global-cluster-identifier global_database_id \
  --engine aurora-mysql \
  --engine-version version # optional
Then you create your primary cluster and use the global cluster identifier to place it within the global cluster

bash
aws rds create-db-cluster \
  --region primary_region \
  --db-cluster-identifier primary_db_cluster_id \
  --master-username userid \
  --master-user-password password \
  --engine aurora-mysql \
  --engine-version version \
  --global-cluster-identifier global_database_id
Not shown, creating the db instance on the cluster.

Then you create your secondary cluster and use the global cluster identifier to place it within the global cluster

bash
aws rds create-db-cluster \
  --region secondary_region \
  --db-cluster-identifier secondary_cluster_id \
  --global-cluster-identifier global_database_id \
  --engine aurora-mysql \
  --engine-version version
Not shown, creating the db instance on the cluster.

# Aurora – RDS Data API
RDS Data API allows you to use HTTP requests to securely query an Aurora database.

    Unlimited max request per seconds
    Must be enable on the cluster to user
    DATA API calls are by default excluded by CloudTrail since they are data events
    Multi statements aren't supported
    Cannot retrieve multi-dimensional arrays for a query's column
    Supports specific data-types
    Supports Execution and Transaction statements.

Enabling RDS DATA API on an Aurora Cluster
bash
aws rds enable-http-endpoint \
  --resource-arn cluster_arn

Executing an SQL statement using the RDS Data API
bash
aws rds-data execute-statement \
  --resource-arn "arn:aws:rds:us-east-1:123456789012:cluster:mydbcluster" \
  --database "mydb" \
  --secret-arn "arn:aws:secretsmanager:us-east-1:123456789012:secret:mysecret" \
  --sql "select * from mytable"
Aurora in the AWS Management Console has a Query Editor which is just an interface to connect and use the RDS DATA API. 

# docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonSSMManagedInstanceCore.html

DB cluster identief: mydb
master username: postgres
password: mypassword

databasename: mydatabase

mydb-instance-1.cv1x0r3utzcm.ca-central-1.rds.amazonaws.com

postgresql://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]

postgresql://postgres:mypassword@mydb-instance-1.cv1x0r3utzcm.ca-central-1.rds.amazonaws.com:5432/mydatabase




# create a table

CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATE,
    status VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
 

# Install Postgres Client on EC2 Instance AML2023 X86

sudo dnf install postgresql15.x86_64 postgresql15-server -y

# Connection String URL
postgresql://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]
postgresql://postgres:mypassword@mydb-instance-1.cv1x0r3utzcm.ca-central-1.rds.amazonaws.com:5432/mydatabase

# sudo su - ec2-user

# Aurora – Babelfish for Aurora
What is Babelfish?
Babelfish for PostgreSQL is an open source library with the capability for PostgreSQL to understand queries from applications written for Microsoft SQL Server.
Babelfish for Aurora PostgreSQL extends your Aurora PostgreSQL DB cluster with the ability to accept database connections from Microsoft SQL
Apps originally built for SQL Server can work directly with Aurora PostgreSQL with few code changes compared to a traditional migration and without changing database drivers.
Both SQL dialects supported by Babelfish are available through their native wire protocols at the following ports:

    SQL Server dialect (T-SQL), port 1433.
    PostgreSQL dialect (PL/pgSQL), port 5432.
    Babelfish runs the Transact-SQL (T-SQL)
    Babelfish currently doesn't support

        RDS Blue/Green Deployments
        AWS IAM
        Database Activity Streams (DAS)
        PostgreSQL logical replication
        RDS Data API with Aurora PostgreSQL Serverless v2 and provisioned
        RDS Proxy with RDS for SQL Server
        Salted challenge response authentication mechanism (SCRAM)
        Query Editor
        Kerberos authentication via Active Directory

# MongoDB
MongoDB is an open-source document database which stores JSON-like documents
The primary data structure for MongoDB is called BSON
Binary JSON (BSON)

    BSON is a binary representation of JSON-like documents
    BSON is designed to be efficient both in storage space and scan-speed compared to JSON
    BSON has more data-types than JSON:

        Eg. Datetime, byte arrays, regular expressions, MD5 binary data, javascript code



BSON:
\x16\x00\x00\x00        // total document size
\x02                     // 0x02 = type String
hello\x00                // field name
\x06\x00\x00\x00world\x00 // field value (size of value, value, null terminator)
\x00                     // 0x00 = type EOO ('end of object')

What it looks like to perform an operation on a MongoDB databases
javascript

db.inventory.insertMany([
  { item: "journal", qty: 25, size: { h: 14, w: 21, uom: "cm" }, status: "A" },
  { item: "notebook", qty: 50, size: { h: 8.5, w: 11, uom: "in" }, status: "A" },
  { item: "paper", qty: 100, size: { h: 8.5, w: 11, uom: "in" }, status: "D" },
  { item: "planner", qty: 75, size: { h: 22.85, w: 30, uom: "cm" }, status: "D" },
  { item: "postcard", qty: 45, size: { h: 10, w: 15.25, uom: "cm" }, status: "A" }
]);

 

MongoDB uses with a interactive shell (mongosh) or a MongoDB driver to interact with MongoDB

    MongoDB traditionally doesn't use an SQL language but there is MQL and Atlas SQL


Default Port for MongoDB: 27017


MongoDB supports searches against:
      fields
      ranged queries
      regular-expressions


MongoDB supports primary and secondary indexes
High availability can be obtained via replica sets (replica to offload reads or acts a stand-by in case of failover)
MongoDB scales horizontally using sharding
MongoDB can run over multiple servers via load balancing

MongoDB can be used as a file system, called GridFS
  with load balancing and data replication features over multiple machines for storing files.

MongoDB provides three ways to perform aggregation (grouping data during a query)
    aggregation pipeline
    map-reduce
    single-purpose aggregation

MongoDB supports fixed-size collections called capped collections
MongoDB claims to support multi-document ACID transactions

# Horizontal scaling (scaling out) means adding more machines/servers to distribute the load, rather than making one machine more powerful.
Think of it like this:

Vertical scaling (scale up) = one bigger, more powerful server
Horizontal scaling (scale out) = many smaller servers working together

