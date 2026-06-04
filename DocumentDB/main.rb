require 'mongo'
require 'pry'


def insert_one collection 
doc = {
  name: 'Steve',
  hobbies: [ 'hiking', 'tennis', 'fly fishing' ],
  siblings: {
    brothers: 0,
    sisters: 1
  }
}

result = collection.insert_one(doc)
puts result.n # returns 1, because one document was inserted

# def insert client
binding.pry
end

def insert_many collection
  docs = [ { _id: 1, name: 'Steve',
      hobbies: [ 'hiking', 'tennis', 'fly fishing' ],
      siblings: { brothers: 0, sisters: 1 } },
    { _id: 2, name: 'Sally',
          hobbies: ['skiing', 'stamp collecting'],
          siblings: { brothers: 1, sisters: 0 } } ]
  result = collection.insert_many(docs)
  puts result.inserted_count # returns 2 because two documents were inserted
  binding.pry
end

def query collection
  collection = client[:people]
  collection.find.each do |document|
  puts document.inspect
  end 
    binding.pry
 
end


# client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'test')
# client = Mongo::Client.new('mongodb://127.0.0.1:27017/test') 
# client = Mongo::Client.new([ 'mydocumentdb-982383527471.us-east-1.docdb-elastic.amazonaws.com' ], :database => 'test')
client = Mongo::Client.new('mongodb://docadmin:password@mydocumentdb-982383527471.us-east-1.docdb-elastic.amazonaws.com:27017')

# client = Mongo::Client.new(
#  ['mydocumentdb-982383527471.us-east-1.docdb-elastic.amazonaws.com:27017'],
#  user: 'docadmin',
#  password: 'password',
#  database: 'test',
#  retry_writes: false
#  ssl: true
# )

 

db = client.database
#collection = client[:people]
collection = db[:people]
insert_one(collection)
query(collection)

# insert(collection)
binding.pry


