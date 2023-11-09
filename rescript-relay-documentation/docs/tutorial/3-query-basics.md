---
id: tutorial-queries-1
title: Query Basics
sidebar_label: Query Basics
---

# Query Basics

In this section:

- We’ll take a React component that displays hard-coded placeholder data and modify it so that it fetches its data using a GraphQL query.
- We’ll learn how to use the ReScript types that RescriptRelay generates from your GraphQL to ensure type safety.

---

With Relay, you fetch data using GraphQL Queries. A Query specifies a part of the GraphQL graph for your app to fetch, starting from some root node and traversing from node to node to retrieve a particular set of data in the shape of a tree.

![A query selects a particular subgraph](/img/docs/tutorial/query-upon-graph.png)

Right now, our example app doesn’t fetch any data, it just renders some placeholder data that’s hard-coded into the React components. Let’s modify it to fetch some data using Relay.

Open up the file called `Newsfeed.res`. (All of the components in the tutorial are in `src/components`.) In it you should see a `<Newsfeed>` component where the data is hard-coded:

```rescript
@react.component
let make = () => {
  let story: Story.story = {
    title: "Placeholder Story",
    summary: "Placeholder data, to be replaced with data fetched via GraphQL",
    poster: {
      name: "Placeholder Person",
      profilePicture: Some({
        url: "/assets/cat_avatar.png",
      }),
    },
    thumbnail: Some({
      url: "/assets/placeholder.jpeg",
    }),
  }

  <div className="newsfeed">
    <Story story={story} />
  </div>
}

```

We’re going to replace this placeholder data with data fetched from the server. First we need to define a GraphQL query. Add the following declaration above the Newsfeed component:

```rescript
// color1
module NewsfeedQuery = %relay(`
  // color2
  query NewsfeedQuery {
    topStory {
      // color3
      title
      // color3
      summary
      // color4
      poster {
        name
        profilePicture {
          url
        }
      }
      thumbnail {
        url
      }
    }
  }
`)
```

Let’s break this down:

- To embed GraphQL within ReScript, we write a string literal <span class="color1">marked with the <code>%relay(``)</code> tag</span>. This tag allows the Relay compiler to find and compile the GraphQL within a ReScript codebase.
- Our GraphQL string consists of a <span class="color2">query declaration</span> with the keyword `query` and then a query name.
- Inside the query declaration are _fields_, which specify what information to query for*:*
  - Some fields are _<span class="color3">scalar fields</span>_ that retrieve a string, number, or other unit of information.
  - Other fields are _<span class="color4">edges</span>_ that let us traverse from one node in the graph to another. When a field is an edge, it’s followed by another block `{ }` containing fields for the node at the other end of the edge. Here, the `poster` field is an edge that goes from a Story to a Person who posted it. Once we’ve traversed to the Person, we can include fields about the Person such as their `name`.
- Finally, while you can call the `module` anything you like, the query name (i.e. the stuff that comes right after `query`) must follow relay conventions. A query must start with the name of the component in which it is used and end in "query". That means valid names for this query is e.g. `NewsfeedQuery` and `NewsfeedTopStoryQuery`, but not `MainNewsfeedQuery` or `NewsfeedTopStory`. Don't worry about remembering these rules, the compiler will tell you!

This illustrates the part of the graph that this query is asking for:

![Parts of the GraphQL query](/img/docs/tutorial/query-breakdown.png)

Now that we’ve defined the query, we need to modify our React component to fetch it and to use the data returned by the server.

