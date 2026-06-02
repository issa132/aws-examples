Relational Database Service (RDS) is a managed service for multiple open-source and proprietary relational databases.

Features:

    Supports different kinds of db engines
    Automatic and manual backups
    Multi-AZ
    Read Replicas
    Performance Insights
    Customize DB parameters
    RDS Proxy for a connection pooler
    Various methods of authentication
    Blue/green deployments...

MySQL

    The most popular open-source SQL database that was purchased and is now owned by Oracle.
    Offers replication and partitioning features for scalability and availability.

MariaDB

    Oracle bought MySQL, MariaDB made a fork (copy) of MySQL under a different open-source license.
    Continues to maintain high compatibility with MySQL, ensuring a drop-in replacement capability.

Postgres (PSQL)

    Most popular open-source SQL database among devs. Has rich-features over MySQL but at added complexity.
    Supports advanced data types and functions, such as JSON, XML, and key-value pairs for app development.

Oracle

    Oracle's proprietary SQL database. Well used by Enterprise companies. You have to buy a license to use it.
    Features a complex architecture that supports large-scale databases and multi-tiered applications.

Microsoft SQL Server

    Microsoft's proprietary SQL database. You have to buy a license to use it.
    Integrates seamlessly with other Microsoft products and services, including Azure cloud services.

IBM DB2

    IBM's proprietary SQL database. You have to buy a license to use it.
    Known for its high performance and scalability in large enterprise environments.

Aurora

    Fully managed database service that's compatible with MySQL and PostgreSQL.
    Automatically divides your database volume into 10GB segments spread across many disks, enhancing performance and reliability.

# RDS – Encryption
 

    You can turn on encryption-at-rest for all RDS engines
    You may not be able to turn encryption on for older versions of some engines.
    It will also encrypt the automated backups, snapshots, and read replicas.
    Encryption is handled using the AWS Key Management Service (KMS)
    You can only turn encryption on during creation
        You can take snapshots and launch new instances with encryption turned on

Encryption-in-Transit is provided by default via the databases DNS EndpointEncryption-in-Transit is provided by default via the databases DNS Endpoint


# RDS – Backup


RDS databases can be backup in a few ways:


Choose a Retention Period between 0 and 35 days
    0 days would mean automatic backups is turned off.
    You can use Point-in-time recovery (PITR) to restore at any 5 min interval within your retention period
Stores transaction logs throughout the day
Automated backups are enabled by default
All data is stored inside S3
You defined your backup window
Storage I/O may be suspended during backup
There is no additional charge for automated backups

bash
aws rds modify-db-instance \
--db-instance-identifier my-sample-db \
--backup-retention-period 7 \
--preferred-backup-window 03:00-04:00 \
--apply-immediately
Automated Backups

Taken manually by the user
Backups persist even if you delete the original RDS instance
Copied: You can copy snapshots across regions
Share: You can share snapshots to other AWS accounts
Export: Manual snapshot can be exported to S3
There are additional storage charge for manual snapshots

bash
aws rds create-db-snapshot \
--db-snapshot-identifier backup-before-big-deploy \
--db-instance-identifier my-db-instance
Manual Snapshots


To backup a database your database has to be in the "available" stateTo backup a database your database has to be in the "available" state

RDS – Restoring Backup
 
Restoring a Backup for automated and manual creates a new RDS instance and restores the data to that instance.
Restoring a manual snapshot via the AWS CLI

bash
aws rds restore-db-instance-from-db-snapshot \
--db-instance-identifier restored-db-instance \
--db-snapshot-identifier my-db-snapshot

Restoring a Point-in-Time (PITR) Backup via Automatic Backups via the AWS CLI
bash
aws rds restore-db-instance-to-point-in-time \
--source-db-instance-identifier source-db-instance \
--target-db-instance-identifier restored-db-instance \
--restore-time "2023-03-29T15:45:00Z"

Restoring backups is not a fast process because it creates a new database, consider that for Recovery Time Objectives (RTO)sRestoring backups is not a fast process because it creates a new database, consider that for Recovery Time Objectives (RTO)s

RDS – Subnet Groups
 
DB subnet group is a collection of subnets (usually private subnets) that you create in a VPC and that you then designate for your DB instances.

    Each DB subnet group should have subnets in at least two Availability Zones in a given AWS Region.
    RDS will choose a subnet from your subnet group to deploy your RDS Instance
    Subnets in a DB subnet group are either public or private
    For a DB instance to be publicly accessible, all of the subnets in its DB subnet group must be public

