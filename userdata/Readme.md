# donne mois des exercices type examen AWS avec pièges pour m’entraîner
# EC2 User Data is a script that runs automatically on the first boot of an EC2 instance. It is used to automate the initial configuration of the instance.
Common use cases:

Installing software (e.g. Apache, Nginx, MySQL)
Updating system packages
Creating files
Starting services
Configuring the environment

Key points:

It runs only once at first launch by default
It runs as the root user
It can be a bash script or a cloud-config YAML file
Scripts must be base64 encoded when using the API directly (the CLI and Console do it automatically)
You can view the user data from within the instance at http://169.254.169.254/latest/user-data


# EC2 metadata is data about your EC2 instance that you can access from within the instance itself. It includes information such as:

Instance ID — the unique identifier of your instance
Instance type — e.g. t2.micro
Public/Private IP address
AMI ID — the image used to launch the instance
Security groups
IAM role attached to the instance
Region and availability zone
Hostname
User data — the script you passed at launch

It is useful for scripts running on the instance that need to know information about themselves without having to hardcode it. For example, a script could query the metadata endpoint to get the instance's public IP address dynamically.


# From within your EC2 instance, you can access EC2 metadata information from the Metadata Service (MDS) via a special endpoint.
There are two versions of Metadata Service

    Instance Metadata Service Version 1 (IMDSv1) – a request/response method
    Instance Metadata Service Version 2 (IMDSv2) – a session-oriented method


The endpoint address:

    IPv4 — http://169.254.169.254/latest/meta-data/
    IPv6 — http://[fd00:ec2::254]/latest/meta-data/


# metadata is information about your instance, while user data is a script that configures your instance at launch.

sh-5.2$ sudo su - ec2-user
[ec2-user@ip-172-31-5-128 ~]$ curl http://169.254.169.254/latest/meta-data
system[ec2-user@ip-172-31-5-128 ~]$ wget -qO- http://169.254.169.254/latest/meta-data
# docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-categories.html
[ec2-user@ip-172-31-5-128 ~]$ curl http://169.254.169.254/latest/meta-data/public-ipv4
99.79.65.7[ec2-user@ip-172-31-5-128 ~]$

# docs.aws.amazon.com/cli/latest/reference/ec2/modify-instance-metadata-options.html#examples


aws ec2 modify-instance-metadata-options \
--instance-id i-09494c79e192f9d62 \
--http-tokens required \
--region ca-central-1

TOKEN=$(curl -X PUT "http://169.254.169.254/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" --silent)
echo $TOKEN

IMDSv2 (Instance Metadata Service Version 2) is a more secure way to access EC2 instance metadata. 
It uses a session-oriented approach, meaning you must first get a token before you can query the metadata.

Why IMDSv2 over IMDSv1?
IMDSv1 was a simple request/response method with no authentication — anyone or any process running on the instance could query 
the metadata endpoint, including malicious code. This was a security risk because metadata can contain sensitive information like 
IAM role credentials.
IMDSv2 fixes this by requiring a session token, which makes it much harder for attackers (e.g. via SSRF attacks) to access the metadata.
In summary: IMDSv2 is the more secure, recommended way to access EC2 metadata, and AWS recommends enforcing it by requiring HTTP tokens
 with --http-tokens required
docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-retrieval.html

