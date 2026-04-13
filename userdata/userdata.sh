#!/bin/bash
# Update system package repository
sudo yum update -y

# Install Apache (httpd)
sudo yum install -y httpd

# Start Apache service
sudo systemctl start httpd

# Enable Apache to start at boot
sudo systemctl enable httpd

# Create a custom HTML file
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>Welcome to My Website</title>
</head>
<body>
  <h1>Hello, World!</h1>
  <p>This is a custom HTML page served from my Apache server on EC2.</p>
</body>
</html>
EOF

# Restart Apache to apply changes
sudo systemctl restart httpd

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

