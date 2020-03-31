---
id: mutations
title: Mutations
sidebar_label: Mutations
---

#### Recommended background reading

- [Queries and mutations in GraphQL](https://graphql.org/learn/queries/)
- [Mutations in Relay from the Relay documentation](https://relay.dev/docs/en/mutations)

## Mutations in Relay

Fetching and displaying data is only half the fun, right? We want to change stuff as well! Making mutations in Relay is pretty straight-forward, and we'll introduce exactly how you do it in ReasonRelay here.

Mutations in ReasonRelay are defined using the `[%relay.mutation]` extension node. The following example shows how to define and then run a simple mutation with ReasonRelay:

```reason
/* SingleTodo.re */
module UpdateMutation = [%relay.mutation
  {|
  mutation SingleTodoUpdateMutation($input: UpdateTodoItemInput!) {
    updateTodoItem(input: $input) {
      updatedTodoItem {
        id
        text
      }
    }
  }
|}
];

[@react.component]
let make = () => {
  let (mutate, isMutating) = UpdateMutation.use();

  <button
    onClick={_ =>
      mutate(
        ~variables={
          input: {
            clientMutationId: None,
            id: todoItem.id,
            text: newText,
          },
        },
        (),
      )
    }>
    {React.string(isMutating ? "Updating..." : "Update")}
  </button>;
};

```

Let's break it down:

1. `[%relay.mutation]` autogenerates a `use` hook that takes `variables` as required arguments. It has a bunch of other options as well that are covered in the [API reference](#api-reference). It returns a tuple with the mutation function, and a flag that indicates whether the mutation is running right now.
2. We call `mutate` with input for the mutation through `variables`. This will run the mutation, which is now indicated by the second parameter of the tuple, `isMutating`.
3. Since we ask for the updated todo item's `text` in the mutation result, Relay will automatically update any component using that.
   Neat!

But, there's plenty more to mutations than this. Let's move along and look at some more advanced uses of mutations.

## Updating the store after a mutation

When you do a simple update of a field on an object, Relay will automatically sync your UI and update all places where that field on that object is used, as long as you ask for the updated field in your mutation response. However, there are lots of cases where you'll want to do more intricate updates of the Relay store after a mutation, like when deleting an item from a list, adding an item to a list, and so on.

`commitMutation` takes an optional prop called `updater`. `updater` is a function that receives the Relay store (`RecordSourceSelectorProxy.t`) and the `'response` from the mutation. It lets you apply any updates to the store in response to a mutation.

_This section is a work in progress_.

## Optimistic updates

Optimistically updating your UI can do wonders for UX, and Relay provides all the primitives you need to do both simple and more advanced optimistic updates. Let's add a simple optimistic update to this mutation by giving Relay the response that we expect the server to return right away:

```reason
mutate(
    ~variables={
        input: {
            clientMutationId: None,
            id: todoItem.id,
            text: newText,
        },
    },
    ~optimisticResponse={
        updateTodoItem:
        Some({
            updatedTodoItem:
            Some({"id": todoItem.id, "text": todoItem.text}),
        }),
    },
    (),
)
```

So, what's going on here?

1. In addition to `variables`, we also supply `optimisticResponse` to `mutate`.
2. `optimisticResponse` is expected to _match the shape of the server response exactly_. The ReasonML compiler will guide you through providing a response of the correct shape.
3. Relay will take the `optimisticResponse` and apply it as it's sending the mutation request, which in turn will make the UI update right away.

There, now we have a basic optimistic update set up! Instead of waiting for the mutation to complete, Relay will update all parts of the UI using that particular todo item's `text` field right away, and it'll roll back to the old value appropriately if the mutation fails.

## More information

There's plenty of more advanced things you can do with optimistic updates in Relay. We won't be covering them in detail here, but you're encouraged to read [the Relay documentation on optimistic updates here](https://relay.dev/docs/en/mutations#optimistic-updates), and then check out [interacting with the store in ReasonRelay](interacting-with-the-store).

## The next step

Now would be a good time to have a look at how to [refetch and load more data](refetching-and-loading-more-data).

## API Reference

`[%relay.mutation]` is expanded to a module containing the following functions:

### `use`

A React hook for running and keeping track of the mutation. Returns a tuple of `(mutationFn, bool)`, where `mutationFn` is a function you run to apply the mutation, and the second `bool` parameter indicates whether the mutation is currently in flight or not.

##### Parameters

_Please note that this function must be called with an ending unit `()` if not all arguments are supplied._

| Name                 | Type                                               | Required | Notes                                                                                                                                                                                                                      |
| -------------------- | -------------------------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `variables`          | `'variables`                                       | _Yes_    | Variables derived from the GraphQL operation                                                                                                                                                                               |
| `optimisticResponse` | `'response`                                        | No       | The shape of the response, derived from the GraphQL operation.                                                                                                                                                             |
| `optimisticUpdater`  | `RecordSourceSelectorProxy.t => unit`              | No       | An updater that can update the store optimistically. [Read more about optimistic updaters here in the Relay docs](https://relay.dev/docs/en/mutations#using-updater-and-optimisticupdater)                                 |
| `updater`            | `(RecordSourceSelectorProxy.t, 'response) => unit` | No       | An updater that will be applied to the store when the mutation results are merged to the store. [Read more about updaters here in the Relay docs](https://relay.dev/docs/en/mutations#using-updater-and-optimisticupdater) |

> `use` uses Relay's `useMutation` under the hood, which is currently not documented in the official Relay docs.

### `commitMutation`

Commits the specified mutation to Relay and returns a `Js.Promise.t('response)` where `'response` is the mutation result, derived from the GraphQL operation.

##### Parameters

_Please note that this function must be called with an ending unit `()` if not all arguments are supplied._

| Name                 | Type                                               | Required | Notes                                                                                                                                                                                                                      |
| -------------------- | -------------------------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `environment`        | `Environment.t`                                    | _Yes_    |                                                                                                                                                                                                                            |
| `variables`          | `'variables`                                       | _Yes_    | Variables derived from the GraphQL operation                                                                                                                                                                               |
| `optimisticResponse` | `'response`                                        | No       | The shape of the response, derived from the GraphQL operation.                                                                                                                                                             |
| `optimisticUpdater`  | `RecordSourceSelectorProxy.t => unit`              | No       | An updater that can update the store optimistically. [Read more about optimistic updaters here in the Relay docs](https://relay.dev/docs/en/mutations#using-updater-and-optimisticupdater)                                 |
| `updater`            | `(RecordSourceSelectorProxy.t, 'response) => unit` | No       | An updater that will be applied to the store when the mutation results are merged to the store. [Read more about updaters here in the Relay docs](https://relay.dev/docs/en/mutations#using-updater-and-optimisticupdater) |

> `commitMutation` uses Relay's `commitMutation` under the hood, which you can [read more about here](https://relay.dev/docs/en/mutations#commitmutation).
