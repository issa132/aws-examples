# Amazon Machine Image (AMI) provides the information required to launch an instance. You can turn your EC2 instances into AMIs so you can create copies of your servers.
An AMI holds the following information:

    A template for the root volume for the instance (EBS Snapshot or Instance Store template) eg. an operating system, an application server, and applications
    Launch permissions that control which AWS accounts can use the AMI to launch instances.
    A block device mapping that specifies the volumes to attach to the instance when it's launched.

AMIs are Region Specific!

AMIs help you keep incremental changes to your OS, application code, and system packages.

The AWS Marketplace lets you purchase subscriptions to vendor-maintained AMIs.
Security-hardened AMIs are very popular. eg. Center of Internet Security (CIS)

AMIs have two possible boot modes:
Legacy BIOS (Basic Input/Output System)
    The traditional firmware interface for computers, which has been used for decades.
    It initializes hardware during the boot-up process and provides runtime services for operating systems and programs.
    No support for secure boot
    May be require in cases when using legacy OS or legacy Software

Unified Extensible Firmware Interface (UEFI)
    A modern firmware interface for computers, designed to replace the older BIOS firmware interface.
    Supports secure boot
    Faster startup times
    Supports drives larger 2TB
    Pre-boot environment with Graphical UI and some network capabilities

Unless there is a specific legacy reason you want to utilize UEFI

AMI – Elastic Network Adapter (ENA)
Elastic Network Adapter (ENA) supports network speeds of up to 100 Gbps for supported instance types.

# You can create an AMI from an existing EC2 instance that's either running or stopped.
aws ec2 create-image \
--instance-id i-1234567890abcdef0 \
--name "My server AMI" \
--reboot


# You can copy an AMI. You can copy an AMI across to another region.You can encrypt a non-encrypted AMI during the copy.
aws ec2 copy-image \
--source-region us-west-1 \
--source-image-id ami-1234567890abcdef0 \
--name "My copied AMI" \
--encrypted \
--region us-east-1

# AMI – Store and Restore

You can store an AMI in an S3 bucket, and restore from an S3 Bucket.
The reason you would do this is if you want to copy AMIs from one AWS partition to another.


Storing an AMI to S3
aws ec2 create-instance-export-task \
--instance-id i-1234567890abcdef0 \
--target-environment vmware \
--export-to-s3-task DiskImageFormat=VMDK,S3Bucket=my-ami-backup-bucket,S3Prefix=exported-ami/

Restoring an AMI from S3
aws ec2 import-image \
--description "Imported AMI" \
--disk-containers "Format=VMDK,S3Bucket=my-ami-backup-bucket,S3Key=exported-ami/my-export

aws ec2 create-image --instance-id i-0ace245ddca5d8aa3 --name "MyAmi-000"
aws ec2 copy-image --source-region us-east-1 --source-image-id ami-06bb02361dd3b8449 --name "My copied AMI" --region ca-central-1 --encrypted