Turn back to the `Newsfeed` component and start by deleting the placeholder data. Then replace it with this (which is supposed to not compile, so don't panic when you see the errors!):

```rescript
@react.component
let make = () => {
  let data = NewsfeedQuery.use(~variables=(), ())

  switch data.topStory {
  | None => React.null
  | Some(topStory) =>
    <div className="newsfeed">
      <Story story={(topStory :> Story.story)} />
    </div>
  }
}
```

`topStory` returned by the query has type `NewsfeedQuery_graphql.Types.response_topStory`. Since this is compatible with the type `Story.story` expected by the `story` prop, we can use `:>` is needed to convert `topStory` into the expected type. This is necessary because ReScript uses nominal types. See the Deep Dive below for more.

<details>
<summary>Deep dive: Nominal vs Structural types</summary>

We add the `:>` operator, to convert the type returned by the query into the type `Story.story`. We do this because ReScript has what is called nominal types. Typescript, which you may be familiar with, uses structural types. 

```typescript
type A = { name: string }
type B = { name: string }
type C = A & { age: number }

const acceptsA = (arg: A) => {
  console.log(arg.name)
}

const valA: A = { name: 'Jean Valjean' }
const valB: B = { name: 'Jean Valjean' }
const valC: C = { name: 'Jean Valjean', age: 64 }

acceptsA(valA)
acceptsA(valB)
acceptsA(valC)
```

This, on the other hand, is _not_ valid ReScript

```rescript
type a = {name: string}
type b = {name: string}
type c = {...a, age: int}

let acceptsA = (arg: a) => {
  Js.log(arg.name)
}

let valA: a = {name: "Jean Valjean"}
let valB: b = {name: "Jean Valjean"}
let valC: c = {name: "Jean Valjean", age: 64}

acceptsA(valA)
acceptsA(valB)
acceptsA(valC)
```

and will give you compile errors at 
```
45 │ acceptsA(valB)

  This has type: b
  Somewhere wanted: a
```
and
```
 46 │ acceptsA(valC)

  This has type: c
  Somewhere wanted: a
```

If you instead do 

```rescript
acceptsA((valB :> a))
acceptsA((valC :> a))
```

Then your code will compile. "WHY?"
</details>

Even with `:>` you'll still compiler errors, because the placeholder data and the starting components do not take into account that the schema has all fields except `id` nullable.

While it is good schema design to make fields nullable by default, it can be tedioous to have to handle nulls everywhere. Relay has a `@required` _directive_ that handles this for you. You add it to fields in your query, specifying what Relay should do if the field is (unexpectedly) null. There are three different options. The one we will use here is `NONE`. If a `@required(action: NONE)` field is null, it's parent will be null.

:::tip
If and how to use the `@required` directive depends on your particular use cases. If a component can meaningfully display information when some of it's child components cannot get their data (e.g. due to auth or a backend error), you should (probably) not make the field required. If a componant cannot show something meaningful, then you (probably) _should_ make the field required. In this tutorial we will plaster `@required` on everything nullable
:::

:::tip
The required directive only applies _locally_ when data is pulled out of the store in a query or fragment. If component A uses `required` for a field that component B does not use `required` for, then only A will be affected, even if A is the component to fetch the data.

This is part of Relay's promise that you should only need to reason about data requirements locally.
:::

To make the code compile, add `@required` directives to our query:

```rescript
module NewsfeedQuery = %relay(`
  query NewsfeedQuery {
    topStory {
      title @required(action: NONE)
      summary @required(action: NONE)
      poster @required(action: NONE) {
        name @required(action: NONE)
        profilePicture @required(action: NONE) {
          url
        }
      }
      thumbnail @required(action: NONE) {
        url
      }
    }
  }
`)
```

If _any_ of the `required` fields are null, their parent will be null. If the parent is `required` their parent will be null and so one all the way up to `topStory`.

The `NewsfeedQuery.use` hook fetches and returns the data. It always expects <span className="color2">`variables`</span>. Since this query has no variables, we pass in unit (`()`).

The object that `NewsfeedQuery.use` returns has the same shape as the query. For instance, if printed in JSON format it might look like this:

```json
{
  topStory: {
    title: "Local Yak Named Yak of the Year",
    summary: "The annual Yak of the Year awards ceremony ...",
    poster: {
      name: "Baller Bovine Board",
      profilePic: {
        url: '/images/baller_bovine_board.jpg',
      },
    },
    thumbnail: {
      url: '/images/max_the_yak.jpg',
    }
  }
}
```

Notice that each field selected by the GraphQL query corresponds to a property in the JSON response.

At this point, you should see a story fetched from the server:

![Screenshot](/img/docs/tutorial/queries-basic-screenshot.png)

:::note
The server's responses are artifically slowed down to make loading states perceptible, which will come in handy when we add more interactivity to the app. If you want to remove the delay, open `server/index.js` and remove the call to `sleep()`.
:::

The `NewsfeedQuery.use` hook fetches the data when the component is first rendered. Relay also has APIs for pre-fetching the data before your app has even loaded — these are covered later. In any case, Relay uses Suspense to show a loading indicator until the data is available.

This is Relay in its most basic form: fetching the results of a GraphQL query when a component is rendered. As the tutorial progresses, we’ll see how Relay’s features fit together to make your app more maintainable — starting with a look at how Relay generates ReScript types corresponding to each query.

<details>
<summary>Deep dive: Suspense for Data Loading</summary>

_Suspense_ is an API in React that lets React wait while data is loaded before it renders components that need that data. When a component needs to load data before rendering, React shows a loading indicator. You control the loading indicator's location and style using a special component called `Suspense`.

Right now, there's a `Suspense` component inside `App.res`, which is what shows the spinner while `NewsfeedQuery.use` is loading data.

We'll look at Suspense in more detail in later sections when we add some more interactivity to the app.

</details>

<details>
<summary>Deep dive: Queries are Static</summary>

All of the GraphQL strings in a Relay app are pre-processed by the Relay compiler and removed from the resulting bundled code. This means you can’t construct GraphQL queries at runtime — they have to be static string literals so that they’re known at compile time. This comes with major advantages:

First, it allows Relay to generate type definitions for the results of the query, making your code more type-safe.

Second, RescriptRelay connects the GraphQL string literal with an object that tells Relay what to do. This is much faster than using the GraphQL strings directly at runtime.

Also, Relay’s compiler can be configured to [save queries to the server](/docs/guides/persisted-queries/) when you build your app, so that at runtime the client need only send a query ID instead of the query itself. This saves bundle size and network bandwidth, and can prevent attackers from writing malicious queries since only those your app was built with need be available.

So when you have a GraphQL tagged string literal in your program...

```rescript
module MyQuery = %relay(`
  query MyQuery {
    viewer {
      name
    }
  }
`)
```

... what Relay ends up using at runtime looks something like this:

```
{
  kind: "query",
  selections: [
    {
      name: "viewer",
      kind: "LinkedField",
      selections: [
        name: "name",
        kind: "ScalarField",
      ],
    }
  ]
}
```

along with various other properties and information. These data structures are carefully designed to allow the JIT to run Relay’s payload processing code very quickly. If you’re curious, you can use the [Relay Compiler Explorer](/compiler-explorer) to play with it.

</details>

---

## Relay and the Type System

The Relay compiler generates ReScript types corresponding to every piece of GraphQL that you have in your app within a <code>%relay(``)</code> literal. As long as <code>yarn dev</code> is running, the Relay compiler will automatically regenerate these files whenever you save one of your ReScript source files, so you don’t need to refresh anything to keep them up to date.

We’ll revisit types throughout this tutorial. But next, we'll look at an even more important way that Relay helps us with maintainability.

---

## Summary

Queries are the foundation of fetching GraphQL data. We’ve seen:

- How to define a GraphQL query within our app using the <code>%relay(``)</code> tagged literal
- How to use the `use` hook to fetch the results of a query when a component renders.

In the next section, we’ll look at Fragments, one of the most core and distinctive aspects of Relay. Fragments let each individual component define its own data requirements, while retaining the performance advantages of issuing a single query to the server.