[ec2-user@ip-172-31-5-128 ~]$ TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` \
&& curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/

# What are Instance Families?
Instance families are different combinations of CPU, Memory, Storage, and Networking capacity.
Instance families allow you to choose the appropriate combination of capacity to meet your application's unique requirements.
Different instance families are different because of the varying hardware used to give them their unique properties.

General Purpose
A1 T2 T3 T3a T4g M4 M5 M5a M5n M6zn M6g M6i Mac
balance of compute, memory and networking resources
Use-cases web servers and code repositories

Compute Optimized
C5 C4 Cba C5n C6g C6gn
Ideal for compute bound applications that benefit from high performance processor
Use-cases scientific modeling, dedicated gaming servers and ad server engines

Memory Optimized
R4 R5 R5a R5b R5n X1 X1e High Memory z1d
fast performance for workloads that process large data sets in memory.
Use-cases in-memory caches, in-memory databases, real time big data analytics

Accelerated Optimized
P2 P3 P4 G3 G4ad G4dn F1 Inf1 VT1
hardware accelerators, or co-processors
Use-cases Machine learning, computational finance, seismic analysis, speech recognition

Storage Optimized
I3 I3en D2 D3 D3en H1
high, sequential read and write access to very large data sets on local storage
Use-cases NoSQL, in-memory or transactional databases, data warehousing

Commonly instance families are called "Instance Types" but an instance type is a combination of size and family.

C – Compute optimized
D – Dense storage
F – FPGA
G – Graphics intensive
Hpc – High performance computing
I – Storage optimized
Im – Storage optimized with a 1:4 (vCPU:Memory)
Is – Storage optimized with a 1:6 (vCPU:Memory)
Inf – AWS Inferentia
M – General purpose
Mac – macOS
P – GPU accelerated
R – Memory optimized
T – Burstable performance
Trn – AWS Trainium
U – High memory
VT – Video transcoding
X – Memory intensive

T and M both are general purpose 

The M Family offers an even balance of compute, memory and networking
The T Family is the cheapest family. Great for variable workloads

# 12:53
AWS underlying instance can have access to a variety of different processors to meet specific cloud workload needs.
Intel Xeon Processors Similar to Intel Desktop CPUs but with advanced capabilities.
AMD EPYC Processors Alternatives to Intel-based instances. Potential cost saving over Intel processors
NVIDIA GPUs Graphic intensive workloads. Often used in Machine Learning.
AWS Graviton Processors Custom-built by AWS using ARM architecture
Intel Habana Gaudi Processors Specialized processors for machine learning workloads
Intel FPGAs Intel's offering for field-programmable gate arrays for workloads that benefit from custom hardware accelerations
Xilinx (AMD) AMD's offering for field-programmable gate arrays for workloads that benefit from custom hardware accelerations
AWS Inferentia A processors designed to deliver high-performance ML inference at low cost
AWS Trainium — A processor design to traing ML models at low cost.

# EC2 Instance Profile is a reference to an IAM role that will be passed and assumed by the EC2 instance when it starts up.
Instance Profile allows you to avoid passing long live AWS credentials. (AWS Access Key and Secret)

EC2 Instance Profiles can be associated at the time of launch or on a running EC2 Instance.
If there was no previous EC2 Instance Profile attached a hard reboot is required for the role to be assumed.
Only a single IAM role can be associated with an Instance Profile
Changing roles is not instantious due to eventual consistently

If you need the role immediately you need to dissociate/reassociate the profile or hard reboot the instance.
  When you select an IAM role when Launching an EC2 instance, AWS will automatically create the Instance Profile for you. Instance Profiles are not easily viewed via the AWS Console.

Creating the Instance Profile
sh
aws iam create-instance-profile \
--instance-profile-name MyInstanceProfile

Adding the single IAM role to the instance profile
sh
aws iam add-role-to-instance-profile \
--instance-profile-name MyInstanceProfile \
--role-name MyRole

Associating the Instance Profile to the EC2
sh
aws ec2 associate-iam-instance-profile \
--instance-id i-1234567890abcdef0 \
--iam-instance-profile Name=MyInstanceProfile

Listing all instances profiles
sh
aws iam list-instance-profiles

Getting information about a specific IAM Role
sh
aws iam get-instance-profile \
--instance-profile-name MyInstanceProfile

# EC2 – Instance Lifecycle
Change Termination Protection
Prevent the instance from being terminated (Default is off)
aws ec2 modify-instance-attribute \
--instance-id i-1234567890abcdef0 \
--disable-api-termination

Change Stop Protection
Prevent the instance from being stopped (Default is off)
aws ec2 modify-instance-attribute \
--instance-id i-1234567890abcdef0 \
--disable-api-stop

Shutdown Behavior
What should happen if the instance is shutdown to either Stop or Terminate (Default is Stop)
aws ec2 modify-instance-attribute \
--instance-id i-1234567890abcdef0 \
--instance-initiated-shutdown-behavior terminate

Auto-Recovery Behavior
Whether to automatically recover an instance when a system status check failure occurs (Default is enabled)
aws ec2 modify-instance-maintenance-options \
--instance-id i-0abcdef1234567890 \
--auto-recovery disabled

Changing the hostname could be necessary in specific use-cases where software is expecting a very specific name. 
When building micro-services such as using Service Meshes might have you change hostnames.

# When using Sessions Manager you will need to change your user to the default user.
When you connect to an EC2 instance via AWS Systems Manager Session Manager, the session starts as the ssm-user (a limited system user created by the SSM agent), not as the default EC2 user (e.g., ec2-user for Amazon Linux, ubuntu for Ubuntu, etc.).
You need to switch to the default user because:

Permissions – the default user typically has sudo privileges and the correct environment set up
SSH keys & home directory – the default user has the proper home directory, dotfiles, and configurations
Application access – software or scripts may be installed/configured under the default user's environment

So you would run something like:
sudo su - ec2-user
# or
sudo su - ubuntu

# EC2 – Burstable(éclatable) Instances
Burstable instances allow workloads to handle bursts of higher CPU utilizations for very short durations.
This allows AWS customers to save money overall since they do not need to upgrade their instance based on highest peak usage.

T4g — Gravitron (ARM), cheaper than T4b
T3a — AMD EPYC, cheaper than T3
T3 — Intel Xeon Scalable, best overall
T2 — Intel Xeon, free tier due to previous generation processors


Standard Mode
(Default): Provides a baseline level of CPU performance with the ability to burst above the baseline using accumulated CPU credits, 
suitable for workloads with variable CPU usage.

Unlimited Mode:
Allows an instance to sustain high CPU performance for any period whenever required, exceeding the baseline and accumulated CPU credits,
 with additional charges applied for the extra CPU usage beyond the accumulated credits.


# EC2 Management Console allows you to observe the system log for the EC2 Instance.
This is useful if you’re trying to troubleshoot an instance on boot to see if anything is wrong.
Some Marketplace and Community AMIs will write the default username and password for software in the System Log for you to initially login.
Get system log
When you experience issues with your EC2 instance, reviewing system logs can help you pinpoint the cause.
Note :
Logs can be delivered to CloudWatch Logs installing the CloudWatch Unified agent and can be accessed through a CloudWatch Log group of the same name as the instance.


Placement Groups let you choose the logical placement of your instances to optimize for communication, performance, or durability. Placement groups are free.

Cluster
packs instances close together inside an AZ
low-latency network performance for tightly-coupled node-to-node communication
well suited for High-Performance Computing (HPC) applications
Clusters cannot be multi-AZ
Partition
spreads instances across logical partitions
each partition does not share the underlying hardware with each other (rack per partition)
well-suited for large distributed and replicated workloads (Hadoop, Cassandra, Kafka)
Spread
Each instance is placed on a different rack
When critical instances should be kept separate from each other
You can spread a max of 7 instances. Spreads can be multi-AZ


1. 🔥 Cluster
👉 Instances très proches les unes des autres

Ultra rapide (faible latence)
Idéal pour : HPC, calcul intensif
❌ Pas multi-AZ

✅ Mot-clé examen : performance maximale

2. 🧩 Partition
👉 Instances séparées en groupes (partitions)

Chaque groupe = hardware différent
Réduit le risque de panne globale
Idéal pour : Big Data (Hadoop, Kafka…)

✅ Mot-clé examen : isolation partielle + distribué

3. 🛡️ Spread
👉 Instances toutes séparées

1 instance = 1 rack
Haute disponibilité
Max 7 instances
✅ Peut être multi-AZ

✅ Mot-clé examen : haute disponibilité / critique

⚡ Astuce rapide pour retenir
Cluster = collé → performance 🚀
Partition = groupes → sécurité + distribué 🧩
Spread = séparé → haute dispo 🛡️

#EC2 – Connect

SSH Client
Connect from your local machine via an SSH connection using a public and private key.
You generate the public and private key on AWS and download the public key.
Port 22 needs to be open on the Security Group to connect

EC2 Instance Connect
Short-lived SSH keys controlled by IAM policies, works only with Linux and not all instances.

Sessions Manager
Connection to Linux or Windows Machine via a reverse connection.
Windows will log into PowerShell, Linux will log into Bash Shell
No need to open ports, access can be controlled via IAM
Supports audit tail of logins

Fleet Manager Remote Desktop
Connect to a Windows Machines using RDP all within the web-browser

EC2 Serial console
Establishes a serial connection giving you direct access for troubleshooting the underlying hardware

🔑 EC2 – Connect (comment se connecter à une instance)
1. 💻 SSH Client
👉 Connexion classique depuis ton PC

Utilise clé publique/privée
Port 22 ouvert obligatoire
Fonctionne surtout avec Linux

✅ À retenir : méthode basique

2. 🔐 EC2 Instance Connect
👉 SSH mais contrôlé par IAM

Clés temporaires (sécurité +)
Pas besoin de stocker des clés
⚠️ Linux seulement

✅ À retenir : SSH + IAM

3. 🖥️ Session Manager
👉 Connexion via AWS (sans SSH)

❌ Pas besoin d’ouvrir de port
Accès contrôlé par IAM
Logs et audit disponibles
Linux (Bash) / Windows (PowerShell)

✅ À retenir : le PLUS sécurisé

4. 🧑‍💼 Fleet Manager (RDP)
👉 Pour Windows uniquement

Connexion bureau à distance (RDP)
Directement depuis navigateur

✅ À retenir : Windows + interface graphique

5. 🛠️ EC2 Serial Console
👉 Accès bas niveau (debug)

Pour troubleshooting avancé
Accès direct au système

✅ À retenir : dépannage

⚡ Astuce examen rapide
🔓 Port fermé ? → Session Manager
🔑 SSH classique ? → SSH Client
🔐 IAM + SSH ? → Instance Connect
🪟 Windows GUI ? → Fleet Manager
🛠️ Problème grave ? → Serial Console

