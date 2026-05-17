Amazon MemoryDB
Amazon MemoryDB is a Redis-compatible in-memory database for ultra-fast performance.

    * MemoryDB additional persistence guarantees over ElastiCache making MemoryDB suitable as a primary database.
    * MemoryDB writes are in the Milliseconds where ElastiCache writes are in the microseconds

        * You get slower write but a guarantee of persistent of data for MemoryDB

# awscli.amazonaws.com/v2/documentation/api/latest/reference/memorydb/index.html
# awscli.amazonaws.com/v2/documentation/api/latest/reference/memorydb/index.html#cli-aws-memorydb
#  docs.docs.aws.amazon.com/memorydb/latest/devguide/getting-started.createcluster.html




# Create Subnet Group

```sh
aws memorydb create-subnet-group \
  --subnet-group-name mysubnetgroup \
  --description "my subnet group" \
  --subnet-ids subnet-0e0fd31733061237d
```


aws memorydb create-subnet-group \
  --subnet-group-name mysubnetgroup \
  --description "my subnet group" \
  --subnet-ids subnet-0e0fd31733061237d subnet-0377c6b172e2951d4 \
  --query SubnetGroup.ARN \
  --output text

# dont use the default vpc, create a vpc with subnet

# Create User

aws memorydb create-user \
  --user-name user-name-1 \
  --access-string "~objects:* ~items:* ~public:*" \
  --authentication-mode \
    Passwords="enterapasswordhere",Type=password

aws memorydb create-user \
  --user-name issa132 \
  --access-string "~objects:* ~items:* ~public:*" \
  --authentication-mode Passwords="Testing123456!",Type=password

# docs.docs.aws.amazon.com/memorydb/latest/devguide/clusters.acls.html

aws memorydb create-user \
  --user-name andrewbrown \
  --access-string "on ~* &* +@all" \
  --authentication-mode Passwords="Testing123456!",Type=password




# Create ACL

```sh
aws memorydb create-acl \
  --acl-name "new-acl-1" \
  --user-names "issa132"
```





# Create Cluster

```sh
aws memorydb create-cluster \
  --cluster-name my-new-cluster \
  --node-type db.t4g.small \
  --acl-name new-acl-1 \
  --subnet-group mysubnetgroup
```


# redis-cli -h clustercfg.my-new-cluster.ehplt6.memorydb.ca-central-1.amazonaws.com --tls
# redis-cli -h clustercfg.my-new-cluster.ehplt6.memorydb.ca-central-1.amazonaws.com --tls --user andrewbrown --pass Testing123456789012345678901