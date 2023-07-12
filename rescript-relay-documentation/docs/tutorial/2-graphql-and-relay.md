---
id: tutorial-graphql
title: GraphQL and Relay
sidebar_label: GraphQL and Relay
---

# GraphQL and Relay

This section is an overview to situate Relay in relation to GraphQL, React, and the other parts of the stack. Don’t worry about understanding every detail, just try to get the gist and the proceed to the next section to start working with code. Specifics will be explained with working examples throughout the tutorial.

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

---

GraphQL is a language for querying and modifying data on servers. The unique thing about GraphQL is that rather than having a fixed set of API endpoints, your server provides a palette of options that the client can use to request any combination of data that it may need. This allows front-end developers to move more quickly because there is no need to write and deploy new endpoints as data requirements change. It also means that when a new version of the client is released, it can request just the data it needs, without extra fields leftover for compatibility with older versions.

GraphQL provides a unified interface for querying data across any kind of back-end. Whether your data is in a relational SQL database, a graph-oriented database, or an armada of microservices, a GraphQL server can collect the data from multiple back-ends and send it to the client in a single response. This is much more efficient than issuing separate queries to each service from the client.

In a traditional HTTP API, there are URLs that respond with a fixed set of information:

```json
Request:
GET /person?id=24601

Response:
{"id": "24601", "name": "Jean Valjean", "age": 64, "occupation": "Mayor"}
```

In GraphQL, the client asks for the specific information that it wants and the server responds with just the information that was requested:

```json
Request:
query {
  person(id: "24601") {
    name
    occupation
  }
}

Response:
{
  "person": {
    "name": "Jean Valjean",
    "occupation": "Mayor"
  }
}
```

Notice that only the specific fields that the client requested were included in the response.

As the name suggests, GraphQL organizes data into a _graph_. The graph consists of _nodes_ (like objects or records) and _edges_ (pointers from one node to another):

![Nodes with fields connected by edges](/img/docs/tutorial/graphql-graph-detail.png)

Nodes have fields. Fields can be either `Scalars`, primitive types like strings or dates, or `Objects`, which are (edges to) other Nodes. GraphQL lets you follow those edges from one node to another and ask for information about each node that you visit. Let's pretend that the `Person` type has this GraphQL schema definition.

```gql
type Person {
  id: ID!
  name: String
  age: Int
  occupation: String
  location: Location
}
```

`Person` has 4 scalar fields and 1 object field. `ID` is an id type and by convention is a unique identifier for a particular `Person`. In Relay, id's are globally unique, but they need not be in other GraphQL frameworks. To make the id easier to read, we here use "24601". 

The `!` after `ID` means that the field is non-nullable. It is an error if a query requests a non-nullable field which turns out to be null at runtime. It's generally considered good pratice to design your schema so that as many fields as possible are nullable (i.e. don't have the `!`). The intricacies of schema design are beyond the scope of this tutorial so for now just take our word for it!

Let's say that `Location` has this definition:

```gql
type Location {
  id: ID!
  name: String
  population: Int
}
```

`Location` has 3 scalar fields and no object fields. That means that a traversal ends in `Location`. You cannot go "back up" to the person you came from.

There are three top-level nodes, `Query`, `Mutation`, and `Subscription`. This tutorial covers the first two. `Query` is a special node on which you add your entry-points into the graph when querying for data. You can think of this as the equivalent to `GET` endpoints in a traditional REST API.

For a simple app with only one query field, the definition of `Query` looks like this:

```gql
type Query {
  person(id: ID!): Person
}
```

`person` is a field that takes a required argument with name `id` and type `ID` and returns an optional (i.e. not non-nullable) `Person`. `Person` is optional because there might not be a person with the supplied id. We could also have something like

```gql
type Query {
  personByName(name: String!): [Person]
}
```

Here, `personByName` takes a required `name` and returns an optional list of optional `Person`. E.g. if we do `personByName(name: "P")`, we can get a list of people that have "P" in their name (depending on the exact implementation).

But back to `person(id: ID!)`. Let's say we want to show the person with id `24601`'s name and occupation, as well as the name and population of where they are. 

With `GET /person?id=24601` you either have to hope that the response you get back includes the information that you want or handle this somehow, for instance by changing the implementation of it.

In GraphQL you start with `query`, pick a field that gives you entry into the graph, and then explicitly ask for the fields that you are interested in.

Let's say we want to show the person with id `24601`'s name and occupation, as well as the name and population of where they are. We start from `query` and use `person(id: "24601")` to select that person. On that person, we select `name`, `occupation`, and `location`. And on `location`, we select `name` and `population`. That looks like this:

<Tabs>
  <TabItem value="1" label="Request" default>

```
query {
  person(id: "24601") {
    name
    occupation
    location {
      name
      population
    }
  }
}
```

![Query diagram](/img/docs/tutorial/graphql-request.png)

  </TabItem>
  <TabItem value="2" label="Response">

```
{
  "person": {
    "name": "Jean Valjean",
    "occupation": "Mayor",
    "location": {
      "name": "Montreuil-sur-Mer",
      "population": 1935
    }
  }
}
```

