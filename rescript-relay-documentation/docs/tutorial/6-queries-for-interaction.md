---
id: tutorial-queries-2
title: Queries for Interactions
sidebar_label: Queries for Interactions
---

# Queries for Interactions

We’ve seen how fragments let us specify data requirements in each component, yet at runtime perform only a single query for an entire screen. Here we’ll look at a situation where we _want_ a second query on the same screen. This will also let us explore some more features of GraphQL queries.

- We’ll build a **hovercard** that shows more details about the poster of a story when you hover over their name.
- The hovercard will use a second query to fetch **additional information** that’s only needed if the user hovers.
- We’ll use **query variables** to tell the server which person we’d like more details about.
- We’ll see how to improve performance with **preloaded queries**.

After covering these topics, we’ll return to look at some more advanced features of Fragments.

---

In this section we’ll add a hovercard to `PosterByline` so that you can see more details about the poster of a story by hovering over their name.

<details>
<summary>Deep dive: When to use a secondary query</summary>

Relay is designed to help you fetch all of your data requirements for an entire screen up-front. But we can generalize this and say that a _user interaction_ should have at most one query. Navigating to another screen is just one (very) common type of user interaction.

Within a screen, some interactions may disclose more data than what was shown initially. If an interaction is performed relatively rarely, but needs a significant amount of additional data, it can be a good idea to fetch that additional data in a second query when the interaction happens, rather than up-front when the screen is first loaded. This makes that initial load faster and less expensive.

There are also some interactions where the amount of additional data is indefinite — e.g., a hovercard within a hovercard — and not feasible to know statically.

If data is lower-priority and should be loaded after the main data has loaded, but should pop in automatically without further user input, Relay has a feature called a _deferred fragment_ for that. We'll cover it later.
</details>

We’ve already prepared a hovercard component that you can put to use. However, it has been in a directory called `future` in order to avoid compilation errors since it uses `Image_image`. Now that we’re at this stage of the tutorial, you can move the modules in `future` into `src/components`:

```
mv future/* src/components
```

Now, if you did the exercise to make `PosterByline` use fragments, the `PosterByline` component should look something like this:

```rescript
module Fragment = %relay(`
  fragment PosterByline_actor on Actor {
    name @required(action: NONE)
    profilePicture @required(action: NONE) {
      ...Image_image @arguments(width: 60, height: 60)
    }
  }
`)

@react.component
let make = (~poster) => {
  let data = Fragment.use(poster)

  switch data {
  | None => React.null
  | Some({name, profilePicture}) =>
    <div className="byline">
      <Image image={profilePicture.fragmentRefs} width={60} height={60} className="byline__image" />
      <div className="byline__name"> {name->React.string} </div>
    </div>
  }
}
```

To use the hovercard component, you can make the following changes:

```rescript
module Fragment = %relay(`
  fragment PosterByline_actor on Actor {
    name @required(action: NONE)
    profilePicture @required(action: NONE) {
      ...Image_image @arguments(width: 60, height: 60)
    }
  }
`)

@react.component
let make = (~poster) => {
  let data = Fragment.use(poster)
  // change-line
  let hoverRef = React.useRef(Js.Nullable.null)

  switch data {
  | None => React.null
  | Some({name, profilePicture}) =>
    // change-line
    <div className="byline" ref={ReactDOM.Ref.domRef(hoverRef)}>
      <Image image={profilePicture.fragmentRefs} width={60} height={60} className="byline__image" />
      <div className="byline__name"> {name->React.string} </div>
      // change
      <Hovercard targetRef={hoverRef}>
        <PosterDetailsHovercardContents />
      </Hovercard>
      // end-change
    </div>
  }
}
```

You should now see that whenever you hover over someone’s name, you get a hovercard with more information. If you look inside `PosterDetailsHovercardContents.res`, you’ll find that it performs a query with `PosterDetailsHovercardContentsQuery.use` to fetch additional information when the component is mounted.

There’s just one problem: it always shows the same person's information, no matter which poster you hover over!

![Hovercard showing the wrong person](/img/docs/tutorial/queries-wrong-hovercard-person.png)

---

## Query Variables

We need to tell the server _which_ user we want more information about. GraphQL lets us define _query variables_ that can be passed as arguments to specific fields. These arguments are then available on the server.

