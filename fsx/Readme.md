Amazon FSx allows you to deploy scale feature-rich, high-performance file systems in the cloud. FSx supports a variety of file system protocols.

Amazon FSx for NetApp ONTAP
    Proprietary enterprise storage platform known for handling petabytes of data.

Amazon FSx for OpenZFS
    Open-source storage platform originally developed by Sun Microsystems.

Amazon FSx for Windows File Server (WFS)
    File storage on a Windows server supporting native window features for Windows developers.

Amazon FSx for Lustre
    Open-source file system for parallel computing.

"Deploy scale feature-rich" means you can deploy file systems that are both:

Scalable — they can grow to handle large amounts of data and high performance demands (petabytes of storage, millions of IOPS, etc.)
Feature-rich — they come packed with advanced features out of the box, such as snapshots, replication, compression, deduplication, encryption, and protocol support — depending on which FSx variant you choose.

# Amazon FSx for Windows File Server (WFS) is a fully managed shared storage built on Windows Server.

Native support for Windows file system e.g. SMB
Native Windows compatibility
Enterprise performance and features
Consistent sub-millisecond latencies
Tools that Windows developers and administrators use today can continue to work unchanged
Offers storage backed by SSD, HDD or both
FSx integrates with your Microsoft Active Directory

Amazon FSx can be used for:

    Business applications
    Home directories
    Web serving
    Content management
    Data analytics
    Software build setups
    Media processing workloads

To run Amazon FSx you'll need:

    EC2 Instance
    Workspace Instance
    AppStream 2.0

or

    VMWare Cloud on AWS

# Amazon File Cache is a high-speed cache for datasets stored anywhere, accelerate cloud bursting workloads.
Amazon File Cache is found under the Amazon FSx Management Console.
Serves as a temporary, high-performance storage location for data that's stored in:

    On-premises file systems
    AWS file systems
    Amazon S3 buckets

Makes dispersed datasets available to file-based applications on AWS with a unified view, and at high speeds — sub-millisecond latencies and high throughput.
Amazon File Cache is accessible to:

    EC2, ECS or EKS

Compatible with the most popular Linux-based AMIs:

    Amazon Linux, Amazon Linux 2
    Red Hat Enterprise Linux (RHEL)
    CentOS
    Rocky Linux
    Ubuntu

Integrations:

Integrates with AWS Batch via EC2 Launch templates
Integrates with AWS Thinkbox Deadline

    creative studios scale rendering workloads