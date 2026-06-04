# What is a Document store?
A document store is a NOSQL database that stores documents as its primary data structure.
A document could be an XML but more commonly is JSON or JSON-Like
Document stores are sub-class of Key/Value stores
The components of a document store compared to Relational database

# Amazon DocumentDB
DocumentDB is a NoSQL document database that is "MongoDB compatible"
MongoDB is very popular NoSQL among developers. There were open-source licensing issues around using open-source MongoDB, so AWS got around it by just building their own MongoDB database.
When you want a MongoDB database.
Cluster types:

Instance based Cluster — manage your instances directly choosing instance type
Elastic Cluster — clusters automatically scale, you choose vCPU and number of instances per shard
Compatible with MongoDB 4.0 and 5.0
DocumentDB does not support all functionality for MongoDB eg. Writable Retries is not support
DocumentDB storage volume grows in increments of 10 GB, up to a maximum of 128 TiB.
Create up-to 15 replicas
Amazon DocumentDB continuously monitors the health of your cluster and automatically restart failed instances
Failover automatically will occur to upto 15 replicas in other AZs
Backup is turned on my default (can't be turned off) with a retention period between 1 and 35 days
    Supports point-in-time recovery
Clusters are deployed into a customer's VPC
Performance Insights feature to determine bottlenecks for reads and writes
In-transit and at-rest encryption. You must connect using TLS connect.


# bundle init
# bundle install 
# bundle exec ruby main.rb

# gemfile
# gem "rails"
gem 'ox'
gem 'mongo'
gem 'pry'



# ruby MongoDB
# mongodb.com/docs/ruby-driver/master/tutorials/quick-start/

# brew install mongo
# brew install mongocli
# brew install mongosh
# mongodb.com/docs/v4.4/mongo/

markdown
## Mongo Shell
sh
brew install mongocli

sh
mongo mongodb://docadmin:password@mydocumentdb-982383527471.us-east-1.docdb-elastic.amazonaws

# AWS Cloud9 Welcome to your development environment
# docs.aws.amazon.com/documentdb/latest/developerguide/connect-from-outside-a-vpc.html
# mongodb.com/docs/ruby-driver/v2.18/reference/driver-compatibility/

# curl -o https://downloads.mongodb.com/compass/mongodb-mongosh_2.2.3_arm64.deb

markdown
## Mongo Shell Ubuntu (Jammy)

Get version of ubuntu

https://www.mongodb.com/docs/mongodb-shell/install/
shlsb_release -a
openssl --version

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
wget -qO- https://www.mongodb.org/static/pgp/server-7.0.asc | sudo tee /etc/apt/trusted.gpg.d/server-7.0.asc
sudo apt-get update
# sudo apt-get install -y mongodb-mongosh-shared-openssl11
sudo apt-get install -y mongodb-mongosh-shared-openssl3
mongosh --version

mongosh mongodb://docadmin:password@mydocumentdb-982383527471.us-east-1.docdb-elastic.amazonaws.com:27017 -tls

# mongodb.com/docs/mongodb-shell/install/

# mongosh mongodb://docadmin:password@mydocumentdb-982383527471.us-east-1.docdb-elastic.amazonaws.com:27017?retryWrites=false -tls

# https://www.mongodb.com/docs/mongodb-shell/run-commands/

# db.myCollection.insertOne( { x: 1 } );
# db.myCollectiontest.myCollection
# db.myCollection.find()
# db.myCollection.find({x: 1})
# mongodb.com/docs/ruby-driver/master/reference/authentication/



