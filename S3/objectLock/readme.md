## S3 Object Lock – Setting Object Lock on Objects

## Object Locking setting can only be set via the AWS API eg. (CLI, SDK) and not the AWS Console.

```sh
aws s3api put-object \
  --bucket your-bucket-name \
  --key your-object-key \
  --body file-to-upload \
  --object-lock-mode GOVERNANCE \
  --object-lock-retain-until-date "2025-01-01T00:00:00Z"
```
## This is to avoid misconfiguration by non-technical users locking objects.

## S3 Storage Classes Overview

## AWS offers a range of S3 storage classes that trade Retrieval Time, Accessibility and Durability for Cheaper Storage

## S3 Standard (default)
## Fast, Available and Durable. durability 11 9, availabity 4 9 redundancy 3 or more A.Z. 
## S3 Reduced Redundancy Storage (RRS) legacy storage class ancienne classe de stockage conçue pour stocker des données non critiques et reproductibles avec un niveau de redondance plus faible que le stockage standard d’Amazon S3. durability 11 9, availabity 3 9 redundancy 3 or more A.Z. use for disaster recovery backup, long term store, has a retrival fee 

## S3 Intelligent Tiering
## Uses ML to analyze object usage and determine storage class. Extra fee to analyze

## S3 Express One-Zone
## single-digit ms performance, special bucket type, one AZ, x10 faster 50% less cost than Standard, single AZ

## S3 Standard-IA (Infrequent Access)
## Fast, Cheaper if you access less than once a month.
## Extra fee to retrieve. 50% less than Standard (reduced availability)

## S3 One-Zone-IA
## Fast Objects only exist in one AZ. Cheaper than Standard IA by 20% less
## (Reduce durability) Data could get destroyed. Extra fee to retrieve. durability 11 9, availabity 99.5 ideal for secondary backup, there is a retrival fee, mu=inimum storage duration charge of 30 days 

## S3 Glacier Instant Retrieval
## For long-term cold storage. Get data instantly

## S3 Glacier Flexible Retrieval
## takes minutes to hours get data (Standard, Expedited, Bulk Retrieval)

## S3 Glacier Deep Archive
## The lowest cost storage class. Data retrieval time is 12 hours.