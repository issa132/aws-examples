AWS Snow Family
AWS Snow Family are storage and compute devices used to physically move data in or out the cloud when moving data over the internet or private connection is too slow, difficult or costly.

# AWS Snowcone is a portable, rugged(robustre), and secure device for edge computing and data transfer.

Snowcone can send data to AWS in two ways:

By physically shipping the device back to AWS.
Using AWS DataSync, which runs on the device’s compute resources.

# Snowball Edge
Similar to Snowcone but with more local processing, edge-computing workloads, and device configuration options.

 # Snowmobile
Snowmobile is a 45-foot-long ruggedized shipping container, pulled by a semi-trailer truck. Can transfer up to 100PB per Snowmobile.
AWS personnel will help you connect your network to the Snowmobile, and when data transfer is complete, they'll drive it back to AWS to import into S3 or Glacier.

# AWS Transfer Family offers fully managed support for the transfer of files over SFTP, AS2, FTPS, and FTP directly into and out of Amazon S3 or Amazon EFS.

FTP (File Transfer Protocol): An early network protocol without encryption, used for transferring files over a network.
SFTP (Secure File Transfer Protocol): Uses SSH to provide a secure encrypted connection for transferring files.
FTPS (FTP Secure or FTP-SSL): Extends FTP with support for SSL/TLS encryption.
AS2 (Applicability Statement 2): Enables secure and reliable messaging over HTTP/S, often used for EDI (Electronic Data Interchange) transactions. Used in industries like e-commerce and retail that require proof of compliant data transfers.

Common ports for these protocols:

FTP — port 20 (control commands) and port 21 (data transfer)
SFTP — port 22
FTPS — port 990
AS2 — port 443

# Transfer Family Managed File Transfer Workflows (MFTW) is a fully managed, serverless File Transfer Workflow service to set up, run, automate, and monitor processing of files uploaded using AWS Transfer Family.
Workflows allow you to perform the following after a file is uploaded:

Copy File — Copy to another S3 destination
Tag File — Apply metadata tagging for S3
Delete File — Delete File from S3 or EFS
Custom file-processing Step — Pass file to a lambda to be processed
Decrypt File — Automatically decrypt file using PGP after uploaded to S3 or EFS

# AWS Migration Hub
AWS Migration Hub is a single place to discover your existing servers, plan migrations, and track the status of each application migration.
AWS Migration Hub can monitor migration status from migration services:

    Application Migration Service (AMS)
    Database Migration Service (DMS)

AWS Discovery Agent — An agent installed on your VM of servers to help discover and migration servers.
Migration Evaluator Collector — You submit a request to AWS to help assess a migration.
AWS Migration Hub Refactor

    Bridges networking across AWS accounts so that legacy and new services can communicate while they maintain the independence of separate accounts.

AWS Migration Hub Journey

    Guided templates for end-to-end migrations.

# AWS DataSync is a data transfer service that simplifies data migration to, from, and between cloud storage services.
Working with the following protocols:

Network File System (NFS)
Server Message Block (SMB)
Hadoop Distributed File Systems (HDFS)
Object storage

Works with the following AWS Services:

Amazon S3
Elastic File System (EFS)
FSx for Windows File Server, Lustre, OpenZFS, NetApp ONTAP
Amazon Snowcone
Amazon S3 Compatible Snowball Edge

Works with other cloud storage services:

Google Cloud Storage
Microsoft Azure Blob Storage
Microsoft Azure Files
Wasabi Cloud Storage
DigitalOcean Spaces
Oracle Cloud Infrastructure Object Storage
Cloudflare R2 Storage
Backblaze B2 Cloud Storage
NAVER Cloud Object Storage
Alibaba Cloud Object Storage Service
IBM Cloud Object Storage
Seagate Lyve Cloud

# AWS DataSync is essentially an automated data mover.
Think of it like a very fast, reliable moving truck for your data. Instead of manually copying files from one place to another, DataSync handles it for you — automatically, securely, and at high speed.

# In simple terms:

You have data somewhere (on-premises, another cloud, or an AWS service)
You want it somewhere else (another AWS service or cloud)
DataSync moves it for you, handling all the complexity

Real world examples:

Moving data from your company's physical servers to Amazon S3
Migrating files from Google Cloud Storage to AWS EFS
Syncing data between two AWS regions
Transferring data from an old data center to AWS before shutting it down

Key benefits:

Fast — can transfer data up to 10x faster than open-source tools
Automated — schedules transfers, no manual work needed
Secure — encrypts data in transit
Reliable — verifies data integrity after transfer
Cost-effective — you only pay per GB transferred


The key difference between DataSync and Transfer Family is that DataSync is for bulk data migration/sync between storage systems, while Transfer Family is for ongoing file transfers using standard protocols like SFTP/FTP used by external partners or clients.

In simple terms:

You have data somewhere (on-premises, another cloud, or an AWS service)
You want it somewhere else (another AWS service or cloud)
DataSync moves it for you, handling all the complexity

Real world examples:

Moving data from your company's physical servers to Amazon S3
Migrating files from Google Cloud Storage to AWS EFS
Syncing data between two AWS regions
Transferring data from an old data center to AWS before shutting it down

Key benefits:

Fast — can transfer data up to 10x faster than open-source tools
Automated — schedules transfers, no manual work needed
Secure — encrypts data in transit
Reliable — verifies data integrity after transfer
Cost-effective — you only pay per GB transferred


The key difference between DataSync and Transfer Family is that DataSync is for bulk data migration/sync between storage systems, while Transfer Family is for ongoing file transfers using standard protocols like SFTP/FTP used by external partners or clients.


                DataSync                Transfer Family
Like...         Moving truck            Post office
Who uses it     IT teams migrating data Businesses exchanging files with partners
How often       Once or scheduled       Continuously/regularly
Volume          Massive(TBs/PBs)        Smaller, regular files
Initiated by    AWS automationExternal users/systems via FTP/SFTP

