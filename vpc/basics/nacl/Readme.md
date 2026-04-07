# awscli.amazonaws.com/v2/documentation/api/latest/reference/ec2/create-network-acl.html#examples

## Create NACL

aws ec2 create-network-acl --vpc-id vpc-03181823a2da0addd


## Get AMI for Amazon Linux 2 
Amazon Linux 2023 AMI 2023.3.20240205.2 x86_64 HVM kernel-6.1

# Grab the latest AMI2 AMI
```sh
aws ec2 describe-images \
--owners amazon \
--filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" "Name=state,Values=available" \
--query "Images[?starts_with(Name, 'amzn2')]|sort_by(@, &CreationDate)[-1].ImageId" \
--region ca-central-1 \
--output text
```

## -----------------
sh-4.2$ whoami
ssm-user
sh-4.2$ sudo su ec2-user
[ec2-user@ip-10-0-0-18 ~]$ whoami
ec2-user
[ec2-user@ip-10-0-0-18 ~]$ curl
curl: try 'curl --help' or 'curl --manual' for more information
[ec2-user@ip-10-0-0-18 ~]$ wget
wget: missing URL
Usage: wget [OPTION]... [URL]...

Try 'wget --help' for more options.
[ec2-user@ip-10-0-0-18 ~]$ wget localhost:90
--2024-02-14 21:49:10--  http://localhost:90/
Resolving localhost (localhost)... 127.0.0.1
Connecting to localhost (localhost)|127.0.0.1|:90... failed: Connection refused.
[ec2-user@ip-10-0-0-18 ~]$ wget localhost:80
--2024-02-14 21:49:12--  http://localhost:80/
Resolving localhost (localhost)... 127.0.0.1
Connecting to localhost (localhost)|127.0.0.1|:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 72 [text/html]
Saving to: 'index.html'

[ec2-user@ip-10-0-0-18 ~]$ ps aux | grep apache
[ec2-user@ip-10-0-0-18 ~]$ sudo systemctl status httpd


## add a rule to my nacl that blocks inbound traffic from this IP address for AWS using the AWS
# AWS uses the value -1 to represent all traffic regardless of protocol (TCP, UDP, ICMP, etc) 6 = TCP 17 = UDP 1 = ICMP -1 = ALL protocols
# 24.114.92.149/32 c est mon ip et 32 en fait permet de changer juste un ip
aws ec2 create-network-acl-entry \
--network-acl-id acl-xxxxxxxx \
--ingress \
--rule-number 90 \
--protocol -1 \
--port-range From=0,To=65535 \
--cidr-block 24.114.92.149/32 \ 
--rule-action deny