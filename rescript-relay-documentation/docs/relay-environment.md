---
id: relay-environment
title: Relay Environment
sidebar_label: Relay Environment
---

This section of the docs is quite lacking. However, most of the information you need is available in the [official Relay documentation](https://relay.dev/docs/guided-tour/rendering/environment).

## Missing field handlers

> Start by reading [this section of the Relay docs](https://relay.dev/docs/guided-tour/reusing-cached-data/filling-in-missing-data/).

> API reference for missing field handlers is [available here](api-reference#missingfieldhandler)

Missing field handlers are a powerful feature that allows you to teach Relay about relations in your schema in order to increase cache hits. They help Relay understand that different queries may point to the same data, enabling better cache reuse.

### When to use missing field handlers

Missing field handlers are useful when:

1. **Different queries access the same data**: For example, `user(id: 123)` and `node(id: 123)` might return the same user object
2. **You want to derive scalar values**: Computing values from existing cached data
3. **You need to resolve relationships**: Helping Relay understand connections between objects in your cache

In general, there should be no need to use this for most projects. But, occasionally there will be good reason to do so.

The section below details how missing field handlers work in `RescriptRelay`. Please start by reading the Relay documentation linked above to have a good understanding of how this works in Relay in general.

### Creating missing field handlers

You create a missing field handler by using the appropriate make-method from the module [`RescriptRelay.MissingFieldHandler`](api-reference#missingfieldhandler). These are:

1. [`makeScalarMissingFieldHandler`](api-reference#missingfieldhandlermakescalarmissingfieldhandler) for creating a missing field handler for scalar values (like a `name` on a `User`).
2. [`makeLinkedMissingFieldHandler`](api-reference#missingfieldhandlermakelinkedmissingfieldhandler) for creating a missing field handler for a single linked record (like a `Pet` on the field `favoritePet` on a `User`).
3. [`makePluralLinkedMissingFieldHandler`](api-reference#missingfieldhandlermakeplurallinkedmissingfieldhandler) for creating a missing field handler for lists of linked records (like a list of `Pet` on the field `allPets` on a `User`).

### Built-in Node Interface Missing Field Handler

RescriptRelay ships with a built-in missing field handler for the [Node interface](https://graphql.org/learn/global-object-identification/), which is automatically enabled when you create an environment.

#### What it does

The node interface missing field handler enables automatic resolution of cached items through the `node` field. It teaches Relay that the top level `node` field can do a cache-lookup from the ID it gets:

```graphql
query NodeQuery {
  node(id: "123") {
    ... on User {
      name
    }
  }
}
```

If you've previously fetched `User` with the `id` of `123`, and later execute the `NodeQuery`, Relay will automatically resolve the data from cache without making a network request.

#### Automatic enablement

The node interface handler is automatically included when you create an environment:

```rescript
// When you create an environment like this:
let environment = RescriptRelay.Environment.make(
  ~network,
  ~store,
  ~missingFieldHandlers=[customHandler1, customHandler2], // Your custom handlers
)

// RescriptRelay automatically adds the node interface handler:
// The actual handlers array becomes: [customHandler1, customHandler2, nodeInterfaceMissingFieldHandler]
```

If you don't provide any custom handlers, only the node interface handler is used:

```rescript
let environment = RescriptRelay.Environment.make(~network, ~store)
// Handlers array: [nodeInterfaceMissingFieldHandler]
```

### Adding custom missing field handlers

To add your own missing field handlers to an environment:

```rescript
let customHandlers = [
  fullNameHandler,
  userLinkHandler,
  userPostsHandler,
]

let environment = RescriptRelay.Environment.make(
  ~network,
  ~store,
  ~missingFieldHandlers=customHandlers,
)
```
