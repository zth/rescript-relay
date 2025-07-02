---
id: interacting-with-the-store
title: Interacting with the store
sidebar_label: Interacting with the store
---

There are several ways to interact with and update the local Relay data store without going to the server. This is useful both in response to actual server data changing, or when using Relay as your local state handler (which is both possible and encouraged) via client schema extensions, Relay resolvers, etc.

Below is a walk through of the various methods that exist for updating the local data store in Relay, and which methods are to recommend when.

## Updating existing data with fully type safe `@updatable` fragments and queries

When you want to update data on objects that _already exist_ in the store, using `@updatable` fragments and queries is the recommended way to go. Updatable fragments and queries let you read data from the Relay store, and update it imperatively with full type safety.

Note that you can't update "linked fields" (changing `loggedInUser.bestFriend` from `User` with id `1` to `User` with id `2` instead) with this method. There are separate methods to do that.

Let's look at a few examples, starting with updatable queries.

### Updatable queries

When you want to update something that's best to access via a top level query, updatable queries is the go to solution.

Imagine we have a `loggedInUser` field on the root `Query` that's of type `User`. Via client schema extensions, we add a `lastSeen` field that we track locally. This field we want to update whenever the user touches the keyboard.

The client schema extension:

```graphql
extend type User {
  lastSeen: Datetime
}
```

Now, let's write the function that'll update that field in response to any key being pressed on the keyboard:

```rescript
// ViewerLastSeenUpdater.res
module Query = %relay(`
  query ViewerLastSeenUpdaterQuery @updatable {
    loggedInUser {
      lastSeen
    }
  }
`)

let updateLastSeen = (date: Date.t, ~environment: RescriptRelay.Environment.t) => {
  RescriptRelay.commitLocalUpdate(~environment, ~updater=store => {
    let {updatableData} = Query.readUpdatableQuery(store)

    updatableData.loggedInUser.lastSeen = date
  })
}
```

There, that's it! Notice a few things:

- You define a regular query, but add the `@updatable` directive to it. This makes the query an updatable query, which is a query only designed for updating existing data, not actually reading data for use.
- You need the Relay environment and the Relay store. You can get access to the store in the callback of `RescriptRelay.commitLocalUpdate`.
- When you have the environment and the store, pass it into `Query.readUpdatableQuery`. This will give you access to the query data like a regular query would give you too, but anything you can update is marked as `mutable` in the types, letting you imperatively update them (as seen in the example above).
- You can use variables like usual in the query if you want. If you do that, you'll need to pass the variables as well: `Query.readUpdatableQuery(store, variables)`.
- This is fully type safe, and any custom scalars you use will be autoconverted for you if necessary.

There, you can now call `updateLastSeen` with a `Date.t` and Relay will automatically update any component that uses `lastSeen` efficiently.

### Updatable fragments

Updatable fragments work just like updatable queries in that you can imperatively modify the store in a fully type safe way, but instead of starting from the top level query like in an updatable query, we start from a single entity in the store by using a fragment.

In order to use an updatable fragment, you need 2 things:

- The updatable fragment definition itself. This is a regular fragment definition tagged with `@updatable` that can only be used for reading and setting updatable data in the store.
- An _updatable_ fragment reference that references the object you want to update. You get this by spreading your updatable fragment just like you'd spread any other fragment.

Let's look at a full example. We'll borrow the approach from the updatable queries example, but instead of updating the currently logged in user's `lastSeen` via the `User`, we'll make a function that updates _any_ `User`:

```rescript
// ViewerLastSeenUpdater.res
module UpdatableFragment = %relay(`
  fragment ViewerLastSeenUpdater_user on User @updatable {
    lastSeen
  }
`)

let updateLastSeen = (date: Date.t, ~environment: RescriptRelay.Environment.t, ~updatableUser) => {
  RescriptRelay.commitLocalUpdate(~environment, ~updater=store => {
    let {updatableData} = UpdatableFragment.readUpdatableFragment(store, updatableUser)

    updatableData.lastSeen = date
  })
}
```

Not that big of a difference compared to the updatable queries, right?

This is how you'd then run this function, again drawing on the `loggedInUser` example above:

