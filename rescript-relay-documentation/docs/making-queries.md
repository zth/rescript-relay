---
id: making-queries
title: Making Queries
sidebar_label: Making Queries
---

#### Recommended background reading

- [Queries and mutations in GraphQL](https://graphql.org/learn/queries/)
- [A Guided Tour of Relay: Queries](https://relay.dev/docs/guided-tour/rendering/queries)
- [React documentation: Suspense for Data Fetching](https://reactjs.org/docs/concurrent-mode-suspense.html)

## Making Queries

Let's make our first query!

Queries in RescriptRelay are defined using the `%relay()` extension node. Let's set up our first query and a component to display the data:

```rescript
/* UserProfile.res */
module Query = %relay(`
  query UserProfileQuery($userId: ID!) {
    userById(id: $userId) {
      firstName
      lastName
    }
  }
`)

```

> A note on naming: Due to the rules of Relay, a query must be named `<ModuleName><optionally_anything_here>Query`, where module name here means _file name_, not ReScript module name. So for a file `UserProfile.res`, all queries in that file must start with `UserProfile` regardless of whether they're defined in nested modules or not. All query names must also end with `Query`.

> Using VSCode? Our [dedicated VSCode extension](vscode-extension) lets you codegen a new query (and optionally a component) via the command `> Add query`.

This is what a query definition looks like in RescriptRelay. This will be transformed into a module that exposes a number of hooks and functions to use your query in various ways (you can [read more about exactly what's exposed here](#api-reference)). Let's look at how a component that uses that query could look:

```rescript
@react.component
let make = (~userId) => {
  let queryData = Query.use(
    ~variables={
      userId: userId,
    },
    (),
  )

  switch queryData.userById {
  | Some(user) => <div> {React.string(user.firstName ++ (" " ++ user.lastName))} </div>
  | None => React.null
  }
}

```

Nothing that fancy here. We call `Query.use` to with a variable `userId`, just as defined in our GraphQL query. `use` is a React hook that will _dispatch the query to the server and then deliver the data to the component_. It's integrated with [suspense](https://reactjs.org/docs/concurrent-mode-suspense.html), which means that it'll suspend your component if the data's not already there. The query will be re-issued if you change your variables, and there's a bunch of things you can configure for your query. Check out the full reference of what can be passed to `Query.use` [here](#use).

Interacting with your query is fully type-safe, which means that `variables` and the type of `queryData` will match what you define in your GraphQL operation. This also means that the ReScript compiler will guide you through what to pass to which function, and how to use the data you get back.

There, that's all it takes to do your first query! Continue reading on this page for more information about querying (including a full [API reference](#api-reference)), or continue to the next part on [using fragments](using-fragments).

## Preloaded queries

Using the `Query.use()` hook is _lazy_, meaning Relay won't start fetching your data until that component actually renders. There's a concept in Relay called _preloaded queries_, which means that you start _preloading your query_ as soon as you can, rather than waiting for UI to render just to trigger a query.

> Please read [this section of the Relay docs](https://relay.dev/docs/api-reference/use-preloaded-query) for a more thorough overview of preloaded queries.

In RescriptRelay, every `%relay()` node containing a query automatically generates a `useLoader` hook. That hook returns a tuple of 3 things: `(option(queryRef), loadQuery, disposeQuery)`.

1. `option(queryRef)` - an option of a query reference. This query reference can be passed to `Query.usePreloaded`, like `let queryData = Query.usePreloaded(~queryRef=queryRef, ())`, to get the data for the query as soon as it's available.
2. `loadQuery` - a function that'll start loading the data for this query. You call it like `loadQuery(~variables={...}, ~fetchPolicy=?, ~networkCacheConfig=?, ())`. As soon as you've called this function, the `queryRef` (first item of the tuple) will be populated, and you can pass that `queryRef` to `usePreloaded`.
3. `disposeQuery` - a function that disposes the query reference manually. Calling this would turn `option(queryRef)` into `None`.

So, the typical way to preload a query would be like this:

```rescript
/* SomeComponent.res */
module Query = %relay(`
  query SomeComponentQuery($userId: ID!) {
    user(id: $userId) {
      ...SomeUserComponent_user
    }
  }
`)

@react.component
let make = (~queryRef) => {
  let queryData = Query.usePreloaded(~queryRef, ())

  /* Use the data for the query here */
}

/* SomeOtherComponent.res */
@react.component
let make = (~userId) => {
  let (queryRef, loadQuery, _disposeQuery) = SomeComponent.Query.useLoader()

  switch queryRef {
  | Some(queryRef) => <SomeComponent queryRef />
  | None =>
    <button onClick={_ => loadQuery(~variables={id: userId}, ())}>
      {React.string("See full user")}
    </button>
  }
}

```

Let's break down what's going on:

1. We have a component called `<SomeComponent />` that has a query. However, that component won't make that query itself. Rather, it expects whatever parent that's rendering it to have started loading that query as soon as possible, rather than waiting until the component has actually rendered.
2. `<SomeOtherComponent />` outputs a button that when pressed starts loading the query for `<SomeComponent />`. This means that query starts loading as soon as physically possible - right when the user clicks the button. No waiting for renders, state updates and what not. Data is requested as soon as possible.

A very useful pattern that's encouraged over using the lazy approach. In short, use `Query.useLoader` as much as you can where it makes sense.

## API Reference

`%relay()` is expanded to a module containing the following functions:

### `use`

As shown in the snippet above, `Query.use` is a React hook that dispatches your query + receives the data, and suspends your component if the data's not already there.

> `use` uses Relay's `useLazyLoadQuery` under the hood, which you can [read more about here](https://relay.dev/docs/api-reference/use-lazy-load-query).

##### Parameters

_Please note that this function must be called with an ending unit `()` if not all arguments are supplied._

| Name                 | Type                                         | Required | Notes                                                                                     |
| -------------------- | -------------------------------------------- | -------- | ----------------------------------------------------------------------------------------- |
| `variables`          | `'variables`                                 | _Yes_    | Variables derived from the GraphQL operation. `unit` if no variables are defined.         |
| `fetchPolicy`        | [`fetchPolicy`](api-reference#fetchpolicy)   | No       | Control how you want Relay to resolve your data.                                          |
| `fetchKey`           | `string`                                     | No       | Can be used to force a refetch, much like React's `key` can be used to force a re-render. |
| `networkCacheConfig` | [`CacheConfig.t`](api-reference#cacheconfig) | No       |                                                                                           |

### `fetch`

Sometimes you just need the query data outside of React. `fetch` lets you make the query and get the data back in a callback.

Using it looks something like this:

```rescript
Query.fetch(~environment, ~variables=(), ~onResult=res =>
  switch res {
  | Ok(res) => Js.log(res)
  | Error(_) => Js.log("Error")
  },
  ()
)

```

Please note though that `fetch` does not necessarily retain data in the Relay store, meaning it's really only suitable for data you only need once at a particular point in time. For refetching data, please check out [refetching and loading more data](refetching-and-loading-more-data).

The results are delivered through a `Belt.Result.t` in the `onResult` callback.

> `fetch` uses Relay's `fetchQuery` under the hood, which you can [read more about here](https://relay.dev/docs/api-reference/fetch-query).

##### Parameters

| Name                 | Type                                         | Required | Notes                                                                             |
| -------------------- | -------------------------------------------- | -------- | --------------------------------------------------------------------------------- |
| `environment`        | `Environment.t`                              | _Yes_    | Your Relay environment.                                                           |
| `variables`          | `'variables`                                 | _Yes_    | Variables derived from the GraphQL operation. `unit` if no variables are defined. |
| `networkCacheConfig` | `cacheConfig`                                | No       | A cache config for the network layer.                                             |
| `fetchPolicy`        | `fetchQueryFetchPolicy`                      | No       | A fetch policy to use for this particular query.                                  |
| `onResult`           | `Belt.Result.t('response, Js.Promise.error)` | _Yes_    | Callback for getting the data (or error) when it's retrieved.                     |

### `fetchPromised`

The same as `fetch`, but returns a promise instead of using a callback.

Using it looks something like this:

```rescript
Query.fetchPromised(~environment, ~variables=(), ())
  ->Js.Promise.then_(res => {
    Js.log(res)
    Js.Promise.resolve()
  }, _)

```

> `fetchPromised` uses Relay's `fetchQuery` under the hood, which you can [read more about here](https://relay.dev/docs/api-reference/fetch-query).

##### Parameters

| Name                 | Type                    | Required | Notes                                                                             |
| -------------------- | ----------------------- | -------- | --------------------------------------------------------------------------------- |
| `environment`        | `Environment.t`         | _Yes_    | Your Relay environment.                                                           |
| `variables`          | `'variables`            | _Yes_    | Variables derived from the GraphQL operation. `unit` if no variables are defined. |
| `networkCacheConfig` | `cacheConfig`           | No       | A cache config for the network layer.                                             |
| `fetchPolicy`        | `fetchQueryFetchPolicy` | No       | A fetch policy to use for this particular query.                                  |

### `useLoader`

Uses gives you a loader with which you can start loading a query without needing React to trigger the query through a render like with `Query.use`.

Returns a tuple of `(option(queryRef), loadQuery, disposeQuery)`.

##### `option(queryRef)`

Pass this `queryRef` to the `Query.usePreloaded` hook to get data for the query.

#### `loadQuery`

A function that starts loading the query, populating `queryRef`. Signature looks like this:

`let loadQuery: (~variables: queryVariables, ~fetchPolicy: fetchPolicy=?, ~networkCacheConfig: networkCacheConfig=?, ()) => unit;`

Call this as soon as possible to start your query.

#### disposeQuery

A function that manually disposes the query, turning `queryRef` into `None`. Signature:

`let disposeQuery: unit => unit;`

> `useLoader` uses Relay's `useQueryLoader` under the hood, which you can [read more about here](https://relay.dev/docs/api-reference/use-query-loader).

### `usePreloaded`

Uses a preloaded query. Pass the `queryRef` from `Query.useLoader` to this hook and `usePreloaded` will either deliver the query data if it's ready, or suspend the component until the data's there. Please read more in the section on [preloading queries](#preloaded-queries).

Returns the query's `response`.

| Name       | Type       | Required | Notes                                                                |
| ---------- | ---------- | -------- | -------------------------------------------------------------------- |
| `queryRef` | `queryRef` | _Yes_    | The query referenced returned by `loadQuery` from `Query.useLoader`. |

> `usePreloaded` uses Relay's `usePreloadedQuery` under the hood, which you can [read more about here](https://relay.dev/docs/api-reference/use-preloaded-query).

### `retain`

Calling with a set of variables will make Relay _disable garbage collection_ of this query (+ variables) until you explicitly dispose the `Disposable.t` you get back from this call.

Useful for queries and data you know you want to keep in the store regardless of what happens (like it not being used by any view and therefore potentially garbage collected).

Returns a `Disposable.t` that you can use to dispose of the query results when you don't need them anymore.

| Name          | Type            | Required | Notes                                                                             |
| ------------- | --------------- | -------- | --------------------------------------------------------------------------------- |
| `environment` | `Environment.t` | _Yes_    | Your Relay environment.                                                           |
| `variables`   | `'variables`    | _Yes_    | Variables derived from the GraphQL operation. `unit` if no variables are defined. |

> Read more [about retaining queries in Relay here](https://relay.dev/docs/guided-tour/accessing-data-without-react/retaining-queries).

### `commitLocalPayload`

> This requires your query to be annotated with [`@raw_response_type`](https://relay.dev/docs/glossary/#raw_response_type).

This commits a payload into the store _locally only_. Useful for driving client-only state via Relay for example, or priming the cache with data you don't necessarily want to hit the server for.

Returns a `Disposable.t` that you can use to dispose of the query results when you don't need them anymore.

| Name          | Type            | Required | Notes                                                                             |
| ------------- | --------------- | -------- | --------------------------------------------------------------------------------- |
| `environment` | `Environment.t` | _Yes_    | Your Relay environment.                                                           |
| `variables`   | `'variables`    | _Yes_    | Variables derived from the GraphQL operation. `unit` if no variables are defined. |
| `payload`     | `'response`     | _Yes_    | The payload to commit.                                                            |

> Read more [about commiting local payloads in Relay here](https://relay.dev/docs/guided-tour/updating-data/local-data-updates/#commitpayload).
