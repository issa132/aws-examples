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

# the next 3 storages are similar to s3 glacier but with better convenience and flexibility

## S3 Glacier Instant Retrieval
## For long-term cold storage. Get data instantly 



## S3 Glacier Flexible Retrieval
## takes minutes to hours get data (Standard, Expedited, Bulk Retrieval). part of S3 glacier vault, rarely access but still need immediate access. durability 11 9, availabity 3 9 redundancy 3 , Cost: 68% lower than standard IA, long lived data access once per quarter (once per month). ex image hosting, medical imaging, satellite image... has retrival fees, min storage duration of 90days

## Les 3 niveaux de récupération
# ⚡ 1. Expedited Tier (rapide)
# ⏱️ 1 à 5 minutes
# 💰 Le plus cher
# 📦 Limite : 250 MB max
# 👉 Pour les urgences (ex : besoin immédiat d’un fichier)
# ⏳ 2. Standard Tier (normal)
# ⏱️ 3 à 5 heures
# 💰 Prix moyen
# 📦 Pas de limite de taille
# 👉 Option par défaut (le plus utilisé)
# 🐢 3. Bulk Tier (lent)
# ⏱️ 5 à 12 heures
# 💰 Le moins cher
# 📦 Pas de limite (même très gros volumes)
# 👉 Pour récupérer beaucoup de données sans urgence

## S3 Glacier Deep Archive (FORMALLY S3 GLACIER)
## The lowest cost storage class. Data retrieval time is 12 hours. part of S3 glacier vault(use vault over bucket). combine s3 and glacier in single set of API

# Standard Tier → 12 hours
# Bulk Tier → 48 hours

