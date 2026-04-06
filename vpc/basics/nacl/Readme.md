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