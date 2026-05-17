# What is In-Memory Data Store?
What is Caching?
Caching is the process of storing data in a cache.
A cache is a temporary storage area.
Caches are optimized for fast retrieval with the trade-off that data is not durable.
What is In-Memory Data Store?
When data is stored In-Memory (think of RAM).
The trade-off is high volatility (low durability, risk of data loss), but access to data is very fast.


 
# Introduction to ElastiCache
ElastiCache is a fully managed in-memory datastore for either open-source data stores Memcached or Redis.

ElastiCache is intended to cache data or HTML fragments to greatly improve response times in the range of 10s to 100s of milliseconds.

Key features:
    ElastiCache is only accessible by resources in the same VPC (to ensure low-latency)
    ElastiCache can be deployed in multiple AZs for high availability
    ElastiCache can be deployed on-premise via AWS Outposts
    ElastiCache can use RBAC for Redis 6.0+ so you manage user access via the AWS Management Console
    ElastiCache can be replicated cross-region via ElastiCache Global Datastores
    You can reserve nodes to save money when using ElastiCache Standard

# ElastiCache – Deployment OptionsElastiCache – Deployment Options
ElastiCache has two deployment options:

    ElastiCache (standard mode directly managing nodes in a cluster)
    ElastiCache Serverless

# ElastiCache – Caching Comparison
    Memcached is generally preferred for caching HTML fragments. Memcached is a simple key/value store. The trade-off to being simple is that it's very fast.
    Redis can perform many different kinds of operations on your data. It's very good for leaderboards, and keep track of unread notification data. It's very fast, but arguably not as fast as Memcached.

# Introduction to Redis
What is Redis?
Redis is an open-source in-memory database store. Redis acts as a caching layer, or a very fast database. Since all data is stored in memory it's highly volatile so data loss is possible.

Redis is very fast that it can deliver content from its store with single to double digit milliseconds e.g. 10ms

Redis is a Key / Value store, supports the following data structures:

    Strings
    Sets
    Sorted Sets
    Lists
    Hashes
    Bitmaps
    Bitfields
    HyperLogLog
    Geospatial indexes
    Streams

# Redis – Strings

Redis Strings are the most basic value. Strings are binary safe, so they contain data such as:

JPEG image
Serialized Ruby Objects

String can have a max length of 512 MB
    redis:6379> GET nonexisting
    (nil)
    redis:6379> SET mykey "Hello"
    "OK"
    redis:6379> GET mykey
    "Hello"
Atomic counters can be applied to strings that represent a number:

INCR – add 1
DECR – subtract 1
INCBY – add a certain amount e.g. 10

    redis:6379> SET mykey "10"
    "OK"
    redis:6379> INCR mykey
    (integer) 11
    redis:6379> GET mykey
    "11"

# Redis – Lists
Redis Lists are ordered collection of strings. Lists do not ensure unique strings (you can have duplicates).
    redis:6379> LPUSH mylist "world"
    (integer) 1
    redis:6379> LPUSH mylist "hello"
    (integer) 2
    redis:6379> LRANGE mylist 0 -1
    1) "hello"
    2) "world"

Common commands for lists:

    LPOP – Removes and returns the first elements of the list stored
    RPOP – Remove the last element from the list
    LPUSH – Adds a string to the end of the list
    LPOS – Returns the index of the provided string

# Redis – Sets
Redis Sets are an unordered collection of Strings. Strings are unique within a set, so adding the same string will always only result with one instance.
    redis:6379> SADD myset "Hello"
    (integer) 1
    redis:6379> SADD myset "World"
    (integer) 1
    redis:6379> SADD myset "World"
    (integer) 0
    redis:6379> SMEMBERS myset
    1) "Hello"
    2) "World"
Most popular Set Commands:

    SADD – add one or more members to a set
    SMEMBERS – Get all the members in a set
    SMOVE – move a member from one set to another
    SPOP – remove and return one or multiple random members from a set

# Redis – Hashes
Redis Hashes represent a mapping between string fields and string values to represent an object.
Think of it as a collection of key/value pairs like a:

