# mkdir datasync
# touch Readme.md

aws s3 mb s3://source-datasync-32523
aws s3 mb s3://dest-datasync-32523

# awscli.amazonaws.com/v2/documentation/api/latest/reference/datasync/index.html
# Upload File

touch hello.txt
aws s3 cp hello.txt s3://source-datasync-32523
aws s3 cp hello.txt s3://source-datasync-32523/data/hello.txt

AWS Auto Scaling
AWS Auto Scaling is a service that can discover scaling resources within your AWS Account, and quickly add scaling plans to your scaling resources. You can have a central inventory for all your scaling resources.
It can manage and make recommendations for the following scaling resources:

    EC2 Auto Scaling Groups
    ECS EC2
    Amazon Aurora
    Amazon DynamoDB
    Spot Fleet

Easily apply:

    Dynamic Scaling (Target Tracking)
    Predictive Scaling

Dynamic scaling — when a metric changes so does the capacity.
Predictive Scaling — analyze historical load, generate a forecast and scale based on that forecast.