In the previous section, we saw how a field can accept arguments, but the argument values were hard-coded, e.g. `url(width: 200, height: 200)`. With query variables, we can determine these values at runtime. They’re passed from the client to the server alongside the query itself. GraphQL variables always begin with a `$` dollar sign.

Take a look inside `PosterDetailsHovercardContents.res`: you should see a query like this one:

```rescript
module PosterDetailsHovercardContentsQuery = %relay(`
  query PosterDetailsHovercardContentsQuery {
    // change-line
    node(id: "1") {
      // color2
      ... on Actor {
        ...PosterDetailsHovercardContents_actor
      }
    }
  }
`)
```

<span className="color1">The <code>node</code> field</span> is a top-level field defined in our schema that lets us fetch any graph node given its unique ID. It takes the ID as an argument, which is currently hard-coded. In this exercise, we’ll be replacing this hard-coded ID with a variable supplied by our UI state.

The funny-looking `... on Actor` is a <span className="color2">_type refinement_</span>. We’ll look at these in more detail in the next section and can ignore it for now. In brief, since we could supply any ID at all to the `node` field, there’s no way to know statically what _type_ of node we’d be selecting. The type refinement specifies what type we expect, allowing us to use fields from the `Actor` type

Within that, we simply spread a fragment that contains the fields we want to show — about which more later. For now, here are the steps to take to replace this hard-coded ID with the ID of the poster we’re hovering over:

### Step 1 — Define a query variable

First we make the query accept a query variable. Here’s the change:

```rescript
module HovercardQuery = %relay(`
  query PosterDetailsHovercardContentsQuery(
    // change-line
    $posterID: ID!
  ) {
    node(id: "1") {
      ... on Actor {
        ...PosterDetailsHovercardContentsBodyFragment
      }
    }
  }
`)
```

- The variable name is `$posterID`. This is the symbol we’ll use within the GraphQL query to refer to the value passed in from the UI.
- Variables have a type — in this case `ID!`_._ The `ID` type is a synonym for `String` that is used for node IDs to help distinguish them from other strings. The `!` on `ID!` means that field is non-nullable. In GraphQL, fields are normally nullable and non-nullability is the exception.

You should be getting a compile error telling you that the variable `$posterID` is not used in the query.

### Step 2 — Pass the variable in as a field argument

Now we replace the hard-coded `"1"` with the variable:

```rescript
module HovercardQuery = %relay(`
  query PosterDetailsHovercardContentsQuery($posterID: ID!) {
    node(
      // change-line
      id: $posterID
    ) {
      ... on Actor {
        ...PosterDetailsHovercardContentsBodyFragment
      }
    }
  }
`)
```

You should now be getting a compile error for the `PosterDetailsHovercardContentsQuery.use` hook, saying that the type you're passing to `~variables` is `unit`, but `PosterDetailsHovercardContentsQuery_graphql.Types.variables` was expected.

:::note
You can use query variables not only as field arguments, but as arguments to fragments.
:::

### Step 3 — Provide the argument value to the query hook
Because you've added query variables to `PosterDetailsHovercardContentsQuery`, the variables argument to the hook cannot be empty and we need to pass in the actual value from our UI at runtime.

We’ll add a new prop to our component and pass its value in there:

```rescript
@react.component
// change-line
let make = (~posterID) => {
  // change-line
  let data = HovercardQuery.use(~variables={posterID: posterID})
  <div className="posterHovercard">
    {switch data.node {
    | None => React.null
    | Some(poster) => <PosterDetailsHovercardContentsBody poster={poster.fragmentRefs} />
    }}
  </div>
}
```
As you may have guessed, you'll now see another compiler error saying that a required field is missing and that `"If this is a component, add the missing props"`. Let's do that.

### Step 4 — Pass the ID in from the parent component

Head over to `PosterByline` and add `id` to its fragment and pass it to `PosterDetailsHovercardContents`:

```rescript
module PosterBylineFragment = %relay(`
  fragment PosterBylineFragment on Actor {
    // change-line
    id
    ...
  }
