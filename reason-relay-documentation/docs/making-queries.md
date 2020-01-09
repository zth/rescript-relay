---
id: making-queries
title: Making Queries
sidebar_label: Making Queries
---

#### Recommended background reading

- [Queries and mutations in GraphQL](https://graphql.org/learn/queries/)
- [A Guided Tour of Relay: Queries](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay#queries)
- [React documentation: Suspense for Data Fetching](https://reactjs.org/docs/concurrent-mode-suspense.html)

## Making Queries

Let's make our first query!

Queries in ReasonRelay are defined using the `[%relay.query]` extension node. Let's set up our first query and a component to display the data:

```reason
/* UserProfile.re */
module Query = [%relay.query {|
  query UserProfileQuery($userId: ID!) {
    userById(id: $userId) {
      firstName
      lastName
    }
  }
|}];
```

This is what a query definition looks like in ReasonRelay. This will be transformed into a module that exposes a number of hooks and functions to use your query in various ways (you can [read more about exactly what's exposed here](#api-reference)). Let's look at how a component that uses that query could look:

```reason
[@react.component]
let make = (~userId) => {
  let queryData = Query.use(~variables={
    userId: userId
  }, ());

  switch(queryData.userById) {
    | Some(user) => <div>{React.string(user.firstName ++ " " ++ user.lastName)}</div>
    | None => React.null
  };
};
```

Nothing that fancy here. We call `Query.use` to with a variable `userId`, just as defined in our GraphQL query. `use` is a React hook that will _dispatch the query to the server and then deliver the data to the component_. It's integrated with [suspense](https://reactjs.org/docs/concurrent-mode-suspense.html), which means that it'll suspend your component if the data's not already there. The query will be re-issued if you change your variables, and there's a bunch of things you can configure for your query. Check out the full reference of what can be passed to `Query.use` [here](#use).

Interacting with your query is fully type-safe, which means that `variables` and the type of `queryData` will match what you define in your GraphQL operation. This also means that the ReasonML compiler will guide you through what to pass to which function, and how to use the data you get back.

There, that's all it takes to do your first query! Continue reading on this page for more information about querying (including a full [API reference](#api-reference)), or continue to the next part on [using fragments](using-fragments).

## Preloaded queries

Using the `Query.use()` hook is _lazy_, meaning Relay won't start fetching your data until that component actually renders. There's a concept in Relay called _preloaded queries_, which means that you start _preloading your query_ as soon as you can, rather than waiting for UI to render just to trigger a query.

> Please read [this section of the Relay docs](https://relay.dev/docs/en/experimental/api-reference#usepreloadedquery) for a more thorough overview of preloaded queries.

In ReasonRelay, every `[%relay.query]` node automatically generates a `preload` function that you can call with the same parameters as the `use` hook (plus passing your `environment`, as `preload` runs outside of React's context). `preload` gives you back a reference, which you can then pass to `Query.usePreloaded(reference)`. This will either suspend the component (if the data's not ready) or render it right away if the data's already there.

A very useful pattern that's encouraged over using the lazy approach. In short, use `preload` as much as you can where it makes sense.

## API Reference

`[%relay.query]` is expanded to a module containing the following functions:

### `use`

As shown in the snippet above, `Query.use` is a React hook that dispatches your query + receives the data, and suspends your component if the data's not already there.

> `use` uses Relay's `useLazyLoadQuery` under the hood, which you can [read more about here](https://relay.dev/docs/en/experimental/api-reference#uselazyloadquery).

##### Parameters

_Please note that this function must be called with an ending unit `()` if not all arguments are supplied._

| Name                 | Type                                         | Required | Notes                                                                                     |
| -------------------- | -------------------------------------------- | -------- | ----------------------------------------------------------------------------------------- |
| `variables`          | `'variables`                                 | _Yes_    | Variables derived from the GraphQL operation. `unit` if no variables are defined.         |
| `fetchPolicy`        | [`fetchPolicy`](api-reference#fetchpolicy)   | No       | Control how you want Relay to resolve your data.                                          |
| `fetchKey`           | `string`                                     | No       | Can be used to force a refetch, much like React's `key` can be used to force a re-render. |
| `networkCacheConfig` | [`CacheConfig.t`](api-reference#cacheconfig) | No       |                                                                                           |

### `fetch`

Sometimes you just need the query data outside of React. `fetch` lets you make the query and get the data back in a promise.

Please note though that `fetch` does not necessarily retain data in the Relay store, meaning it's really only suitable for data you only need once at a particular point in time. For refetching data, please check out [refetching and loading more data](refetching-and-loading-more-data).

Returns `Js.Promise.t(response)`.

> `fetch` uses Relay's `fetchQuery` under the hood, which you can [read more about here](https://relay.dev/docs/en/experimental/api-reference#fetchquery).

##### Parameters

| Name          | Type            | Required | Notes                                                                             |
| ------------- | --------------- | -------- | --------------------------------------------------------------------------------- |
| `environment` | `Environment.t` | _Yes_    | Your Relay environment.                                                           |
| `variables`   | `'variables`    | _Yes_    | Variables derived from the GraphQL operation. `unit` if no variables are defined. |

### `preload`

Starts preloading a query. Please read more in the section on [preloading queries](#preloaded-queries).

Returns `preloadToken`, which is what you need to pass to that same query's [`usePreloaded`](#usepreloaded) in order to get your data.

> `preload` uses Relay's `preloadQuery` under the hood, which you can [read more about here](https://relay.dev/docs/en/experimental/api-reference#preloadquery).

##### Parameters

`preload` takes the same parameters as [`use`](#use), but also needs you to pass it your `environment` (`Environment.t`).

### `usePreloaded`

Uses a preloaded query. Pass the result of `preload` to this hook and `usePreloaded` will either deliver the query data if it's ready, or suspend the component until the data's there. Please read more in the section on [preloading queries](#preloaded-queries).

Returns the query's `response`.

> `usePreloaded` uses Relay's `usePreloadedQuery` under the hood, which you can [read more about here](https://relay.dev/docs/en/experimental/api-reference#usepreloadedquery).
