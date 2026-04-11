# AWS Identity and Access Management (IAM)
Cheat sheets, Practice Exams and Flash cards 👉 www.exampro.co/ssa-c03

AWS Identity and Access Management (IAM) you can create and manage AWS users and groups, and use permissions to allow and deny their access to AWS resources.

IAM Policies
JSON documents which grant permissions for a specific user, group, or role to access services. Policies are attached to IAM Identities

IAM Permission
The API actions that can or cannot be performed. They are represented in the IAM Policy document

IAM Identities

IAM Users
End users who log into the console or interact with AWS resources programmatically or via clicking UI interfaces

IAM Groups
Group up your Users so they all share permission levels of the group
eg. Administrators, Developers, Auditors

IAM Roles
Roles grant AWS resources permissions to specific AWS API actions
Associate policies to a Role and then assign it to an AWS resource

# Managed Policies
A policy that is managed by AWS, which you cannot edit. Managed policies are labeled with an orange box

# Customer Managed Policies
A policy created by the customer which is editable. Customer policies have no symbol beside them.

# Inline Policies
A policy that is directly attached to the user.

# Exemple policy:
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Statement1",
      "Effect": "Allow",
      "Action": ["ec2:*"],
      "Resource": ["*"]
    }
  ]
}


# IAM Policies are written in JSON, and contain the permissions which determine what API actions are allowed or denied.

Version policy language version. 2012-10-17 is the latest version.
Statement container for the policy element you are allowed to have multiples
Sid (optional) a way of labeling your statements.
Effect Set whether the policy will Allow or Deny
Action list of actions that the policy allows or denies
Principal account, user, role, or federated user to which you would like to allow or deny access
Resource the resource to which the action(s) applies
Condition (optional) circumstances under which the policy grants permission

{
  "Version": "2012-10-17",
  "Statement": [{
    "Sid": "Deny-Barclay-S3-Access",
    "Effect": "Deny",
    "Action": "s3:*",
    "Principal": {"AWS": ["arn:aws:iam::123456789012:barclay"]},
    "Resource": "arn:aws:s3:::my-bucket"
  },{
    "Effect": "Allow",
    "Action": "iam:CreateServiceLinkedRole",
    "Resource": "*",
    "Condition": {
      "StringLike": {
        "iam:AWSServiceName": [
          "rds.amazonaws.com",
          "rds.application-autoscaling.amazonaws.com"
        ]
      }
    }
  }]
}

# Principle of Least Privilege (PoLP) is the computer security concept of providing a user, role, or application the least amount of permissions to perform a operation or action.
Just-Enough-Access (JEA)
Permitting only the exact actions for the identity to perform a task
Just-In-Time (JIT)
Permitting the smallest length of duration an identity can use permissions
Risk-based adaptive policies
Each attempt to access a resource generates a risk score of how likely the request is to be from a compromised source. The risk score could be based on many factors e.g. device, user location, IP address what service is being accessed and when.

AWS at the time of this recording does not have Risk-based adaptative policies built into IAM

ConsoleMe is an open-source Netflix project to self-serve short-lived IAM policies so an end user can access AWS resources while enforcing JEA and JIT
https://github.com/Netflix/consoleme

# aws sts get-caller-identity