`)

@react.component
let make = (~poster) => {
  ...

  switch data {
  | None => React.null
  // change-line
  | Some({id, name, profilePicture}) =>
    <div className="byline" ref={ReactDOM.Ref.domRef(hoverRef)}>
      ...
      <Hovercard targetRef={hoverRef}>
        // change-line
        <PosterDetailsHovercardContents posterID={id} />
      </Hovercard>
    </div>
}
```

At this point, the hovercard should show the appropriate information for each poster that we hover over.

![Hovercard showing the correct person](/img/docs/tutorial/query-variables-hovercard-correct.png)

If you use the Network inspector in your browser, you should be able to find that the variable value is being passed alongside the query:

![Network request inspector showing variable being set to the server](/img/docs/tutorial/network-request-with-variables.png)

You may also notice that this request is made only the first time you hover over a particular poster. Relay caches the results of the query and re-uses them after that, until eventually removing the cached data if it hasn’t been used recently.

<details>
<summary>Deep dive: Caching and the Relay Store</summary>

In contrast to most other systems, Relay’s caching is not based on queries, but on graph nodes. Relay maintains a local cache of all the nodes it has fetched called the Relay Store. Each node in the Store is identified and retrieved by its ID. If two queries ask for the same information, as identified by node IDs, then the second query will be fulfilled using the cached information retrieved for the first query, and not be fetched.

Relay will garbage-collect nodes from the Store if they aren’t “reachable” from any queries that are used, or have been recently used, by any mounted components.

</details>

<details>
<summary>Deep dive: Why GraphQL Needs a Syntax for Variables</summary>

You might be wondering why GraphQL even has the concept of variables, instead of just interpolating the value of the variables into the query string. Well, [as mentioned before](3-query-basics.md), the text of the GraphQL query string isn’t available at runtime, because Relay replaces it with a data structure that is more efficient. You can also configure Relay to use _prepared queries_, where the compiler uploads each query to the server at build time and assigns it an ID — in that case, at runtime, Relay is just telling the server “Give me query #1337”, so string interpolation isn't possible and therefore the variables have to come out of band. Even when the query string is available, passing variable values separately eliminates any issues with serializing arbitrary values and escaping strings, above what is required with any HTTP request.

</details>

---

## Preloaded Queries

This example app is very simple, so performance isn't an issue. (In fact, the server is artificially slowed down in order to make loading states perceptible.) However, one of Relay's main concerns is to make performance as fast as possible in real apps.

Right now, the hovercard uses the query hook, which fetches the query when the component is rendered. That means the timeline looks something like this:

