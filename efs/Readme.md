Elastic File System (EFS) is a file storage service for EC2 instances.

Storage capacity grows (up to petabytes) and shrinks automatically based on data stored (elastic)
Multiple EC2 instances in the same VPC can mount a single EFS Volume (volume must be in the same VPC)
EC2 instances install the NFSv4.1 client and can then mount the EFS volume
EFS is using the Network File System version 4 (NFSv4) protocol
EFS creates multiple mount targets in all your VPC subnets
You are billed per space used starting at $0.30 GB / month


EFS vs EBS quick comparison:
Feature              EFS                     EBS
Type                File storage            Block storage
Shared access       ✅ Multiple EC2s        ❌ Single EC2
Capacity            Auto-scales (elastic)   Fixed, manually sized
Protocol            NFSv4                   N/A
Pricing             Per GB used             Per GB provisioned
Scope               VPC-wide                Single AZ

you can mount efs to service like farget, lamda 


# amazon-efs-utils package is an open-source collection of Amazon EFS tools, also known as the Amazon EFS client.
https://github.com/aws/efs-utils

EFS client enables the ability to use Amazon CloudWatch to monitor an EFS file system's mount status.
You need to install the Amazon EFS client on an Amazon EC2 instance prior to mounting an EFS file system.

Includes the Amazon EFS mount helper, which makes it easier to mount EFS file systems. A mount helper is a program that you use when you mount a specific type of file system.
Amazon Linux 2 (AL2) install:
bashsudo yum install -y amazon-efs-utils

EFS mount helper provides the following options:

    Mounting on supported EC2 instances
    Mounting with IAM authorization
    Mounting with Amazon EFS access points
    Mounting with an on-premise Linux client
    Auto-mounting EFS file systems when an EC2 instance reboots
    Mounting a file system when creating a new EC2 instance
    Can mount either Linux or Mac


⚠️ Amazon EFS does not support mounting from Amazon EC2 Windows instances.
Before EFS mount helper, the standard Linux NFS client was recommended for mounting.

mount helper defines a new network file system type, called efs, which is fully compatible with the standard mount command in Linux.
mount helper also supports automating mounting an EFS at instance boot via /etc/fstab configuration
_netdev option, used to identify network file systems, when mounting your file system automatically. If omitted, EC2 instance might stop responding.

You can mount with the following:
bash# Mount using DNS name
sudo mount -t efs -o tls fs-example.efs.us-west-2.amazonaws.com:/ /mnt/efs

# Mount using filesystem ID
sudo mount -t efs -o tls fs-12345678:/ /mnt/efs

# Mount using access point
sudo mount -t efs -o tls,accesspoint=fsap-12345678 203.0.113.25:/ /mnt/efs
Option              Description
-t efs              Specifies the EFS file system type
-o tls              Enables encryption in transit
accesspoint=        Mounts via a specific EFS access point
/mnt/efs            Local mount target directory

# EFS mount helper will use the following mount options:

nfsvers=4.1 – used when mounting on EC2 Linux instances
nfsvers=4.0 – used when mounting on supported EC2 Mac instances running macOS Big Sur, Monterey, and Ventura
rsize=1048576 – Sets the maximum number of bytes of data that the NFS client can receive for each network READ request to 1048576, the largest available, to avoid diminished performance
wsize=1048576 – Sets the maximum number of bytes of data that the NFS client can send for each network WRITE request to 1048576, the largest available, to avoid diminished performance
hard – Sets the recovery behavior of the NFS client after an NFS request times out, so that NFS requests are retried indefinitely until the server replies, to ensure data integrity
timeo=600 – Sets the timeout value that the NFS client uses to wait for a response before it retries an NFS request to 600 deciseconds (60 seconds) to avoid diminished performance
retrans=2 – Sets to 2 the number of times the NFS client retries a request before it attempts further recovery action
noresvport – Tells the NFS client to use a new non-privileged Transmission Control Protocol (TCP) source port when a network connection is reestablished. Using the noresvport option helps to ensure that your EFS file system has uninterrupted availability after a reconnection or network recovery event
mountport=2049 – only used when mounting on EC2 Mac instances running macOS Big Sur, Monterey, and Ventura