```rescript
// LoggedInUser.res
module Query = %relay(`
  query LoggedInUserQuery {
    loggedInUser {
      lastSeen
      ...ViewerLastSeenUpdater_user
    }
  }
`)

@react.component
let make = () => {
  let {loggedInUser} = Query.use(~fetchPolicy=StoreOnly)
  let environment = RescriptRelay.useEnvironmentFromContext()

  React.useEffect(() => {
    Date.make->ViewerLastSeenUpdater.updateLastSeen(~environment, ~updatableUser=loggedInUser.updatableFragmentRefs)

    None
  }, [environment])
}
```

The above code will update the `lastSeen` of the currently logged in user at mount, but leveraging updatable fragments instead of a full updatable query.

#### Updatable fragments limitations

Currently, there's a limitation with updatable fragments that means that updatable fragments can't be spread _at the top level_ of other fragments (or queries). This affects the usefulness of updatable fragments negatively, and is a limitation in Relay itself that's going to be lifted soon hopefully.

### Assignable fragments

There's a concept in Relay called [assignable fragments](https://relay.dev/docs/guided-tour/updating-data/imperatively-modifying-linked-fields). As of writing this, assignable fragments are not yet supported in RescriptRelay. However, support should come soon, and there are several existing ways of achieving the same thing.

## Committing local data

Updatable queries and fragments (and soon assignable fragments) are great for updating entities that already exist in the store. However, they can't _create_ new entities. So, when working with things like client extensions where you extend your schema with entirely new types, you'll need a good way to create and insert instances of these new types into the store.

Luckily, RescriptRelay (and Relay itself of course) has a pretty good solution to this - committing full payloads into the store.

Committing local payloads is a pretty simple concept, and in a nutshell it means that:

