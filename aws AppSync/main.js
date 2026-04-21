import { Amplify } from 'aws-amplify';
import config from './aws-exports.js';
import { generateClient } from 'aws-amplify/api';
import * as queries from './graphql/queries';

Amplify.configure(config);

const client = generateClient();


// Simple query
const data = await client.graphql({ query: queries.listMyAppsyncs });
data.data.listMyAppsyncs.items.forEach((element) => console.log(element));