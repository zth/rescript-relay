---
id: tutorial-queries-1
title: Query Basics
sidebar_label: Query Basics
---

:::info
This tutorial is forked from the [official Relay tutorial](https://relay.dev/docs/tutorial/intro/), and adapted to RescriptRelay. All the credit goes to the Relay team for writing the tutorial.
:::

# Query Basics

In this section:

- We’ll take a React component that displays hard-coded placeholder data and modify it so that it fetches its data using a GraphQL query.
- We’ll learn how to use the TypeScript types that Relay generates from your GraphQL to ensure type safety.

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

- To embed GraphQL within ReScript, we put a string literal <span class="color1">marked with the <code>%relay(``)</code> tag</span>. This tag allows the Relay compiler to find and compile the GraphQL within a ReScript codebase.
- Our GraphQL string consists of a <span class="color2">query declaration</span> with the keyword `query` and then a query name.
- Inside the query declaration are _fields_, which specify what information to query for*:*
  - Some fields are _<span class="color3">scalar fields</span>_ that retrieve a string, number, or other unit of information.
  - Other fields are _<span class="color4">edges</span>_ that let us traverse from one node in the graph to another. When a field is an edge, it’s followed by another block `{ }` containing fields for the node at the other end of the edge. Here, the `poster` field is an edge that goes from a Story to a Person who posted it. Once we’ve traversed to the Person, we can include fields about the Person such as their `name`.

This illustrates the part of the graph that this query is asking for:

![Parts of the GraphQL query](/img/docs/tutorial/query-breakdown.png)

Now that we’ve defined the query, we need to modify our React component to fetch it and to use the data returned by the server.

Turn back to the `Newsfeed` component and start by deleting the placeholder data. Then replace it with this:

```rescript
@react.component
let make = () => {
  let data = NewsfeedQuery.use(~variables=(), ())

  switch data.topStory {
  | None => React.null
  | Some(topStory) =>
    <div className="newsfeed">
      <Story story={topStory} />
    </div>
  }
}

```

The `NewsfeedQuery.use` hook fetches and returns the data. It always expects <span className="color2">`variables`</span>, but since this query has no variables, we pass it unit (`()`).

The object that `NewsfeedQuery.use` returns has the same shape as the query. For instance, if printed in JSON format it might look like this:

```
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

Now go to `Story.res` and change it to this

```rescript
type story = NewsfeedQuery_graphql.Types.response_topStory

@react.component
let make = (~story: story) => {
  let summary = switch story.summary {
  | None => "Failed to load story summary"
  | Some(summary) => summary
  }

  let poster: PosterByline.poster = {
    name: switch story.poster.name {
    | None => "Failed to load poster name"
    | Some(name) => name
    },
    profilePicture: switch story.poster.profilePicture {
    | None => None
    | Some({url}) => {
        open Image
        Some({url: url})
      }
    },
  }

  let thumbnail = switch story.thumbnail {
  | None => None
  | Some({url}) => {
      open Image
      Some({url: url})
    }
  }

  <Card>
    <PosterByline poster={story.poster} />
    <Heading> {story.title->React.string} </Heading>
    {switch story.thumbnail {
    | None => React.null
    | Some(thumbnail) => <Image image={thumbnail} width={400} height={400} />
    }}
    <StorySummary summary={story.summary} />
  </Card>
}
```

The reshaping of `story` like this looks complicated, annoying, cumbersome, and boring. It is only necessary here because ReScript uses nominal types as opposed to structural types. When we get to Fragments (in the very next section), all of this ugliness will go away! Don't worry!

What you've done is replace the previous definition of `Story.story` with the type that Relay has generated for the Newsfeed query. We'll dive deeper into what this `NewsfeedQuery_graphql` type is a bit later.

<details>
<summary>Deep dive: Nominal vs Structural types</summary>

Nominal types mean, that types are only equal if they have the same name. Structural types, mean that two types are the same if they have the same structure.

ReScript has nominal types... bla bla.
</details>

:::warning
Keeping "The one final thing" for reference, but its not quite correct. Changing the type definitions would have to be done all the way down which isn't trivial. The Image component takes data from two different places in the query and without a fragment these types are not compatible.

Now, we need to do one final thing for this to compile. Go to your `Story.res` file, and change the type definition for `story` to `type story = NewsfeedQuery_graphql.Types.response_topStory`, and then remove the type definitions no longer needed in `Story.res`. We'll dive deeper into what `NewsfeedQuery_graphql` is a bit later, but for now what you need to know is that you've now replaced your own definition of `story` with one autogenerated by Relay for the `NewsfeedQuery` operation's `topStory` part.
:::

At this point, you should see a story fetched from the server:

![Screenshot](/img/docs/tutorial/queries-basic-screenshot.png)

:::note
The server's responses are artifically slowed down to make loading states perceptible, which will come in handy when we add more interactivity to the app. If you want to remove the delay, open `server/index.js` and remove the call to `sleep()`.
:::

The `NewsfeedQuery.use` hook fetches the data when the component is first rendered. Relay also has APIs for pre-fetching the data before your app has even loaded — these are covered later. In any case, Relay uses Suspense to show a loading indicator until the data is available.

This is Relay in its most basic form: fetching the results of a GraphQL query when a component is rendered. As the tutorial progresses, we’ll see how Relay’s features fit together to make your app more maintainable — starting with a look at how Relay generates ReScript types corresponding to each query.

<details>
<summary>Deep dive: Suspense for Data Loading</summary>

_Suspense_ is a new API in React that lets React wait while data is loaded before it renders components that need that data. When a component needs to load data before rendering, React shows a loading indicator. You control the loading indicator's location and style using a special component called `Suspense`.

Right now, there's a `Suspense` component inside `App.res`, which is what shows the spinner while `NewsfeedQuery.use` is loading data.

We'll look at Suspense in more detail in later sections when we add some more interactivity to the app.

</details>

<details>
<summary>Deep dive: Queries are Static</summary>

All of the GraphQL strings in a Relay app are pre-processed by the Relay compiler and removed from the resulting bundled code. This means you can’t construct GraphQL queries at runtime — they have to be static string literals so that they’re known at compile time. But it comes with major advantages.

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

The Relay compiler generates ReScript types corresponding to every piece of GraphQL that you have in your app within a <code>%relay(``)</code> literal. As long as <code>npm run dev</code> is running, the Relay compiler will automatically regenerate these files whenever you save one of your ReScript source files, so you don’t need to refresh anything to keep them up to date.

We’ll revisit types throughout this tutorial. But next, we'll look at an even more important way that Relay helps us with maintainability.

---

## Summary

Queries are the foundation of fetching GraphQL data. We’ve seen:

- How to define a GraphQL query within our app using the <code>%relay(``)</code> tagged literal
- How to use the `use` hook to fetch the results of a query when a component renders.

In the next section, we’ll look at Fragments, one of the most core and distinctive aspects of Relay. Fragments let each individual component define its own data requirements, while retaining the performance advantages of issuing a single query to the server.
