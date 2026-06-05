# Amazon Neptune ML
Use graph neural networks (GNNs), a machine learning (ML) technique purpose-built for graphs, to make easy, fast, and more accurate predictions using graph data.

Amazon Neptune Database
Neptune database has two types:

    Neptune Provisioned — You choose an instance type
    Neptune Serverless — A serverless offering. You set a min and max Neptune Capacity Units (NCU)



    Neptune database support Multi-AZ deployment
    Neptune has two storage configuration:

        Neptune I/O Optimized — increased Input/Output for additional cost
        Neptune Standard — 25% than I/O Optimized


You can create a Jupyter Notebook (within Amazon SageMaker Notebook) that includes magic extensions to easily work with your Neptune database.

Neptune Bulk Loader can be used to import large amounts of data

AWS has multiple built-in or third-party options for visualizing your graph database:
    The open-source graph-explorer
    Tom Sawyer Software
    Cambridge Intelligence
    Graphistry
    metaphacts
    G.V( )

# What is Gremlin?
Gremlin is the graph traversal language for Apache TinkerPop

groovy
g.V().has("name","gremlin").as("a").
  out("created").in("created").
    where(neq("a")).
    groupCount().by("title")

Gremlin is designed to the "Write once, run anywhere" (WORA)
Gremlin traversal can be evaluated as:
    real-time database query (OLTP)
    or as a batch analytics query (OLAP)

# What is OpenCypher?
OpenCypher is an open source implementation of Cypher (the graph query language used by Neo4J)
Cypher is known for being more developer friendly for writing queries than using Gremlin.
Gremlin is generally more proficient at traversal depending on the use-case.

cypher# Creating
CREATE (a:Person {name: 'Alice', age: 24})
CREATE (b:Person {name: 'Bob', age: 22})
CREATE (a)-[:KNOWS {since: 2021}]->(b)

# Querying
MATCH (p:Person)
RETURN p.name, p.age

MATCH (a:Person {name: 'Alice'})-[:KNOWS]-(b:Person {name: 'Bob'})
RETURN a.name, b.name

# Updating
MATCH (b:Person {name: 'Bob'})
SET b.age = 23
RETURN b.name, b.age

# Advanced Query
MATCH (alice:Person {name: 'Alice'})-[:KNOWS]->(bob:Person)-[:KNOWS]->
(friendsOfBob)
WHERE NOT (alice)-[:KNOWS]->(friendsOfBob)
RETURN friendsOfBob.name AS RecommendedFriend

# What is SPARQL?
SPARQL (Sparkle) is a Resource Description Framework (RDF) query language. SPARQL allows users to write queries against what can loosely be called "key-value" data or, data that follow the RDF specification of the W3C.

Setting up sample data
sparql@prefix : <http://example.org/> .

:Alice a :Person ;
       :name "Alice" ;
       :age 24 ;
       :knows :Bob .

:Bob a :Person ;
     :name "Bob" ;
     :age 22 .

Updating data
sparqlPREFIX : <http://example.org/>
DELETE {
  :Bob :age 22 .
}
INSERT {
  :Bob :age 23 .
}
WHERE {
  :Bob :age 22 .
}

Querying data
sparqlPREFIX : <http://example.org/>
SELECT DISTINCT ?name
WHERE {
  :Alice :knows/:knows ?person .
  ?person :name ?name .
  FILTER NOT EXISTS { :Alice
  :knows ?person }
}

# docs.docs.aws.amazon.com/neptune/latest/userguide/intro.html