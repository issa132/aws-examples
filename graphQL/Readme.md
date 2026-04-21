GraphQL is an open-source agnostic query adaptor that allows you to query data from many different data sources.
GraphQL is used to build APIs where clients will send a query for nested data.
GraphQL mitigates the issue of versioned or rapidly changing APIs compared to REST API because you can request the data you w...
GraphQL schemas are written in the GraphQL SDL (Schema Definition Language) composed of:

Types
Fields
Queries
Mutations
Subscriptions

Type
Represent objects and their fields
graphqltype Query {
  me: User
}

type User {
  id: ID
  name: String
}
Queries — defines the exact shape of the data needed by the client.
graphqlquery CurrentUser {
  currentUser {
    name
    age
  }
}
Mutations — allows for data to be created, updated, or deleted.
graphqlmutation CreateUser($name: String!, $age: Int!) {
  createUser(userName: $name, age: $age) {
    name
    age
  }
}
Subscriptions — supports live updates sent from the server to client
graphqlsubscription {
  newPerson {
    name
    age
  }
}

