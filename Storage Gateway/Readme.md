# Introduction to Storage Gateway
AWS Storage Gateway connects on-premise software applications with cloud-based storage.
File Gateway allows you to run a gateway within your on-premise environment so you can interact through a SMB or NFS file-system protocol.
    File Gateway to Amazon S3 — Store data in S3
    File Gateway to FSx for WFS — Store data in a Windows File Server


Think of: File Gateway = shared folder / Volume Gateway = remote drive

Volume Gateway allows you to mount S3 as a local drive using the iSCSI protocol.
    Cached Volumes — Primary data stored on S3 and frequently accessed files stored locally
    Stored Volumes (Non Cached) — Primary data stored locally and entire data backed up to S3

Tape Gateway stores files onto Virtual Library Tapes (VTLs) for backing up your files on very cost effective long term storage.

# Amazon S3 File Gateway
Amazon S3 File Gateway allows your files to be stored as objects inside your S3 buckets. Access your files through a Network File System (NFS) or SMB mount point.

Amazon S3 provides a cost-effective alternative to on-premises storage.

You deploy your gateway to an on-premise Virtual Machine that runs one of the following hypervisors:
    VMware ESXi
    Microsoft Hyper-V
    Linux Kernel-based Virtual Machine (KVM)

The gateway can also be deployed to:
    VMware Cloud on AWS
    AMI in Amazon EC2

For file protocols you can use:
    Network File System (NFS) Version 3 or 4.1
    Server Message Block (SMB) Version 2 or 3

Files can take full advantage of S3's offerings:
    Bucket Policies
    Versioning
    Lifecycle Management
    Cross-Region Replication
    Metadata

They act like native S3 objects.

Amazon S3 File Gateway integrates with:
    IAM, KMS, CloudWatch, CloudTrail, AWS CLI

# Terminal Session — Mounting an NFS Share (S3 File Gateway)
bashsudo su - ec2-user          # Switch to ec2-user
ls                          # List files (empty)
pwd                         # Current directory: /home/ec2-user

mkdir sgw                   # Create mount point directory

#  mount attempt (with sudo) — SUCCEEDED
sudo mount -t nfs -o nolock,hard 172.31.6.161:/sgw-2024-04-19-ebyd3 /home/ec2-user/sgw

ls        # Shows: sgw (highlighted in green)
ls -la    # Detailed listing showing sgw directory owned by nobody:nobody

cd sgw/   # Navigate into the mounted NFS share
ls        # Empty directory
touch hello.txt   # Create a test file on the gateway
Key observations:

The NFS share is mounted from the Storage Gateway IP 172.31.6.161
The sgw directory is owned by nobody:nobody — typical for NFS mounts
A hello.txt file is created, which will be stored as an object in S3

# Amazon FSx File Gateway
Amazon FSx File Gateway allows your files to be stored in Amazon FSx Windows File Storage (WFS). Allow your Windows developers to easily store data in the cloud using the tools they already know.
    You must have at least one Amazon FSx for Windows File Server file system
    You must also have on-premises access to FSx for Windows File Server
        either through a VPN or through an AWS Direct Connect connection

You deploy your gateway to an on-premise Virtual Machine that runs one of the following hypervisors:
    VMware ESXi
    Microsoft Hyper-V
    Linux Kernel-based Virtual Machine (KVM)
    or as a hardware appliance that you order from your preferred reseller

The gateway can also be deployed to:
    VMware Cloud on AWS
    AMI in Amazon EC2

# Volume Gateway – Stored Volumes
Stored Volumes store primary data locally and asynchronously back up that data to AWS.
    On-Premise → Primary Data
    AWS → Asynchronous Backups

Provide your on-premises applications with low-latency access to their entire datasets while still providing durable off-site backups. Create storage volumes and mount them as iSCSI devices from your on-premises servers. Any data written to stored volumes are stored on your on-premises storage hardware. Amazon Elastic Block Store (EBS) snapshots are backed up to AWS S3. Stored Volumes can be between 1GB - 16TB in size.
Hosting:
    Deployed as a VM appliance
    Deployed as a Hardware appliance
    Deployed to an EC2 instance

# Volume Gateway – Cached Volumes
Cache Volumes store primary data in Amazon S3 while retaining frequently accessed data locally in your storage gateway.

    On-Premise → Cache Most Frequently Accessed Blocks
    AWS → Primary Data
    Minimizes the need to scale your on-premises storage infrastructure while still providing your applications with low-latency data access.
    Create storage volumes up to 32TB in size and attach them as iSCSI devices from your on-premises servers.
    Your gateway stores data that you write to these volumes in S3 and retains recently read data in your on-premises storage gateway cache, and upload buffer storage.
    Cached volumes can be between 1GB - 32GB in size.

Hosting: Deployed as a VM appliance
    VMware ESXi Hypervisor
    Microsoft Hyper-V
    Linux Kernel-based Virtual Machine (KVM)

# Tape Gateway
Tape Gateway is a durable, cost-effective solution to archive your data in the AWS Cloud.
The VTL interface it provides lets you leverage existing tape-based backup application infrastructure.
Store data on virtual tape cartridges that you create on your tape gateway. Tape storage has proven readability of 30 years.

    Each tape gateway is pre-configured with a media changer and tape drives, which are available to your existing client backup applications as iSCSI devices.
    You add tape cartridges as you need to archive your data.
    Supported by NetBackup, Backup Exec, and Veeam.

Flow: On-Premise (Local Storage Volume) → iSCSI → Gateway → HTTPS → VTL Stored in S3 Glacier
Hosting:
    Deployed as a VM appliance
        VMware ESXi Hypervisor
        Microsoft Hyper-V
        Linux Kernel-based Virtual Machine (KVM)

    Deployed as a Hardware appliance
    Deployed to an EC2 instance

# Tape Gateway (continued)

A VTL media changer is analogous to a robot that moves tapes around in a physical tape library's storage slots and tape drives.

Tape Gateway has two possible medium changers:
    AWS-Gateway-VTL
    STK L700 — emulated (StorageTek L700 Tape Library)

Different backup applications can use both or only specific media changers:
    Arcserve Backup
    Bacula Enterprise V10.x
    Commvault V11
    Dell EMC NetWorker 19.5
    IBM Spectrum Protect v8.1.10
    Micro Focus (HPE) Data Protector 9 or 11.x
    Microsoft System Center 2012 R2 or 2016 Data Protection Manager
    NovaStor DataCenter/Network 6.4 or 7.1
    Quest NetVault Backup 12.4 or 13.x
    Veeam Backup & Replication 11A
    Veritas Backup Exec 2014 or 15 or 16 or 20 or 22.x
    Veritas Backup Exec 2012

