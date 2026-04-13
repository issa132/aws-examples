# Elastic Compute Cloud (EC2) is a highly configurable virtual server.
EC2 is resizable compute capacity. It takes minutes to launch new instances.
Anything and everything on AWS uses EC2 Instance underneath.
AMI = Operating system


# Cloud-init is the industry standard multi-distribution method for cross-platform cloud instance initialization. It is supported across all major public cloud providers, provisioning systems for private cloud infrastructure, and bare-metal installations.
What is Cloud Instance Initialization?
The process of preparing an instance with configuration data for the operation system and runtime environment.
Cloud instances are initialized from a disk image and instance data:

    Meta-data
    User-data
    Vendor-data

User Data is a script that you want to run when an instance first boots up. eg. Install Apache web-server

# cloud-init.io

#cloud-config

package_update: true
package_upgrade: true
packages:
  - httpd

write_files:
  - path: /var/www/html/index.html
    content: |
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
    owner: root:root
    permissions: '0644'

runcmd:
  - systemctl start httpd.service
  - systemctl enable httpd.service
  - systemctl restart httpd.service

# Ce fichier cloud-init configure automatiquement un serveur web Apache sur une instance EC2 au premier démarrage. au premier boot de l'instance EC2, ce script installe et configure automatiquement un serveur web Apache qui sert une page HTML personnalisée, sans aucune intervention manuelle. 

# docs.aws.amazon.com/managedservices/latest/userguide/access-to-logs-ec2.html

# EC2 user' data 
You can provide a script to EC2 UserData to have Cloud Init automatically run on first boot.
You can provide a bash script
bash#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd.service
systemctl enable httpd.service
echo "<html><h1>Hello Cloud!</h1></html>" > /var/www/html/index.html

# You can provide a cloud config yaml file
yaml#cloud-config
package_upgrade: true
packages:
  - httpd
runcmd:
  - [ systemctl, start, httpd.service ]
  - [ systemctl, enable, httpd.service ]
  - [ sh, -c, "echo '<html><body><h1>Hello Cloud!</h1></body></html>' > /var/www/html/index.html" 

Scripts must be base64 when directly using the API, The AWS CLI and Console will automatically encode to base64

Via the AWS CLI you can pass a file
```sh
aws ec2 run-instances \
    --image-id ami-0abcdef1234567890 \
    --count 1 \
    --instance-type t2.micro \
    --security-group-ids sg-1234567890abcdef0 \
    --subnet-id subnet-12345678 \
    --user-data file://path/to/your/userdata-script.sh
```

Or you can provide the script inline
```sh
shaws ec2 run-instances \
    --image-id ami-0abcdef1234567890 \
    --count 1 \
    --instance-type t2.micro \
    --security-group-ids sg-1234567890abcdef0 \
    --subnet-id subnet-12345678 \
    --user-data '#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<html><h1>Welcome to Apache Server on EC2</h1>
</html>" > /var/www/html/index.html'
```

Using EC2 Metadata you can get the script via wget or curl at the following http://169.254.169.254/latest/user-data


