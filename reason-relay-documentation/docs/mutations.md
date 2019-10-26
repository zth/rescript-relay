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
// SingleTodo.re
module UpdateMutation = [%relay.mutation {|
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
let make = (...) => {
  ...
  <button
    onClick={_ =>
        UpdateMutation.commitMutation(
            ~environment=RelayEnv.environment,
            ~variables={
                "input": {
                    "clientMutationId": None,
                    "id": todoItem##id,
                    "text": todoItem##text,
                },
            },
            (),
        )
        |> Js.Promise.then_(res => {
                Js.log(res);
                Js.Promise.resolve();
            })
        |> Js.Promise.catch(err => {
                Js.log(err);
                Js.Promise.resolve();
            })
        |> ignore
    }>
    {React.string("Update")}
    </button>
};

```

There's lots of code stripped in this example, but hopefully you get the gist of it. Let's break it down:

1. `[%relay.mutation]` autogenerates a `commitMutation` function that takes your `environment` and `variables` as required arguments. It has a bunch of other options as well that are covered in the [API reference](#api-reference).
2. We call `commitMutation` and give it our `environment` and the input for the mutation through `variables`.
3. We get back a `Js.Promise.t(response)` - a promise carrying the mutation result.
4. We end with an `ignore`, because we don't care about the return value right now, and `onClick` expects `unit` to be returned.

So, that's a very basic mutation. And, since we ask for the updated todo item's `text` in the mutation result, Relay will automatically update any component that uses that particular todo item's `text`.
Neat!

But, there's plenty more to mutations than this. Let's move along and look at some more advanced uses of mutations.

## Updating the store after a mutation

When you do a simple update of a field on an object, Relay will automatically sync your UI and update all places where that field on that object is used, as long as you ask for the updated field in your mutation response. However, there are lots of cases where you'll want to do more intricate updates of the Relay store after a mutation, like when deleting an item from a list, adding an item to a list, and so on.

`commitMutation` takes an optional prop called `updater`. `updater` is a function that receives the Relay store (`RecordSourceSelectorProxy.t`) and lets you apply any updates to the store in response to a mutation.

_This section is a work in progress_.

## Optimistic updates

Optimistically updating your UI can do wonders for UX, and Relay provides all the primitives you need to do both simple and more advanced optimistic updates. Let's add a simple optimistic update to this mutation by giving Relay the response that we expect the server to return right away:

```reason
UpdateMutation.commitMutation(
    ~environment=RelayEnv.environment,
    ~variables={
        "input": {
            "clientMutationId": None,
            "id": todoItem##id,
            "text": todoItem##text,
        },
    },
    ~optimisticResponse={
        "updateTodoItem":
            Some({
            "updatedTodoItem":
                Some({
                "id": todoItem##id,
                "text": todoItem##text,
                })
                |> Js.Nullable.fromOption,
            })
            |> Js.Nullable.fromOption,
        },
    (),
)
```

So, what's going on here?

1. In addition to `environment` and `variables`, we also supply `optimisticResponse` to `commitMutation`.
2. `optimisticResponse` is expected to _match the shape of the server response exactly_. That's why we for example must model all nullable items as `Some(...) |> Js.Nullable.fromOption` (interested in why things are modelled as `Js.Nullable.t` and not `option` directly? Check out [quirks of ReasonRelay](quirks-of-reason-relay)) The ReasonML compiler will guide you through providing a response of the correct shape.
3. Relay will take the `optimisticResponse` and apply it as it's sending the mutation request, which in turn will make the UI update right away. Check out the [Relay docs on optimistic updates](https://relay.dev/docs/en/mutations#optimistic-updates) for more information on optimistic updates in Relay.

There, now we have a basic optimistic update set up! Instead of waiting for the mutation to complete, Relay will update all parts of the UI using that particular todo item's `text` field right away, and it'll roll back to the old value appropriately if the mutation fails.

But we picked a pretty simple case for optimistic updates here, didn't we? Let's move on to more advanced optimistic updates.

## Advanced optimistic updates

Updating objects is simple enough in Relay - you don't really have to do anything in particular for Relay to sync your UI as long as you get back the updated fields in your response. But what about when you want to add or remove things from the store optimistically? Deleting an item, adding an item. There are multiple common cases where you'd want to do a more advanced type of optimistic update.

...WIP...

## API Reference

`[%relay.mutation]` is expanded to a module containing the following functions:

### `commitMutation`

Commits the specified mutation to Relay and returns a `Js.Promise.t('response)` where `'response` is the mutation result, derived from the GraphQL operation.

##### Parameters

_Please note that this function must be called with an ending unit `()` if not all arguments are supplied._

| Name                 | Type                                  | Optional | Notes                                                                                                                                                                                                                      |
| -------------------- | ------------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `environment`        | `Environment.t`                       | _No_     |                                                                                                                                                                                                                            |
| `variables`          | `'variables`                          | _No_     | Variables derived from the GraphQL operation                                                                                                                                                                               |
| `optimisticResponse` | `'response`                           | Yes      | The shape of the response, derived from the GraphQL operation.                                                                                                                                                             |
| `optimisticUpdater`  | `RecordSourceSelectorProxy.t => unit` | Yes      | An updater that can update the store optimistically. [Read more about optimistic updaters here in the Relay docs](https://relay.dev/docs/en/mutations#using-updater-and-optimisticupdater)                                 |
| `updater`            | `RecordSourceSelectorProxy.t => unit` | Yes      | An updater that will be applied to the store when the mutation results are merged to the store. [Read more about updaters here in the Relay docs](https://relay.dev/docs/en/mutations#using-updater-and-optimisticupdater) |

> `commitMutation` uses Relay's `commitMutation` under the hood, which you can [read more about here](https://relay.dev/docs/en/mutations#commitmutation).
