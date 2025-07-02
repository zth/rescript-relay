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

```rescript
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
        }
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

In general, RescriptRelay works the same way as regular Relay does. But there are some parts where RescriptRelay does a little bit of more work for you than what regular Relay does.

### Updating connections

RescriptRelay has access to all of the tools that regular Relay has for updating connections. However, there's a few additional quality of life helpers in RescriptRelay that we'll talk about below. But first, please read the [Relay docs on updating connections (`@connection`)](https://relay.dev/docs/guided-tour/list-data/updating-connections/). That's going to give you a good foundation for the rest of this section.

#### Type safe connection ID generation: `makeConnectionId`

ID:s for connections are used for a number of things, including [with the declarative directives](https://relay.dev/docs/guided-tour/list-data/updating-connections/#using-declarative-directives) that updates the cache after mutations.

The safest and easiest way to obtain an ID of a connection is to select `__id` on the connection field itself. However, there are plenty of situations where this isn't enough. The connection and mutation can be in different, fairly inaccessible places in the React tree, making passing the `__id` to the mutation hard. Or you might need to insert the same node to multiple configuations of the same connection, which makes `__id` insufficient since it only covers the current configuration.

RescriptRelay is designed to make your life a bit easier in these situations. Every fragment with a `@connection` will have a `makeConnectionId` function generated. This function will help you make ID:s for that connection with various argument configurations, _fully type safe_. It's fully mirrors the `@connection` and relevant parts of `@argumentDefinitions`, down to even supporting default values. Consider the following example:

```rescript
/* UserFriendsList.res */
module Fragment = %relay(`
  fragment UserFriendsList_user on User
    @argumentDefinitions(
      onlineStatuses: { type: "[OnlineStatus!]", defaultValue: [Idle] }
      count: { type: "Int", defaultValue: 2 }
      cursor: { type: "String", defaultValue: "" }
      minimumCommonFriends: { type: "Int!" }
    ) {
    __id
    friendsConnection(
      statuses: $onlineStatuses
      first: $count
      after: $cursor
      minimumCommonFriends: $minimumCommonFriends
    ) @connection(key: "UserFriendsList_user_friendsConnection") {
      edges {
        node {
          id
          ...UserFriendsListSingleUser_user
        }
      }
    }
  }
`)

@react.component
let make = (~user) => {
  let user = Fragment.use(user)

  // This creates an id for the connection above with `minimumCommonFriends` as 10, and `onlineStatuses` at its default value (which is `[Idle]`).
  // Notice that we use `__id` from the user - that's because `makeConnectionId` needs to know the _owner_ for the connection you're looking for. It doesn't need the field of the connection, just the owner itself.
  let connectionId =
    user.__id->UserFriendsList_user_graphql.makeConnectionId(~minimumCommonFriends=10)

  // This creates an id with both `minimumCommonFriends` and `onlineStatuses` having explicit values.
  let connectionId2 =
    user.__id->UserFriendsList_user_graphql.makeConnectionId(
      ~minimumCommonFriends=10,
      ~onlineStatuses=[#Online, #Idle]
    )

  // We can then use these connection ID:s to either pass into the `connections: [ID!]!` argument of the declarative updater directives, or we can use them to imperatively pull out a connection from the store like this:
  let environment = RescriptRelay.useEnvironmentFromContext()

  RescriptRelay.commitLocalUpdate(~environment, ~updater=store => {
    let connectionRecord =
      store->RecordSourceSelectorProxy.get(~dataId=connectionId)
  })

  React.null
}
```

Let's highlight a few things here:

- We select `__id` from `User` and pipe that as the first parameter into `makeConnectionId`. That's because `makeConnectionId` needs to know who _owns_ the connection. Everything else is baked into the function. But it does need to know who the owner of the connection is, which in the example above means which `User` we're looking to get the connection from. Notice that it's the `__id` of the owning type we're looking for here, not the field which has the connection.
- The first generated `connectionId` will generate an ID with `minimumCommonFriends` set to 10, and since no explicit value is given for `onlineStatuses` it will use the _default value_ for that. So, what's the default value? It's the value set in its `@argumentDefinitions` entry: `[Idle]`. So, our generated function knows about the types of each variable the connection is provided with, as well as any default value for any variable, even though the default values are actually defined inside of the GraphQL text.
- The second `connectionId2` passes explicit values for both arguments, so the default value is not used.

The type safe connection id maker will make life _much_ easier when selecting and using the connection's `__id` isn't feasible, like when you want to add or remove the new node/edge from several connections at once, or to the same connection but with multiple configs.

### Updatable fragments

[Updatable fragments](interacting-with-the-store.md#updatable-fragments) can be a great way of modifying the store after a mutation is done.

### Imperative updates

All mutation functions you use take an optional prop called `updater`. `updater` is a function that receives the Relay store (`RecordSourceSelectorProxy.t`) and the `'response` from the mutation. It lets you apply any updates to the store in response to a mutation.

### Bulk connection operations in mutations

When working with mutations that affect connections, you often need to update multiple connection instances. RescriptRelay provides utility functions that make these operations efficient:

```rescript
// Using findAllConnectionIds to add a new item to all connection instances
AddPostMutation.commitMutation(
  ~environment,
  ~variables={
    input: newPostData,
    connections: environment->RescriptRelay.Environment.findAllConnectionIds(
      ~connectionKey=UserProfile_user_postsConnection_graphql.connectionKey,
      ~parentId=userId
    )
  }
)

// Using invalidateRecordsByIds to invalidate multiple connections after a mutation
DeletePostMutation.commitMutation(
  ~environment,
  ~variables={postId: deletedPostId},
  ~updater=(store, _response) => {
    let connectionIds = environment->RescriptRelay.Environment.findAllConnectionIds(
      ~connectionKey=UserProfile_user_postsConnection_graphql.connectionKey,
      ~parentId=userId
    )
    store->RescriptRelay.RecordSourceSelectorProxy.invalidateRecordsByIds(connectionIds)
  }
)
```

> For more details on these functions, see [Bulk connection operations](interacting-with-the-store#bulk-connection-operations) and the [API Reference](api-reference#environmentfindallconnectionids).

## Declarative, optimistic updates

Optimistically updating your UI can do wonders for UX, and Relay provides all the primitives you need to do both simple and more advanced optimistic updates. Let's add a simple optimistic update to this mutation by giving Relay the response that we expect the server to return right away:

```rescript
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
)

```

So, what's going on here?

1. In addition to `variables`, we also supply `optimisticResponse` to `mutate`.
2. `optimisticResponse` is expected to _match the shape of the server response exactly_. The ReScript compiler will guide you through providing a response of the correct shape.
3. Relay will take the `optimisticResponse` and apply it as it's sending the mutation request, which in turn will make the UI update right away.

There, now we have a basic optimistic update set up! Instead of waiting for the mutation to complete, Relay will update all parts of the UI using that particular todo item's `text` field right away, and it'll roll back to the old value appropriately if the mutation fails.

### Using updatable fragments for optimistic updates

Similarly, if you're not creating new data but just modifying existing data in the store, you can use an updatable fragment for applying optimistic updates:

```rescript
mutate(
  ~variables={
    input: {
      clientMutationId: None,
      id: todoItem.id,
      text: newText,
    },
  },
  ~optimisticUpdater=(store) => {
    // TODO
  },
)

```

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

```rescript
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

```rescript
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