![Network doesn't start until render](/img/docs/tutorial/preloaded-basic.png)

Ideally, we should start the network fetch as early as possible, but here we don't start it until React is finished rendering. This timeline could look even worse if we used `React.lazy` to load the code for the hovercard component itself when the interaction happened. In that case, it would look like this:

![Network doesn't start until component is fetched and then rendered](/img/docs/tutorial/preloaded-lazy.png)

Notice how we’re waiting around before we even start fetching the GraphQL query. It would be better if the query fetch began before the React component even rendered, right at the beginning in the mouse event handler itself. Then the timeline would look like this:

![Network and component fetch happen concurrently](/img/docs/tutorial/preloaded-ideal.png)

When the user interacts, we should immediately start fetching the query we need, while also beginning to render the component (fetching its code first if needed). Once both of these async processes are complete, we can render the component with the data available and show it to the user.

Relay provides a feature called _preloaded queries_ that let us do this.

Let’s modify the hovercard to use preloaded queries.

### Step 1 — Change use to usePreloaded

As a reminder, this is the `PosterDetailsHovercardContents` component that currently fetches the data lazily:

```rescript
@react.component
let make = (~posterID) => {
  let data = HovercardQuery.use(~variables={posterID: posterID})
  <div className="posterHovercard">
    {switch data.node {
    | None => React.null
    | Some(poster) => <PosterDetailsHovercardContentsBody poster={poster.fragmentRefs} />
    }}
  </div>
}
```

It calls `PosterDetailsHovercardContentsQuery.use` which accepts _variables_ as its second argument. We want to change this to `PosterDetailsHovercardContentsQuery.usePreloaded`. However, with preloaded queries, the variables are actually determined when the query is fetched, which will be before this component is even rendered. So instead of variables, this hook takes a _query reference_ that contains the information it needs to retrieve the results of the query. The query reference will be created when we fetch the query in Step 2.

Change the component as follows:

```rescript
@react.component
// change-line
let make = (~queryRef) => {
  // change-line
  let data = HovercardQuery.usePreloaded(~queryRef)
  <div className="posterHovercard">
    {switch data.node {
    | None => React.null
    | Some(poster) => <PosterDetailsHovercardContentsBody poster={poster.fragmentRefs} />
    }}
  </div>
}
```

### Step 2 — Call useLoader in the parent component

Now that `PosterDetailsHovercardContents` expects a query ref, we need to create that query ref and pass it down from the parent component, which is `PosterByline`. We create the query ref using a hook called `useLoader`. This hook returns the query ref and a function that we call in our event handler to trigger the query fetch.

```rescript
@react.component
let make = (~poster) => {
  let data = Fragment.use(poster)
  let hoverRef = React.useRef(Js.Nullable.null)

  // change
  let (
    hovercardQueryRef,
    loadHoverCardQuery,
    _,
  ) = PosterDetailsHovercardContents.HovercardQuery.useLoader()
  // end-change

  switch data {
  | None => React.null
  | Some({id, name, profilePicture}) =>
    <div className="byline" ref={ReactDOM.Ref.domRef(hoverRef)}>
      <Image image={profilePicture.fragmentRefs} width={60} height={60} className="byline__image" />
      <div className="byline__name"> {name->React.string} </div>
      <Hovercard targetRef={hoverRef}>
        <PosterDetailsHovercardContents posterID={id} />
      </Hovercard>
    </div>
  }
}
```

The `useLoader` hook returns a triple of which we need the first two elements. The triple consists of (with the names we have chosen):

- `hovercardQueryRef` is an opaque piece of information that `usePreloaded` will use to retrieve the result of the query.
- `loadHovercardQuery` is a function that will initiate the request.
- `_` (we use the underscore to tell the compiler that we are deliberately ignoring the value), is a dispose function that you can call to cancel the request.

### Step 3 — Initiate the query in the event handler

Finally, we want to call `loadHovercardQuery` on hover, so the query is fetched. The `Hovercard` component has an `onBeginHover` handler that we can use:

```rescript
@react.component
let make = (~poster) => {
  ...

  let (
    hovercardQueryRef,
    loadHoverCardQuery,
    _,
  ) = PosterDetailsHovercardContents.PosterDetailsHovercardContentsQuery.useLoader()

  switch data {
  | None => React.null
  | Some({id, name, profilePicture}) =>
    <div className="byline" ref={ReactDOM.Ref.domRef(hoverRef)}>
      <Image image={profilePicture.fragmentRefs} width={60} height={60} className="byline__image" />
      <div className="byline__name"> {name->React.string} </div>
      <Hovercard
        // change-line
        targetRef={hoverRef} onBeginHover={_ => loadHoverCardQuery(~variables={posterID: id})}>
        {switch hovercardQueryRef {
        | None => React.null
        | Some(queryRef) => <PosterDetailsHovercardContents queryRef />
        }}
      </Hovercard>
    </div>
  }
}
```

Note that the query variables are now passed to the function that initiates the query.

At this point, you should see the same behavior as before, but now it will be a little bit faster since Relay can get the query started earlier.

:::tip
Although we introduced queries using `use` for simplicity, preloaded queries are always the preferred way to use queries in Relay because they can significantly improve performance in the real world. With the appropriate [integrations with your server and router system](https://github.com/relayjs/relay-examples/tree/main/issue-tracker-next-v13), you can preload the main query for a webpage on server side even before downloadeding or runing any client code.
:::

---

## Summary

- Although all of the data initially shown on a screen should be combined into one query, user interactions needing further information can be handled with secondary queries.
- Query variables let you pass information to the server along with your query.
- Query variables are used by passing them into field arguments.
- Preloaded queries are always the best way to go. For user interaction queries, initiate the fetch in the event handler. For the initial query for your screen, initiate the fetch as early as possible in your specific routing system. Use lazy-loaded queries only for quick prototyping, or not at all.

Next we'll briefly look at a way to enhance the hovercard by handling different types of posters. After that, we'll see how to handle situations where information that's part of the initial query also needs to be updated and refetched with different variables.