![Response diagram](/img/docs/tutorial/graphql-response.png)

  </TabItem>
</Tabs>

This means we can retrieve information about a whole panoply of objects all in one query — in others words, you can efficiently get all the data for a screen in a single request instead of sending many requests one after the other and you achieve this without _writing and maintaining a separate endpoint for each screen in your UI_.

Instead, your GraphQL server provides a _schema_, which describes what kinds of nodes there are, how they’re connected, and what information each node contains. Then, you pick and choose from this schema to select the information you want.

The example app in this tutorial is a newsfeed app, so its schema consists of types such as

- `Story`, which represents a newsfeed story — it has fields such as its title, an image, and an _edge_ to the person or organization who posted it
- `Person`, with information such as their name, email, and a list of friends (which are edges to other Persons).
- `Viewer`, which represents the person viewing the app and has information like their list of newsfeed stories
- `Image`, which has a URL for the image itself as well as an `alt` text description.

The GraphQL language includes a type system and language for specifying the schema. Here’s a snippet from the schema definition for our example app — don’t worry about every detail, it’s just to give you a general idea:

```gql
// A newsfeed story. It has fields, some of which are scalars (e.g. strings
// and numbers) and some that are edges that point to other nodes in the graph,
// such as the 'thumbnail' and 'poster' fields:
type Story {
  id: ID!
  category: Category
  title: String
  summary: String
  thumbnail: Image
  poster: Actor
}

// An Actor is an entity that can do something on the site. This is an
// interface that multiple different types can implement, in this case
// Person and Organization:
interface Actor {
  id: ID!
  name: String
  profilePicture: Image
}

// This is a specific type that implements that interface:
type Person implements Actor {
  id: ID!
  name: String
  email: String
  profilePicture: Image
  location: Location
}

// The schema also lets you define enums, such as the category
// of a newsfeed story:
enum Category {
  EDUCATION
  NEWS
  COOKING
}
```

Besides queries, GraphQL also lets you send _mutations_ that ask the server to update its data. If queries are analogous to HTTP GET requests, then mutations are the equivalent of POST requests. Like POSTs, they let the server respond with updated data. GraphQL also has _subscriptions_ which allow for an open connection for realtime updates.

(GraphQL is usually implemented over HTTP, so queries and mutations are not only _analogous_ to GET and POST, but may be sent as such as well.)

---

Now that we’ve talked about GraphQL, let’s talk about Relay. It has a few different parts and pieces that we’ll briefly go over before diving into the code.

Relay is a data management library for the client that’s oriented around GraphQL, but uses it in a very specific way that gets the most benefit from it.

For the best performance, you want your app to issue a single request at the beginning of each screen or page instead of having individual components issue their own requests. But the problem with that is that it couples components and screens together, creating a big maintenance problem: If you need some additional data in a specific component, you have to find every screen where that component is used and add the new field to that screen’s query. On the other hand, if you remove the need for a particular field, you have to remove that field from every query again — but this time, are you sure the field isn’t still in use by some _other_ component? It becomes very difficult to maintain these big screen-wide queries.

One of Relay’s unique strengths is avoiding this tradeoff by letting each component declare its own data requirements locally (called a _Fragment_) in the component and then combininng those requirements together into a top-level query for a screen. Relay does this with a _compiler_ that scans your ReSCript code for fragments of GraphQL and then stitches those fragments together into complete queries. 

If you want to use a component on more than on screen, you just render that component, wire in Fragment into the parent component's fragment, and the Relay compiler will take care of the rest. If two (or three or four) different components request the same data (e.g. the name of a person), the compiler will deduplicate it for you. Under the hood, the name is only requested once.

This way, you get both performance, maintainability, and composability.

![The Relay Compiler combines fragments into a query](/img/docs/tutorial/graphql-compiler-combines-fragments.png)

Besides the compiler, Relay has runtime code that manages the fetching and processing of GraphQL. It maintains a local cache of all the data that has been retrieved (called the _Store_), and vends out to each component the data that belongs to it:

![The Relay Runtime fetches the query and vends out the appropriate data to each component according to its fragment](/img/docs/tutorial/graphql-relay-runtime-fetches-query.png)

The advantage of having a centralized Store is that it lets you keep your data consistent when it’s updated. For instance, if your UI has a way for somebody to edit their name, then you can make that update in a single place and every component that displays that person’s name will see the new information, even if they’re on different screens and therefore used different queries to initially retrieve the data. This is because Relay _normalizes_ the data as it comes in, meaning that it merges all the data it sees for a single graph node into one place, so it doesn’t have multiple copies of the same node.

Indeed, Relay doesn’t just query data, it provides for the entire lifecycle of querying and updating, including support for optimistic updates and rollbacks. You can paginate, refresh data — all of the basic operations you’ll need to create a UI. Whenever data in the Store is updated, Relay efficiently re-renders just those components that are displaying that particular data.

## Summary

GraphQL is a language for modeling data as a graph and querying and updating that data from a server. Relay is a React-based client library for GraphQL that lets you build up queries from individual fragments that are co-located with each React component. Once the data has been queried, Relay maintains consistency and re-renders components as the data is updated.
