# AWS Backup allows you to centrally manage backups across AWS Services.
Backup services:

Amazon S3
VMWare VMs
DynamoDB
FSx File Systems
EC2
EFS
EBS
RDS and Aurora
AWS BackInt (SAP HANNA)
SGW (storage gateway)
DocumentDB
Neptune
Timestream
And more....

Backup Plan – A backup policy defines the backup schedule, backup window, backup lifecycle.
Backup Vault – backups are stored in a backup vault.

AWS Backup Vault Lock allows for Write-Once-Read-Many (WORM) to set a retention period
Standard Vault (Default) – backups are always initially stored in the standard vault
Air-Gapped Vault — backups can be moved to a logically air-gapped vault for additional security
Resources can be assigned a backup plan using AWS Resource Tags
You can backup resources to other AWS Regions or AWS Accounts
You can manage backups from a centralized account across your entire AWS Organization
Backups are incremental, so you only store the difference instead of full backups to save costs
AWS Backup can use an independent KMS encryption key from that of your AWS resources
Associated charges for AWS Backup appear as "Backup" under Cost Explorer
AWS Backups are immutable to avoid them being tampered with


AWS Backup Audit Manager is built-in reporting and auditing for AWS Backups