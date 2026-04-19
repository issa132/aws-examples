# mkdir datasync
# touch Readme.md

aws s3 mb s3://source-datasync-32523
aws s3 mb s3://dest-datasync-32523

# awscli.amazonaws.com/v2/documentation/api/latest/reference/datasync/index.html
# Upload File

touch hello.txt
aws s3 cp hello.txt s3://source-datasync-32523
aws s3 cp hello.txt s3://source-datasync-32523/data/hello.txt