JSON Object
Ruby Hash
or Python Dictionary

    redis:6379> HMSET myhash field1 "Hello" field2 "World"
    "OK"
    redis:6379> HGET myhash field1
    "Hello"
    redis:6379> HGET myhash field2
    "World"
    Common Commands for Hashes:

    HGET – Get the value of a hash field
    HDEL – Delete one or more hash fields
    HMSET – set multiple hash fields to multiple values
    HMGET – get multiple hash fields to multiple values
    HVALS – Get all the values
    HKEY – Get all the fields in a hash

# Redis – Sorted Sets
Sorted Sets are a collection of strings that are sorted based on an associated score.
Sorted Sets are great for Leaderboards.
    redis:6379> ZADD myzset 1 "one"
    (integer) 1
    redis:6379> ZADD myzset 1 "uno"
    (integer) 1
    redis:6379> ZADD myzset 2 "two" 3 "three"
    (integer) 2
    redis:6379> ZRANGE myzset 0 -1 WITHSCORES
    1) "one"
    2) "1"
    3) "uno"
    4) "1"
    5) "two"
    6) "2"
    7) "three"
    8) "3"
Common Sorted Sets commands:

    ZADD – adds an element to the set with an associated score
    ZREM – removes an element to the set
    ZRANGE – Returns the specified range of elements in the sorted set stored
    ZRANK – Returns the rank of member in the sorted set stored
    ZSCORE – Returns the score of member in the sorted set

# Introduction to Memcached
Memcached is an open-source distributed memory object caching system. It's a caching layer for web-applications.
Memcache is a key/value store which supports Strings it can increment and decrement string if they represent an unsigned 64bit integer.
Use an SDK for your favorite programming language:
ruby# Ruby example
require 'memcached'

    addr = 'localhost:11211'
    cache = Memcached::Client.new(addr)
    cache.set 'test', 'hello'
    cache.get 'test' #=> "hello"

Telnet can be used to interact with Memcached server:

    $ telnet localhost 11211
    Trying 127.0.0.1...
    Connected to localhost.
    set hello 0 100 0
    World
    STORED
    get hello
    VALUE hello 0 10
    World
    END

# Memcached – Common Commands
Set – Write a value at a given key. Will overwrite existing values:
pythonmc.set("another_key", "Another value", time=120)  # Expires in 120 seconds

Get – Read a value at a given key:
pythonvalue = mc.get("some_key")

Delete – deletes the key and its value:
pythonmc.delete("some_key")

Incr – add 1 to the integer value / Decr – add 1 to the integer value:
pythonmc.set("counter", 100)

mc.incr("counter", 1)  # Increases to 101
mc.decr("counter", 1)  # Decreases back to 100

Add – Writes a key but only if it doesn't exist:
pythonmc.add("unique_key", "Unique Value")

Replace – Overwrite key name at given key:
python
mc.replace("existing_key", "New value")
Flush_all – deletes all keys and their values, can be immediately or delayed by providing value in seconds:
python
mc.flush_all()

Append – adds data to the end of a value at a given key:
python
mc.append('message', ' World')

Prepend – adds data to the front of a value at a given key:
python
mc.prepend('message', 'Start: ')

Stats – get various statistics about the datastore:
pythonstats = mc.get_stats()

# docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/WhatIs.html#WhatIs.Overview
# awscli.awscli.amazonaws.com/v2/documentation/api/latest/reference/elasticache/index.html
# aws.amazon.com/blogs/aws/amazon-elasticache-serverless-for-redis-and-memcached-now-generally-available/

# Create Serverless Cache

aws elasticache create-serverless-cache \
--serverless-cache-name my-cache-ab-5252 \
--major-engine-version 7

## Install Redis Client (Ubuntu) 
sudo apt-get install redis-tools


# redis.redis.io/docs/connect/cli/



sh
sudo apt-get install redis -y
sh
# Connect to instance
redis-cli my-cache-ab-5252-ehplt6.serverless.cac1.cache.amazonaws.com:6379

# redis-cli
# 127.0.0.1:6379> set hello world
OK
127.0.0.1:6379> get hello
"world"
127.0.0.1:6379>

#  redis.redis.io/docs/install/install-redis/install-redis-on-linux/
# docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/connect-tls.html

