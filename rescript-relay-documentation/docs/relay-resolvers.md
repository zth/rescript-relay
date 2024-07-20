---
id: relay-resolvers
title: Relay Resolvers
sidebar_label: Relay Resolvers
---

RescriptRelay supports Relay Resolvers, a somewhat new concept in Relay that lets you extend your schema locally with actual resolvers.

You're encouraged to read the [official Relay documentation on resolvers](https://relay.dev/docs/guides/relay-resolvers/introduction/) first. This part of the docs will not re-introduce Relay resolvers, but rather talk about how they work in RescriptRelay.

Using Relay resolvers in RescriptRelay is very similar to stock Relay. However, there are a few differences:

1. One important thing to keep in mind is that _you don't need to annotate your function arguments_ in RescriptRelay. Types for your resolver functions will be automatically generated, and injected into your resolver code.
2. There are currently rules for how you need to name files containing your local models, whether they are `@weak` or not.

Also, remember that Relay resolvers are always nullable in the schema, but non-nullable in the resolver. If you can't return a value for a resolver, you'd throw and Relay will catch that and turn it into `null`:

```rescript
/**
 * @RelayResolver UserMeta.online: Boolean
 */
let online = userMeta => {
  if userMeta.online {
    true
  } else {
    panic("Could not lookup online status")
  }
}
```

### Naming rules for local models

Relay resolvers let you define local models to back your local GraphQL types, just like you would in a regular GraphQL server. In RescriptRelay, these local models need to be defined in a certain way.

1. They must be in their own file, named `Relay<modelName>Model.res`. So, if you wanted to define a local model called `LocalUser`, you'd create a file called `RelayLocalUserModel.res`.
2. Each file must define a `type t`. This is the backing type for that model.

### Examples

Below are a few examples of how using resolvers in RescriptRelay looks, in various ways:

#### Using with fragments (a "derived" resolver)

```rescript
module Fragment = %relay(`
  fragment UserResolverFullname on User {
    firstName
    lastName
  }
`)

/**
 * @RelayResolver User.fullName(maxLength: Int!): String
 * @rootFragment UserResolverFullname
 *
 * A users full name.
 */
let fullName = (user, args) => {
  let user = Fragment.readResolverFragment(user)
  `${user.firstName} ${user.lastName}`->String.slice(~start=0, ~end=args.maxLength)
}

```

#### Defining a local model and exposing fields on that

The model:

```rescript
// RelayLocalUserModel.res
type t = {
  id: string,
  name: string,
}

module UserService = {
  let getById = id => Some({id, name: "Test User"})
}
/**
 * @RelayResolver LocalUser
 */
let localUser = id => {
  UserService.getById(id->RescriptRelay.dataIdToString)
}
```

Exposing fields on that model:

```rescript
/**
 * @RelayResolver LocalUser.name: String
 */
let name = user => {
  user.name
}

/**
 * @RelayResolver LocalUser.nameRepeated(times: Int!): String
 */
let nameRepeated = (user, args) => {
  user.name->Js.String2.repeat(args.times)
}
```

#### Using `@live` to expose external data that might update

```rescript
/**
 * @RelayResolver LocalUser.hasBeenOnlineToday: Boolean
 * @live
 */
let hasBeenOnlineToday = user => {
  read: _suspenseSentinel => {
    UserService.getUserStatus(user.id)
  },
  subscribe: cb => {
    let id = UserService.subscribe(cb)
    () => UserService.unsubscribe(id)
  },
}
```

#### Using `@live` with suspense to expose data that might be async

```rescript
/**
 * @RelayResolver LocalUser.hasBeenOnlineToday: Boolean
 * @live
 */
let hasBeenOnlineToday = user => {
  read: suspenseSentinel => {
    switch UserService.getUserStatus(user.id) {
    | Fetching => suspenseSentinel->RescriptRelay.SuspenseSentinel.suspend
    | Value(v) => v
    }
  },
  subscribe: cb => {
    let id = UserService.subscribe(cb)
    () => UserService.unsubscribe(id)
  },
}
```

Notice how we're using `suspenseSentinel` and `SuspenseSentinel.suspend` to suspend when data is not available yet.

#### Using `@weak` models

Define a weak model:

```rescript
// RelayUserMetaModel.res

/**
 * @RelayResolver UserMeta
 * @weak
 */
type t = {online: bool}

```

Expose fields on that model:

```rescript
/**
 * @RelayResolver UserMeta.online: Boolean
 */
let online = userMeta => {
  userMeta.online
}
```

Return that model as a field attached on another type:

```rescript
/**
 * @RelayResolver LocalUser.meta: UserMeta
 */
let meta = user => {
  {
    online: user.name === "Test User",
  }
}
```
