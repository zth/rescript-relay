---
id: making-queries
title: Making Queries
sidebar_label: Making Queries
---

> If you don't know Relay that well, please make sure you've read [Relay's Guided Tour documenation](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay) before continuing here. The following section will assume some familiarity with how Relay works.

Lets make our first query!

Queries in ReasonRelay are defined using the `[%relay.query]` extension node. Lets set up our first query and a component to display the data:

```reason
// UserProfile.re
module Query = [%relay.query {|
  query UserProfileQuery($userId: ID!) {
    userById(id: $userId) {
      firstName
      lastName
    }
  }
|}];

[@react.component]
let make = (~userId) => {
  let queryData = Query.use(~variables={
    "userId": userId
  }, ());

  switch(queryData##userById |> Js.Nullable.toOption) {
    | Some(user) => <div>{React.string(user##firstName ++ " " ++ user##lastName)}</div>
    | None => React.null
  };
}
```

This is what a query definition looks like in ReasonRelay. The PPX together with the compiler will then take that definition and transform that into a module that exposes a number of hooks and functions to use your query in various ways. You can [read more about exactly what's exposed here](#api-reference).

For this particular example, we're using `Query.use`, which is a React hook that will _deliver the query data to the component_. It's integrated with suspense, which means that it'll suspend your component if the data's not already there.

## Preloaded queries

Using the `Query.use()` hook is _lazy_, meaning Relay won't start fetching your data until that component actually renders. There's a concept in Relay called _preloaded queries_, which means that you start _preloading your query_ as soon as you can, rather than waiting for UI to render, just to trigger a query. The rationale is that you want to start fetching your data as soon as you possibly can, to increase the likelihood of it already being there when your UI actually renders.

> Please read [this section of the Relay docs](https://relay.dev/docs/en/experimental/api-reference#usepreloadedquery) for a more thorough overview of preloaded queries.

In ReasonRelay, every `[%relay.query]` node automatically generates a `Query.preload()` function that you can call with the same parameters as the `use` hook (plus you'll need to supply `environment` as `preload` runs outside of React's context). `preload` gives you back a token, which you can then pass to `Query.usePreloaded(tokenHere)`. This will either suspend the component (if the data's not ready) or render it right away if the data's already there.

A very useful pattern that's encouraged over using the lazy approach. In short, use `preload` as much as you can where it makes sense.

## API Reference

`[%relay.query]` is expanded to a module containing the following functions:

### `use`

As shown in the snippet above, `Query.use` is a React hook that dispatches your query + receives the data, and suspends your component if the data's not already there.

> `use` uses Relay's `useLazyLoadQuery` under the hood, which you can [read more about here](https://relay.dev/docs/en/experimental/api-reference#uselazyloadquery).

### `fetch`

Sometimes you just need the query data outside of React. `fetch` lets you make the query and get the data back in a promise.

Please note though that `fetch` does not necessarily retain data in the Relay store, meaning it's really only suitable for data you only need once at a particular point in time. For refetching data, please check out [refetching data](refetching-data).

> `fetch` uses Relay's `fetchQuery` under the hood, which you can [read more about here](https://relay.dev/docs/en/experimental/api-reference#fetchquery).

### `preload`

Starts preloading a query. Please read more in the section on [preloading queries](#preloaded-queries).

> `preload` uses Relay's `preloadQuery` under the hood, which you can [read more about here](https://relay.dev/docs/en/experimental/api-reference#preloadquery).

### `usePreloaded`

Uses a preloaded query. Pass the result of `preload` to this hook and `usePreloaded` will either deliver the query data if it's ready, or suspend the component until the data's there. Please read more in the section on [preloading queries](#preloaded-queries).

> `usePreloaded` uses Relay's `usePreloadedQuery` under the hood, which you can [read more about here](https://relay.dev/docs/en/experimental/api-reference#usepreloadedquery).
