# Amazon OpenSearch Service
Amazon OpenSearch Service is a managed full-text search service that makes it easy to deploy, operate, and scale OpenSearch, a popular open-source search and analytics engine.
Two engines can be deployed: OpenSearch and ElasticSearch
OpenSearch is an open-source fork of open-source Elasticsearch 7.10.2 and Kibana 7.10.2. The project was created after Elastic NV changed the license of new versions of this software away from the open-source Apache License in favour of the Server Side Public License (SSPL). AWS was responsible for the development and fork of OpenSearch
https://opensearch.org
Elasticsearch is a search engine based on the Lucene library. Elasticsearch is marketed as free and open
What is the ELK Stack?
Elasticsearch, Logstash, and Kibana are three services commonly used together:
Elasticsearch — full-text search and analytics engine
Logstash — data processing pipeline
Kibana — visualization layer for stored data

# amazone opensource service


# aws sdk java opensearch


# aws sdk python opensearch


# aws sdk ruby opensearch
docs.aws.amazon.com/sdk-for-ruby/v3/api/Aws/OpenSearchService/Client.html
opensearch.org/docs/latest/clients/ruby/

# bundle init to create a Gemfile
# after you have to do bundle install

# docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:ca-central-1:982383527471:domain/mydomain/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::982383527471:user/aws-examples"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:ca-central-1:982383527471:domain/mydomain/*"
    }
  ]
}

