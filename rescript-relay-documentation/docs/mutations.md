---
id: mutations
title: Mutations
sidebar_label: Mutations
---

#### Recommended background reading

- [Queries and mutations in GraphQL](https://graphql.org/learn/queries/)
- [Mutations in Relay from the Relay documentation](https://relay.dev/docs/guided-tour/updating-data/graphql-mutations)

## Mutations in Relay

Fetching and displaying data is only half the fun, right? We want to change stuff as well! Making mutations in Relay is pretty straight-forward, and we'll introduce exactly how you do it in RescriptRelay here.

Mutations in RescriptRelay are defined using the `%relay()` extension node. The following example shows how to define and then run a simple mutation with RescriptRelay:

```reason
/* SingleTodo.res */
module UpdateMutation = %relay(
  `
  mutation SingleTodoUpdateMutation($input: UpdateTodoItemInput!) {
    updateTodoItem(input: $input) {
      updatedTodoItem {
        id
        text
      }
    }
  }
`
)

@react.component
let make = () => {
  let (mutate, isMutating) = UpdateMutation.use()

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
      )}>
    {React.string(isMutating ? "Updating..." : "Update")}
  </button>
}


```

> A note on naming: Due to the rules of Relay, a mutation must be named `<ModuleName><optionally_anything_here>Mutation`, where module name here means _file name_, not ReScript module name. So for a file `SingleTodo.res`, all mutations in that file must start with `SingleTodo` regardless of whether they're defined in nested modules or not. All mutation names must also end with `Mutation`.

> Using VSCode? Our [dedicated VSCode extension](vscode-extension) lets you codegen new mutations effortlessly via the command `> Add mutation`, including boilerplate for the component.

Let's break it down:

1. `%relay()` autogenerates a `use` hook that takes `variables` as required arguments. It has a bunch of other options as well that are covered in the [API reference](#api-reference). It returns a tuple with the mutation function, and a flag that indicates whether the mutation is running right now.
2. We call `mutate` with input for the mutation through `variables`. This will run the mutation, which is now indicated by the second parameter of the tuple, `isMutating`.
3. Since we ask for the updated todo item's `text` in the mutation result, Relay will automatically update any component using that.
   Neat!

But, there's plenty more to mutations than this. Let's move along and look at some more advanced uses of mutations.

## Updating the store after a mutation

When you do a simple update of a field on an object, Relay will automatically sync your UI and update all places where that field on that object is used, as long as you ask for the updated field in your mutation response. However, there are lots of cases where you'll want to do more intricate updates of the Relay store after a mutation, like when deleting an item from a list, adding an item to a list, and so on.

All mutation functions you use take an optional prop called `updater`. `updater` is a function that receives the Relay store (`RecordSourceSelectorProxy.t`) and the `'response` from the mutation. It lets you apply any updates to the store in response to a mutation.

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
    updateTodoItem: Some({
      updatedTodoItem: Some({"id": todoItem.id, "text": todoItem.text}),
    }),
  },
  (),
)

```

So, what's going on here?

1. In addition to `variables`, we also supply `optimisticResponse` to `mutate`.
2. `optimisticResponse` is expected to _match the shape of the server response exactly_. The ReScript compiler will guide you through providing a response of the correct shape.
3. Relay will take the `optimisticResponse` and apply it as it's sending the mutation request, which in turn will make the UI update right away.

There, now we have a basic optimistic update set up! Instead of waiting for the mutation to complete, Relay will update all parts of the UI using that particular todo item's `text` field right away, and it'll roll back to the old value appropriately if the mutation fails.

### `@raw_response_type` - getting exactly what Relay expects from the server

> TLDR; Annotating your query/mutation/subscription with `@raw_response_type` will tell Relay to emit types for the _full_ server response it expects back. This ensures that the `optimisticResponse` you provide is exactly what Relay expects it to be.

The Relay compiler is full of tricks. Among a ton of other things, it'll automatically import all of your fragments (and the fragments they use) and include in the final operation that's sent to the server. It'll also add a few smart refinements to your operations, in order for it to understand what type of response is coming back.

This is really cool, and means Relay doesn't need to parse or transform queries at runtime, since the compiler can do all of that at buildtime instead, and just emit optimized instructions that the runtime can use to understand what it's getting back from the server.

However, this also means that when you're doing optimistic updates, you'll need to provide the _full server response_ for things to work as you expect them to. In most cases this is simple, but once you start adding fragments to the mix, things can get hairy quickly. What'd fragment A contain again? And did that spread other fragments...?

But fear not! Relay has you covered, as usual. Imagine the following GraphQL:

```graphql
fragment Avatar_user on User {
  id
  avatarUrl
  firstName
}

fragment SomeComponent_user on User {
  id
  firstName
  lastName
  ...Avatar_user
}

fragment SomeOtherComponent_blogPost on BlogPost {
  id
  title
  author {
    id
    firstName
    ...SomeComponent_user
  }
}

mutation AddBlogPost($input: AddBlogPostInput!) {
  addBlogPost(input: $input) {
    addedBlogPost {
      id
      title
      ...SomeOtherComponent_blogPost
    }
  }
}
```

So, there's a mutation, and that mutation includes a fragment. No big deal. Except that fragment includes a fragment. That includes a fragment. Yuck.

Well, there's a solution for this. Adding `@raw_response_type` to this mutation flattens this for us! The resulting type would look something like this in pseudo-reason:

```reason
/* You can't construct records like this, but hey, who cares in docs */
type rawResponse = {
  addedBlogPost: option({
    id: string,
    title: string,
    author: {
      id: string,
      firstName: string,
      lastName: string
    }
  })
}
```

Look at that. All fragments are flattened and included in the type. This type corresponds to _exactly_ what Relay expects the server to return, which makes your optimistic update work just as you want it to!

#### `RescriptRelay.generateUniqueClientID` for `id` fields in optimistic updates

Now, the type for the optimistic response above contains a bunch of `id` fields. `id`'s you naturally don't have yet since they'll be created on the server. Relay ships with a function just for this - `generateUniqueClientID`.

You use it like this:

```reason
~optimisticResponse={
  addedBlogPost: Some({
    id: RescriptRelay.(generateUniqueClientID->dataIdToString),
    ...
  })
}
```

This will generate a local, unique id. As soon as the actual server update comes back, the optimistic response will be rolled back, and this `id` will be replaced with the actual one from the server. Nice!

## More information

There's plenty of more advanced things you can do with optimistic updates in Relay. We won't be covering them in detail here, but you're encouraged to read [the Relay documentation on optimistic updates here](https://relay.dev/docs/en/mutations#optimistic-updates), and then check out [interacting with the store in RescriptRelay](interacting-with-the-store).

## The next step

Now would be a good time to have a look at how to [refetch and load more data](refetching-and-loading-more-data).

## API Reference

`%relay()` is expanded to a module containing the following functions:

### `use`

A React hook for running and keeping track of the mutation. Returns a tuple of `(mutationFn, bool)`, where `mutationFn` is a function you run to apply the mutation, and the second `bool` parameter indicates whether the mutation is currently in flight or not.

##### Parameters

_Please note that this function must be called with an ending unit `()` if not all arguments are supplied._

| Name                 | Type                                               | Required | Notes                                                                                                                                                                                                                                    |
| -------------------- | -------------------------------------------------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `variables`          | `'variables`                                       | _Yes_    | Variables derived from the GraphQL operation                                                                                                                                                                                             |
| `optimisticResponse` | `'response`                                        | No       | The shape of the response, derived from the GraphQL operation.                                                                                                                                                                           |
| `optimisticUpdater`  | `RecordSourceSelectorProxy.t => unit`              | No       | An updater that can update the store optimistically. [Read more about optimistic updaters here in the Relay docs](https://relay.dev/docs/en/mutations#using-updater-and-optimisticupdater)                                               |
| `updater`            | `(RecordSourceSelectorProxy.t, 'response) => unit` | No       | An updater that will be applied to the store when the mutation results are merged to the store. [Read more about updaters here in the Relay docs](https://relay.dev/docs/guided-tour/updating-data/graphql-mutations/#updater-functions) |

> `use` uses Relay's `useMutation` under the hood, which is currently not documented in the official Relay docs.

### `commitMutation`

Commits the specified mutation to Relay and returns a `Disposable.t` that allow you to cancel listening for the mutation result if needed.

##### Parameters

_Please note that this function must be called with an ending unit `()` if not all arguments are supplied._

| Name                 | Type                                                       | Required | Notes                                                                                                                                                                                                                                                                                                                                                                                        |
| -------------------- | ---------------------------------------------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `environment`        | `Environment.t`                                            | _Yes_    |                                                                                                                                                                                                                                                                                                                                                                                              |
| `variables`          | `'variables`                                               | _Yes_    | Variables derived from the GraphQL operation                                                                                                                                                                                                                                                                                                                                                 |
| `optimisticResponse` | `'response`                                                | No       | The shape of the response, derived from the GraphQL operation.                                                                                                                                                                                                                                                                                                                               |
| `optimisticUpdater`  | `RecordSourceSelectorProxy.t => unit`                      | No       | An updater that can update the store optimistically. [Read more about optimistic updaters here in the Relay docs](https://relay.dev/docs/guided-tour/updating-data/graphql-mutations/#optimistic-updater)                                                                                                                                                                                    |
| `updater`            | `(RecordSourceSelectorProxy.t, 'response) => unit`         | No       | An updater that will be applied to the store when the mutation results are merged to the store. [Read more about updaters here in the Relay docs](https://relay.dev/docs/guided-tour/updating-data/graphql-mutations/#updater-functions)                                                                                                                                                     |
| `onCompleted`        | `(option(Js.Json.t), option(array(mutationError)) => unit` | No       | Called when the mutation is done and applied in the store. The first parameter is the mutation response _after it has potentially been modified by updaters_. This is why it's typed as `Js.Json.t` - there's simply no way to type it properly as it's dynamic. The second parameter is an `array` of `mutationError` (`{ message: string }`), which contains the errors if there were any. |
| `onError`            | `option(mutationError) => unit`                            | No       | A callback called if the entire mutation fails.                                                                                                                                                                                                                                                                                                                                              |

> `commitMutation` uses Relay's `commitMutation` under the hood, which you can [read more about here](https://relay.dev/docs/api-reference/commit-mutation).
