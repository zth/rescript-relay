---
id: using-fragments
title: Using Fragments
sidebar_label: Using Fragments
---

#### Recommended background reading

- [Fragments in GraphQL](https://graphql.org/learn/queries/#fragments)
- [A Guided Tour of Relay: Fragments](https://relay.dev/docs/guided-tour/rendering/fragments)

Videos from the Relay video series covering fragments:

<iframe
  width="560"
  height="315"
  src="https://www.youtube.com/embed/W3fcG239i-I"
  title="YouTube video player"
  frameborder="0"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
  allowfullscreen>
</iframe>

## Using Fragments

One of the main things that make Relay so powerful is using _GraphQL fragments_ to co-locate the data-demands of your components with your actual component code. This leads to well-isolated components that are very portable and easy to maintain.

### A high-level overview of fragments

Fragments are GraphQL snippets that can be reused throughout your GraphQL operations. At it's core, a fragment is a _selection of fields_ on a specific _GraphQL type_.

Let's examplify through a basic query, first without fragments:

```graphql
query {
  me {
    firstName
    lastName
    friendCount
    avatarUrl
  }
}
```

Here's a very basic query that selects a bunch of fields on the logged in `User`. Let's look at the same query, but using fragments representing the various components that would display the data:

```graphql
fragment UserNameDisplayer on User {
  firstName
  lastName
}

fragment Avatar on User {
  firstName # needed for a nice alt-tag
  lastName
  avatarUrl
}

fragment FriendCountDisplayer on User {
  friendCount
}

query {
  me {
    ...UserNameDisplayer
    ...Avatar
    ...FriendCountDisplayer
  }
}
```

See the difference? We've split our data demands on `me` into fragments responsible for displaying a certain part of the `User`, much like we'd do with React components, delegating displaying different parts of the UI to different, specialized components.

If you want to dive deeper into GraphQL fragments you're encouraged to read through [the official documentation on fragments in GraphQL](https://graphql.org/learn/queries/#fragments).

### Fragments in RescriptRelay

Fragments are defined in RescriptRelay by using the `%relay()` extension node. Here's an example of a fragment and a component that renders the fragment data:

```rescript
/* UserProfileHeader.res */
module UserFragment = %relay(
  `
  fragment UserProfileHeader_user on User {
    firstName
    lastName
  }
`
)

@react.component
let make = (~user) => {
  let user = UserFragment.use(user)

  <div> {React.string(user.firstName ++ (" " ++ user.lastName))} </div>
}

```

> A note on naming: Due to the rules of Relay, a fragment must be named `<ModuleName><optionally_anything_here>_<identifier>`, where module name here means _file name_, not ReScript module name. So for a file `UserProfile.res`, all fragments in that file must start with `UserProfile` regardless of whether they're defined in nested modules or not. _Identifier_ can be anything, but it's common to name that after the GraphQL type the fragment targets, lowercased. So a fragment in `UserProfile.res` that targets the `User`, would commonly be called `UserProfile_user`.

> Using VSCode? Our [dedicated VSCode extension](vscode-extension) lets you codegen new fragments (and optionally boilerplate for a component) via the command `> Add fragment`.

Let's break down what's happening here:

1. We define a fragment on the GraphQL type `User` through `%relay()`.
2. We define a React component that takes a `user` prop.
3. `%relay()` with a fragment defined in it will autogenerate a React hook called `use`, which takes any object containing a fragment reference for that particular fragment, and returns the data.
4. Just as with queries, `use` for fragments is integrated with [React suspense](https://reactjs.org/docs/concurrent-mode-suspense.html), meaning that `use` will suspend if the data's not already there.

### Fragment references and how Relay transports fragment data

A fragment _always has to end up in a query_ at some point for it to be able to render. This is quite simply because a fragment is a _specification of what data is needed_, and somebody (I'm looking at you query) needs to take this specification and get the actual data from the server. Let's tie together the sample fragment code from above with the sample code from [making queries](making-queries) in order to demonstrate how components with fragments are used with other components, and how the fragment ends up in a query:

```rescript
/* UserProfile.res */
module Query = %relay(
  `
  query UserProfileQuery($userId: ID!) {
    userById(id: $userId) {
      ...UserProfileHeader_user
    }
  }
`
)

@react.component
let make = (~userId) => {
  let queryData = Query.use(
    ~variables={
      userId: userId,
    }
  )

  switch queryData.userById {
  | Some(user) => <UserProfileHeader user=user.fragmentRefs />
  | None => React.null
  }
}

```

Let's break down what has changed:

1. In order for us to be able to render `<UserProfileHeader />` in `<UserProfile />`, we need to provide it with the data it needs from the `User` type. It defines what data it needs from `User` via the fragment `UserProfileHeader_user`, so we _spread that fragment_ on a `User` object in our query. This will ensure that the data demands on `User` for `<UserProfileHeader />` is fetched in the query.
2. When we get the data from `Query.use`, the object where we spread `UserProfileHeader_user` will include a _fragment reference_ for that fragment. Fragment references are how Relay carries the data for fragments, and each fragment `use` hook knows how to _take a `fragmentRefs` prop containing its own fragment reference and use it to get its own data_.

Any object (it's actually a ReScript record, but I'll call it object here) where one or more fragments have been spread will have a prop called `fragmentRefs`. That prop will contain all fragment references for all fragments spread. Incidentally, this is exactly what the respective fragment's `use` hook wants!

3. We make sure we actually got a user, and then we take the `userById` object (where we spread `UserProfileHeader_user`), and pass the fragment references to `<UserProfileHeader />` via `userById.fragmentReferences`. That component then passes that to the fragment `UserProfileHeader_user` `use` hook, which then exchanges it for the actual fragment data.

Phew! That's a lot to break down. It's really not that complicated to use though.

### Conditional fragments and more with the `@alias` directive

> Recommended background reading: https://relay.dev/docs/guides/alias-directive/

Notice that by default _all_ fragment references on the same object are nested within the same `fragmentRefs` property. This is convenient because you can pass that `fragmentRefs` to any component that expects fragment data on that object, without having to care about pulling out that specific fragment's data.

However, there are a few scenarios where this causes problems:

1. Conditional fragments `...SomeComponent_someFragment @include(if: $someVariable)`. There's no way to figure out if this fragment was actually included or not without also knowing the value of `$someVariable`.
2. Abstract types and fragment spreads. [Read more in the Relay docs](https://relay.dev/docs/guides/alias-directive/#abstract-types).

`@alias` solves these problems by putting each fragment with `@alias` _on its own property_. So, for the `SomeComponent_someFragment` example above, instead of referencing `fragmentRefs` to access the fragment reference for `SomeComponent_someFragment`, you'd find it under a property called `someComponent_someFragment`. And _that_ property will be optional and not present if the fragment is not included.

This solves a major safety issue in Relay, as well as enable things like easy conditional fragments.

A full example of what it looks like in RescriptRelay:

```rescript
/* UserProfileHeader.res */
module UserFragment = %relay(
  `
  fragment UserProfileHeader_user on User {
    firstName
    lastName
    ...Avatar_user @alias
  }
`
)

@react.component
let make = (~user) => {
  let user = UserFragment.use(user)

  <div>
    <Avatar user=user.avatar_user /> {React.string(user.firstName ++ " " ++ user.lastName)}
  </div>
}

```

There's more fancy stuff you can do with `@alias`, including controlling what the property name for the fragment ends up as in the types. You're encouraged to read the [official Relay docs](https://relay.dev/docs/guides/alias-directive) to learn more.

Also, please note you'll need to enable `@alias` in your Relay config:

```javascript
// relay.config.js
module.exports = {
  schema: "./schema.graphql",
  artifactDirectory: "./src/__generated__",
  src: "./src",
  featureFlags: {
    enable_relay_resolver_transform: true,
    enable_fragment_aliases: {
      kind: "enabled",
    },
  },
};
```

### Fragments in fragments

Yup, you read that right, you can _spread fragments on other fragments_. Remember, a fragment _at some point_ must end up in a query to be usable, but it doesn't mean that each fragment must be spread on a query.

Let's expand our example fragment component to use another component `<Avatar />` that is responsible for showing a an avatar for a user:

```rescript
/* UserProfileHeader.res */
module UserFragment = %relay(
  `
  fragment UserProfileHeader_user on User {
    firstName
    lastName
    ...Avatar_user
  }
`
)

@react.component
let make = (~user) => {
  let user = UserFragment.use(user)

  <div>
    <Avatar user=user.fragmentRefs /> {React.string(user.firstName ++ " " ++ user.lastName)}
  </div>
}

```

See the difference? Let's break it down:

1. We want to render `<Avatar />`, and it needs data from `User`. So, we spread its data demands on the user type that we're already getting data for. That will create a fragment reference for `Avatar_user` on the `user` record we get back from `UserFragment.use`.
2. We then pass `userData.fragmentRefs` to `<Avatar />`. `<Avatar />` then uses that to get the data it needs from `User`.

We don't have to change anything anywhere else. `<UserProfile />`, who defines the query and fetches the data, does not need to know anything about this change. It just knows that it needs to get the data for `UserProfileHeader_user` - it's not concerned with how that data looks or if it includes more fragments. It just gets the data for `UserProfileHeader_user`, passes it along and minds its own business.

This is a core strength of Relay called _data masking_ - no data is available to anyone unless they explicitly ask for it. You can [read more about data masking in Relay here](https://relay.dev/docs/principles-and-architecture/thinking-in-relay/#data-masking).

## Arguments in fragments

Fragments can define _arguments_. The [Relay docs on arguments in fragments](https://relay.dev/docs/guided-tour/rendering/variables/#arguments-and-argumentdefinitions) explain the concept well enough, so we'll just focus on the differences between RescriptRelay and regular Relay.

### Provided variables in RescriptRelay

Provided variables [is a Relay concept](https://relay.dev/docs/api-reference/graphql-and-directives/#provided-variables) that lets you provide _constant values_ (where the value itself is resolved from ReScript) as variables to a fragment. This removes the need to orchestrate adding your constants as regular query variables in every single query where you'd like to use them. It also encapsulates the variable so that the fragment is the only thing that needs to care about it.

Here's an example of how using provided variables in RescriptRelay looks:

```rescript
// SomeModule.res
module Fragment = %relay(`
  fragment SomeModule_user @argumentDefinitions(
    pixelRatio: {type: "Float!", provider: "MyProvidedVariables.PixelRatio"}
  ) {
    name
    avatar(pixelRatio: $pixelRatio)
  }
`)

// MyProvidedVariables.res
module PixelRatio = {
  let get = () => getDevicePixelRatio()
}
```

Let's distill it:

- We're defining a `pixelRatio` argument for our fragment, and give it a `provider`.
- The `provider` argument points to a _ReScript module_. This module should define a `get` function that takes `unit` and returns the same type as is defined inside `type` of the argument. So for the example above, that is `let get: unit => float`. The compiler will enforce that you get the types right.
- Relay will then automatically wire together `MyProvidedVariables.PixelRatio` with the fragment.

## Using fragments outside of React's render phase

You can also use fragments outside of React's render phase (read: without using hooks). In addition to `Fragment.use`, each fragment will autogenerate a function called `Fragment.readInline` _if your fragment is annotated with `@inline`_.`@inline` tells Relay you'll want to read this fragment outside of React's render phase.

This works the same way as `Fragment.use` as in you feed it an object with a fragment reference for that particular fragment. But, when you run the function, you'll get a one-shot snapshot of that fragment data from the store as it is _right now_.

Great for logging and similar activities. Example:

```rescript
/* SomeCoolLogger.res */
module UserFragment = %relay(
  `
  fragment SomeCoolLogger_user on User @inline {
    customerId
    someOtherMetaDataProp
  }
`
)

let logPurchase = user => {
  /* We read the fragment data from the store here, without needing to use a hook */
  let userData = UserFragment.readInline(user)

  SomeLoggingService.log(
    ~customerId=userId.customerId,
    ~someOtherMetaDataProp=userId.someOtherMetaDataProp,
  )
}

```

```rescript
/* BuyButton.res */
@react.component
let make = (~user) =>
  <button
    onClick={_ =>
      /* user here contains the fragment reference for SomeCoolLogger_user defined above */
      SomeCoolLogger.logPurchase(user)}>
    {React.string("Buy stuff!")}
  </button>

```

## On to the next thing

That's a basic introduction to fragments. There are a few more concepts around fragments that are worth spending some time to grok. However, none of them are specific to using Relay with ReScript, so you can read more about them in the [Relay documentation](https://relay.dev/docs/guided-tour/rendering/fragments) below.

Before we move on to the next thing, there's a few things that's worth keeping in mind about fragments:

- Use fragments as much as you can. They are optimized for performance and help promote well contained and isolated components
- A component can use any number of fragments, not just one
- A fragment can use other fragments
- Any object where a fragment has been spread will have a prop called `fragmentRefs`. This contains references for all fragments that have been spread on that object. You pass that `fragmentReferences` prop to the respective fragment's `use` hooks.
- `@alias` let's you know for sure whether a fragment has been included (and matches) or not.

With that in mind, Let's jump in to [mutations](mutations).

## API Reference

`%relay()` is expanded to a module containing the following functions:

### `use`

`SomeFragment.use` is a React hook that takes an object containing a fragment reference for that particular fragment, and returns the fragment data.

> `use` uses Relay's `useFragment` under the hood, which you can [read more about here](https://relay.dev/docs/api-reference/use-fragment).

### `readInline`

> Your fragment needs to be annotated with [`@inline`](https://relay.dev/docs/api-reference/graphql-and-directives/#inline) for this function to appear.

`SomeFragment.readInline` is a function that takes an object containing a fragment reference for that particular fragment, and returns the fragment data. Can be used outside of React's render phase.

> `readInline` uses Relay's `readInlineData` under the hood.