- We define a query, just as if we'd make a query to the server.
- Instead of sending the query to the server, we give it a response directly that we construct ourselves.
- Relay takes this response and writes it into the store just like it would if this was an actual response from the server (Relay doesn't care where the response came from).

This way, we get a fully typed interface for our data (the query itself), and we let Relay handle the data just like it would normally.

Let's say we have a simple blog post editor, and we want to leverage Relay to track the local state of whatever blog post is being worked on.

We'll start by setting up some client schema extensions:

```graphql
type BlogPostDraft {
  id: ID!
  title: String
  content: String
}

extend type Query {
  blogPostCurrentlyEditing: BlogPostDraft
}
```

Great, we have a blog post draft type, and an extension in the schema to access it. Let's set up a function that commits a local payload to insert a blog post draft into the store so we can access it:

```rescript
// Draft.res

module Query = %relay(`
  query DraftBlogPostCreateQuery @raw_response_type {
    blogPostCurrentlyEditing {
      id
      title
      content
    }
  }
`)

let setupBlogPostDraft = (environment) => {
  Query.commitLocalPayload(
    ~environment,
    ~variables=(),
    ~payload={
      blogPostCurrentlyEditing: {
        id: RescriptRelay.generateUniqueClientID(),
        title: Some(""),
        content: Some(""),
      }
    }
  )
}
```

#### `@raw_response_type`

Notice `@raw_response_type`. This is a directive that tells Relay to generate the full response type for a query. So why is this needed? And what's a "full response"?

The types you normally get for a query in Relay aren't 1:1 with what gets sent to the GraphQL server for that particular query. Instead, the types for a query correspond to what Relay gives you _after_ it has processed the server response.

In fact, Relay inserts a bunch of things automatically into your queries that you never actually see or deal with in your application. This includes simple things like the `id` field for any type that has that field, and `__typename` as needed. But also more complex things like special selections to figure out what concrete type an interface field has, and more.

You normally don't have to care about this, but as we're going to "trick" Relay into thinking what we're giving it is just a regular response, we'll need to mimic this part of Relay's behavior too. And that's what `@raw_response_type` does, it gives us access to everything Relay sends to the server.

#### `generateUniqueClientID`

Also notice we use `generateUniqueClientID` for the `id` field. `generateUniqueClientID` will create a new, client only data ID, that's guaranteed to be unique. This is useful when working with local only data like here.

### Wrapping up

Above is a simple example of using `commitLocalPayload`, but you can use all of Relay's features with it - enums, unions, and so on.

A good strategy is to use `commitLocalPayload` to insert new entites, and then more granular updatable fragments (or queries) to modifying just the parts of the entites you want to modify.

> Note: You must use `@raw_response_type` to get access to `commitLocalPayload`. RescriptRelay won't expose it unless you use that directive.

## Bulk connection operations

When working with connections, you often need to perform operations that affect multiple connection instances at once. RescriptRelay provides utility functions that make these operations easier and more efficient.

### Finding all connection instances with `findAllConnectionIds`

`Environment.findAllConnectionIds` helps you find all cached instances of a specific connection, regardless of what filters or arguments were used when fetching them. This is particularly useful when you want to update all instances of a connection after a mutation.

```rescript
// Find all instances of a user's posts connection
let connectionIds = environment->RescriptRelay.Environment.findAllConnectionIds(
  ~connectionKey="UserProfile_user_postsConnection",
  ~parentId=userId
)

// connectionIds now contains data IDs for all cached instances:
// - UserProfile_user_postsConnection({"category": "tech"})
// - UserProfile_user_postsConnection({"category": "personal"})
// - UserProfile_user_postsConnection({}) // no filters
// etc.
```

### Bulk record invalidation with `invalidateRecordsByIds`

When you need to invalidate many records at once, `RecordSourceSelectorProxy.invalidateRecordsByIds` is more efficient than calling `invalidateRecord` on each record individually.

```rescript
RescriptRelay.commitLocalUpdate(~environment, ~updater=store => {
  // Find all connection instances
  let connectionIds = environment->RescriptRelay.Environment.findAllConnectionIds(
    ~connectionKey=UserProfile_user_postsConnection_graphql.connectionKey,
    ~parentId=userId
  )

  // Invalidate all of them at once
  store->RescriptRelay.RecordSourceSelectorProxy.invalidateRecordsByIds(connectionIds)
})
```

#### Selective invalidation with `excludedIds`

Sometimes you want to invalidate most records in a list but exclude specific ones. The `excludedIds` parameter allows you to do this efficiently:

```rescript
RescriptRelay.commitLocalUpdate(~environment, ~updater=store => {
  let allConnectionIds = environment->RescriptRelay.Environment.findAllConnectionIds(
    ~connectionKey=UserProfile_user_postsConnection_graphql.connectionKey,
    ~parentId=userId
  )

  // Exclude the connection that was just updated from invalidation
  let recentlyUpdatedConnectionId = /* ... get the specific connection ID ... */

  // Invalidate all connections except the one we just updated
  store->RescriptRelay.RecordSourceSelectorProxy.invalidateRecordsByIds(
    allConnectionIds,
    ~excludedIds=[recentlyUpdatedConnectionId]
  )
})
```

This is useful when you've just updated specific connection instances and don't want to invalidate them immediately, but want to invalidate all other instances.

### Common patterns

These functions work great together for common scenarios:

**Invalidating all connection instances after a mutation:**

```rescript
// After deleting a post, invalidate all posts connections for that user
CreatePostMutation.commitMutation(
  ~environment,
  ~variables={...},
  ~updater=(store, _response) => {
    let connectionIds = environment->RescriptRelay.Environment.findAllConnectionIds(
      ~connectionKey=UserProfile_user_postsConnection_graphql.connectionKey,
      ~parentId=userId
    )
    store->RescriptRelay.RecordSourceSelectorProxy.invalidateRecordsByIds(connectionIds)
  }
)
```

**Adding a new item to all connection instances:**

```rescript
// Add new post to all cached connection instances
CreatePostMutation.commitMutation(
  ~environment,
  ~variables={
    input: newPostData,
    connections: environment->RescriptRelay.Environment.findAllConnectionIds(
      ~connectionKey=UserProfile_user_postsConnection_graphql.connectionKey,
      ~parentId=userId
    )
  }
)
```

## Listening to invalidation events

### Subscribing to invalidation state with `useSubscribeToInvalidationState`

When you invalidate records in the Relay store, queries won't automatically refetch until the next time they render. However, sometimes you need to take immediate action when specific records are invalidated, such as triggering an immediate refetch or updating some UI state.

For these scenarios, RescriptRelay provides `useSubscribeToInvalidationState` - a hook that lets you listen to invalidation events and react to them immediately.

#### Basic usage

```rescript
module UserProfile = %relay(`
  fragment UserProfile_user on User {
    __id
    name
    email
    isOnline
  }
`)

@react.component
let make = (~userRef) => {
  let user = UserProfile.use(userRef)
  let environment = RescriptRelay.useEnvironmentFromContext()

  // Subscribe to invalidation of this specific user record
  let _ = RescriptRelay.useSubscribeToInvalidationState([user.__id], () => {
    // This callback will fire whenever the user record is invalidated
    Console.log("User record was invalidated, taking action...")

    // You could trigger a refetch, show a notification, etc.
  })

  <div>
    <h1>{React.string(user.name)}</h1>
    <p>{React.string(user.email->Belt.Option.getWithDefault("No email"))}</p>
  </div>
}
```

#### Triggering immediate refetches on invalidation

One common pattern is to automatically refetch data when it becomes invalidated:

```rescript
module UserProfile = %relay(`
  fragment UserProfile_user on User
    @refetchable(queryName: "UserProfileRefetchQuery") {
    __id
    name
    email
    profile {
      bio
      lastActive
    }
  }
`)

@react.component
let make = (~userRef) => {
  let (user, refetch) = UserProfile.useRefetchable(userRef)

  // Automatically refetch when this user record is invalidated
  let _ = RescriptRelay.useSubscribeToInvalidationState([user.__id], () => {
    refetch(~variables=())->RescriptRelay.Disposable.ignore
  })

  <div>
    <h1>{React.string(user.name)}</h1>
    {switch user.profile {
    | Some(profile) =>
      <div>
        <p>{React.string(profile.bio->Belt.Option.getWithDefault("No bio"))}</p>
        <small>{React.string("Last active: " ++ profile.lastActive)}</small>
      </div>
    | None => React.null
    }}
  </div>
}
```

#### Listening to multiple records

You can listen to invalidation of multiple records at once:

```rescript
@react.component
let make = (~userIds: array<RescriptRelay.dataId>) => {
  let environment = RescriptRelay.useEnvironmentFromContext()

  // Listen to invalidation of any of these user records
  let _ = RescriptRelay.useSubscribeToInvalidationState(userIds, () => {
    // This will fire if any of the user records become invalidated
    Console.log("One or more user records were invalidated")

    // You might want to refetch a list or update some global state
  })

  // ... rest of component
}
```

#### When to use `useSubscribeToInvalidationState`

- **Real-time data updates**: When you need to immediately reflect that data has changed
- **Cache warming**: Preemptively fetching updated data before it's needed
- **UI state synchronization**: Updating component state that depends on the validity of cached data and where waiting for a re-render is not enough for the UX
- **Analytics/logging**: Tracking when specific data becomes stale

#### Integration with bulk invalidation

You can combine this with bulk invalidation patterns:

```rescript
// In a mutation updater
let invalidateUserConnections = (environment, userId, store) => {
  let connectionIds = environment->RescriptRelay.Environment.findAllConnectionIds(
    ~connectionKey=UserPosts_user_postsConnection_graphql.connectionKey,
    ~parentId=userId
  )
  store->RescriptRelay.RecordSourceSelectorProxy.invalidateRecordsByIds(connectionIds)
}

// In a component that cares about these connections
@react.component
let make = (~userId) => {
  let environment = RescriptRelay.useEnvironmentFromContext()

  React.useEffect(() => {
    let connectionIds = environment->RescriptRelay.Environment.findAllConnectionIds(
      ~connectionKey=UserPosts_user_postsConnection_graphql.connectionKey,
      ~parentId=userId
    )

    let unsubscribe = RescriptRelay.useSubscribeToInvalidationState(connectionIds, () => {
      // React to any of the user's post connections being invalidated
      Console.log("User's post connections were invalidated")
    })

    Some(unsubscribe)
  }, [userId])

  // ... rest of component
}
```

## Invalidation strategies and best practices

Understanding when and how to invalidate data is crucial for maintaining an optimal user experience. Here's a comprehensive guide to help you choose the right invalidation strategy.

### Choosing the right invalidation approach

#### 1. **Individual record invalidation** (`RecordProxy.invalidateRecord`)

**When to use:**

- Invalidating a specific entity after an update
- Simple scenarios where you know exactly which record changed
- When you want other cached data to remain valid

**Example:**

```rescript
// After updating a user's profile
UserUpdateMutation.commitMutation(
  ~environment,
  ~variables={userId, newName},
  ~updater=(store, response) => {
    // Only invalidate the specific user that was updated
    switch store->RescriptRelay.RecordSourceSelectorProxy.get(~dataId=userId) {
    | Some(userRecord) => userRecord->RescriptRelay.RecordProxy.invalidateRecord
    | None => ()
    }
  }
)
```

#### 2. **Bulk record invalidation** (`invalidateRecordsByIds`)

**When to use:**

- Invalidating multiple related records efficiently
- Connection invalidation scenarios
- When you have a list of specific records that need invalidation

**Example:**

```rescript
// After deleting a post, invalidate all comment connections for that post
DeletePostMutation.commitMutation(
  ~environment,
  ~variables={postId},
  ~updater=(store, _response) => {
    let connectionIds = environment->RescriptRelay.Environment.findAllConnectionIds(
      ~connectionKey=PostComments_post_commentsConnection_graphql.connectionKey,
      ~parentId=postId
    )
    store->RescriptRelay.RecordSourceSelectorProxy.invalidateRecordsByIds(connectionIds)
  }
)
```

#### 3. **Store-wide invalidation** (`RecordSourceSelectorProxy.invalidateStore`)

**When to use:**

- Major data changes that affect many parts of your app
- User authentication state changes
- App-wide cache clearing scenarios
- When in doubt and you need to ensure data freshness

**Example:**

```rescript
// After user logs out
LogoutMutation.commitMutation(
  ~environment,
  ~variables=(),
  ~updater=(store, _response) => {
    // Invalidate everything since user context has changed
    store->RescriptRelay.RecordSourceSelectorProxy.invalidateStore
  }
)
```

### Invalidation timing and performance considerations

#### Lazy invalidation (default behavior)

By default, invalidated data only triggers refetches when the component next renders. This is usually the most efficient approach:

```rescript
// Invalidation happens in mutation updater
SomeDataMutation.commitMutation(~environment, ~variables, ~updater=(store, _) => {
  // Record is marked as invalid
  someRecord->RescriptRelay.RecordProxy.invalidateRecord
})

// Component will refetch when it next renders
// This could be immediately if the component is already rendered and a rerender is triggered,
// or later when the user navigates to a view that uses this data
```

#### Immediate invalidation with refetch

Use `useSubscribeToInvalidationState` when you need immediate reactions:

```rescript
// Component automatically refetches when data is invalidated
let (data, refetch) = SomeFragment.useRefetchable(fragmentRef)

RescriptRelay.useSubscribeToInvalidationState([data.__id], () => {
  refetch(~variables=())->RescriptRelay.Disposable.ignore
})
```

## Imperative updates

> Using imperative store updates has its place, but avoid it for as long as you can.

The final and most "free" (and unsafe!) way of updating the store is to use Relay's imperative and untyped API.

Since there's no type information retained in runtime for Relay inside of the store, the store itself is just a generic storage of values. Relay lets you modify this store however you want imperatively.

### Modifying the store imperatively

The store is made up of _records_. These records are your objects in the GraphQL graph. Records can have fields that store data (scalars, custom scalars), or links to other records (`bestFriend: User`, `bestFriend` is a linked record).

Use `RescriptRelay.commitLocalUpdate` to access the store imperatively (the same as for updatable fragments and queries):

```rescript
module Fragment = %relay(`
  fragment SomeComponent_user on User {
    __id # special Relay field that gives you access to this object's data ID directly
  }
`)

RescriptRelay.commitLocalUpdate(~environment, ~updater=store => {
  open RescriptRelay

  switch store->RecordSourceSelectorProxy.get(~dataId=user.__id) {
  | None => Console.log("User not found")
  | Some(userProxy) => let _ = userProxy->RecordProxy.setValueString(~name="firstName", ~value="Maja")
  }
})
```

The code above is pseudo-code, but it gives you a hint of what it'd look like to set the `firstName` of a `User` using the imperative API.