Configuring Multi-AZ on an existing RDS instance using the AWS CLI
bash
aws rds modify-db-instance \
  --db-instance-identifier your-db-instance-identifier \
  --multi-az \
  --apply-immediately
If you don't apply immediately the Multi-AZ will only be provision during next maintenance window


RDS – Read Replicas

Read-Replicas allows you to run multiple read-only copies of your database.
The improve read contention which in-turn improve performance and latency

    Read contention is when multiple processes or instances competing for access to the same index or data block at the same time.

You must have automatic backups enabled to use Read Replicas
Asynchronous replication occurs between the primary RDS instance and the replicas.
Primary → Async → Read Replica (within Availability Zone)

    You can have up-to 5 replicas of a database for MySQL, MariaDB, and PostgreSQL
    You can have up-to 15 read replicas for Aurora
    Each Read Replica will have its own DNS Endpoint
    Read Replicas will by default use the same Storage Type as the source database.

You can have Multi-AZ replicas, replicas in another region, or even replicas of other read replicasYou can have Multi-AZ replicas, replicas in another region, or even replicas of other read replicas
Replicas can be promoted to their own database, but this breaks replication
No automatic failover. If the primary copy fails, you must manually update URLs to point at copy

Creating a Read Replica using the AWS CLI
bash
aws rds create-db-instance-read-replica \
    --db-instance-identifier myreadreplica \
    --source-db-instance-identifier mydbinstance \
    --allocated-storage 100 \
    --max-allocated-storage 1000 \
    --upgrade-storage-config


RDS – DB Instances
 
DB instance is an isolated database environment running in the cloud.
DB instance can contain one or multiple user-created databases.
Some database engines require that a database name be specified
You can have up to 40 Amazon RDS DB instances per AWS Account:

    10 for each SQL Server edition (Enterprise, Standard, Web, and Express) under the "license-included" model
    10 for Oracle under the "license-included" model
    40 for Db2 under the "bring-your-own-license" (BYOL) licensing model
    40 for MySQL, MariaDB, or PostgreSQL
    40 for Oracle under the "bring-your-own-license" (BYOL) licensing model

Each database has user-defined database identifier which forms part of the DNS hostname

https://my-rd-instance.mnopqrstuvwx.us-west-1.rds.amazonaws.com/

                            ↑ and an AWS-defined RDS unique identifier

DB Identifier identifies the RDS instance and is not the database name.

RDS – DB Instance Storage
Cheat sheets, Practice Exams and Flash cards 👉 www.exampro.co/ssa-c03
DB instances use Elastic Block Storage (EBS) volumes for database and log storage.

You can utilize

        General Purpose SSD (gp2, gp3)
        Provisioned IOPS SSD (io1, io2 Block Express)
        Magnetic
            Not recommended

maximum storage that most DB instance classes is 64 TB
    Will greatly vary based on engine type and instance type and size
You can increase storage size of an EBS
    RDS will not let you reduce the size of storage, only increase
    To decrease storage size create a new DB instance that has less provisioned storage space


RDS – Performance Insights
RDS Performance Insights helps you easily identify bottlenecks and performance issues.
By default Performance Insights is turned on providing 1 week of performance data
For additional cost you can change retention period to 2 years.

# RDS Custom
RDS Custom automates database administration tasks and operations. Allows customers to directly manage aspects of RDS instead of AWS for companies require third party applications or customizations for their databases.
What you can do:

    Install third-party applications.
    Install custom patches.
    Create your own automation.

How does it work:

    You create RDS Custom DB instances
    You connect a RDS Custom DB instance endpoint
    You can directly access the host to make any changes

Works with:

    Microsoft SQL Server
    Oracle Database


#  docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-rds-dbinstance.html
#  docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-rds-dbsubnetgroup.html
# awscli.amazonaws.com/v2/documentation/api/latest/reference/secretsmanager/create-secret.html#examples
# awscli.amazonaws.com/v2/documentation/api/latest/reference/secretsmanager/get-secret-value.html
# docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-split.html
# docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-rds-dbsubnetgroup.html#cfn-rds-dbsubnetgroup-dbsubnetgroupdescription
# postgresql://postgres:mypassword@rds-basic-rdsinstance-gj21c6titoci.cv1x0r3utzcm.ca-central-1.rds.amazonaws.com:5432/mydatabase

# Connection String URL

postgresql://[user[:password]@][netloc][:port][/dbname][?param1=value1&...]
postgresql://postgres:mypassword@rds-basic-rdsinstance-gj21c6titoci.cv1x0r3utzcm.ca-central-1.rds.amazonaws.com:5432/mydatabase

# Create a table
CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATE,
    status VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
