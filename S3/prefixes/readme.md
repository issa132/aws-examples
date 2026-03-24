## Create our bucket
```sh
aws s3 mb s3://prefixes-fun-ab-5235
```

## Create our folder
```sh
aws s3api put-object --bucket="prefixes-fun-ab-5235" --key="hello/"
```