---
id: using-fragments
title: Using Fragments
sidebar_label: Using Fragments
---

#### Recommended background reading

- [Fragments in GraphQL](https://graphql.org/learn/queries/#fragments)
- [A Guided Tour of Relay: Fragments](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay#fragments)

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

### Fragments in ReasonRelay

Fragments are defined in ReasonRelay by using the `[%relay.fragment]` extension node. Here's an example of a fragment and a component that renders the fragment data:

```reason
/* UserProfileHeader.re */
module UserFragment = [%relay.fragment {|
  fragment UserProfileHeader_user on User {
    firstName
    lastName
  }
|}];

[@react.component]
let make = (~user) => {
  let user = UserFragment.use(user);

  <div>{React.string(user.firstName ++ " " ++ user.lastName)}</div>
}
```

Let's break down what's happening here:

1. We define a fragment on the GraphQL type `User` through `[%relay.fragment]`.
2. We define a React component that takes a `user` prop.
3. `[%relay.fragment]` will autogenerate a React hook called `use`, which takes any object containing a fragment reference for that particular fragment, and returns the data.
4. Just as with queries, `use` for fragments is integrated with [React suspense](https://reactjs.org/docs/concurrent-mode-suspense.html), meaning that `use` will suspend if the data's not already there.

### Fragment references and how Relay transports fragment data

A fragment _always has to end up in a query_ at some point for it to be able to render. This is quite simply because a fragment is a _specification of what data is needed_, and somebody (I'm looking at you query) needs to take this specification and get the actual data from the server. Let's tie together the sample fragment code from above with the sample code from [making queries](making-queries) in order to demonstrate how components with fragments are used with other components, and how the fragment ends up in a query:

```reason
/* UserProfile.re */
module Query = [%relay.query {|
  query UserProfileQuery($userId: ID!) {
    userById(id: $userId) {
      ...UserProfileHeader_user
    }
  }
|}];

[@react.component]
let make = (~userId) => {
  let queryData = Query.use(~variables={
    userId: userId
  }, ());

  switch(queryData.userById) {
    | Some(user) => <UserProfileHeader user={user.fragmentRefs} />
    | None => React.null
  };
}
```

Let's break down what has changed:

1. In order for us to be able to render `<UserProfileHeader />` in `<UserProfile />`, we need to provide it with the data it needs from the `User` type. It defines what data it needs from `User` via the fragment `UserProfileHeader_user`, so we _spread that fragment_ on a `User` object in our query. This will ensure that the data demands on `User` for `<UserProfileHeader />` is fetched in the query.
2. When we get the data from `Query.use`, the object where we spread `UserProfileHeader_user` will include a _fragment reference_ for that fragment. Fragment references are how Relay carries the data for fragments, and each fragment `use` hook knows how to _take a `fragmentRefs` prop containing its own fragment reference and use it to get its own data_.

Any object (it's actually a ReasonML record, but I'll call it object here) where one or more fragments have been spread will have a prop called `fragmentRefs`. That prop will contain all fragment references for all fragments spread. Incidentally, this is exactly what the respective fragment's `use` hook wants!

3. We make sure we actually got a user, and then we take the `userById` object (where we spread `UserProfileHeader_user`), and pass the fragment references to `<UserProfileHeader />` via `userById.fragmentReferences`. That component then passes that to the fragment `UserProfileHeader_user` `use` hook, which then exchanges it for the actual fragment data.

Phew! That's a lot to break down. It's really not that complicated to use though.

### Fragments in fragments

Yup, you read that right, you can _spread fragments on other fragments_. Remember, a fragment _at some point_ must end up in a query to be usable, but it doesn't mean that each fragment must be spread on a query.

Let's expand our example fragment component to use another component `<Avatar />` that is responsible for showing a an avatar for a user:

```reason
/* UserProfileHeader.re */
module UserFragment = [%relay.fragment {|
  fragment UserProfileHeader_user on User {
    firstName
    lastName
    ...Avatar_user
  }
|}];

[@react.component]
let make = (~user) => {
  let user = UserFragment.use(user);

  <div>
    <Avatar user={user.fragmentRefs} />
    {React.string(user.firstName ++ " " ++ user.lastName)}
  </div>
}
```

See the difference? Let's break it down:

1. We want to render `<Avatar />`, and it needs data from `User`. So, we spread its data demands on the user type that we're already getting data for. That will create a fragment reference for `Avatar_user` on the `user` record we get back from `UserFragment.use`.
2. We then pass `userData.fragmentRefs` to `<Avatar />`. `<Avatar />` then uses that to get the data it needs from `User`.

We don't have to change anything anywhere else. `<UserProfile />`, who defines the query and fetches the data, does not need to know anything about this change. It just knows that it needs to get the data for `UserProfileHeader_user` - it's not concerned with how that data looks or if it includes more fragments. It just gets the data for `UserProfileHeader_user`, passes it along and minds its own business.

This is a core strength of Relay called _data masking_ - no data is available to anyone unless they explicitly ask for it. You can [read more about data masking in Relay here](https://relay.dev/docs/en/thinking-in-relay.html#data-masking).

## Using fragments outside of React's render phase

You can also use fragments outside of React's render phase (read: without using hooks). In addition to `Fragment.use`, each fragment will autogenerate a function called `Fragment.readInline`.

This works the same way as `Fragment.use` as in you feed it an object with a fragment reference for that particular fragment. But, when you run the function, you'll get a one-shot snapshot of that fragment data from the store as it is _right now_.

Great for logging and similar activities. Example:

```reason
/* SomeCoolLogger.re */
module UserFragment = [%relay.fragment {|
  fragment SomeCoolLogger_user on User {
    customerId
    someOtherMetaDataProp
  }
|}];

let logPurchase = (user) => {
  // We read the fragment data from the store here, without needing to use a hook
  let userData = UserFragment.readInline(user);

  SomeLoggingService.log(
    ~customerId=userId.customerId,
    ~someOtherMetaDataProp=userId.someOtherMetaDataProp,
    ()
  );
}
```

```reason
/* BuyButton.re */
[@react.component]
let make = (~user) => {
  <button onClick={_ => {
    // user here contains the fragment reference for SomeCoolLogger_user defined above
    SomeCoolLogger.logPurchase(user);
  }}>
    {React.string("Buy stuff!")}
  </button>
}
```

## On to the next thing

That's a basic introduction to fragments. There are a few more concepts around fragments that are worth spending some time to grok. However, none of them are specific to using Relay with Reason, so you can read more about them in the [Relay documentation](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay#rendering-data-basics) below.

Before we move on to the next thing, there's a few things that's worth keeping in mind about fragments:

- Use fragments as much as you can. They are optimized for performance and help promote well contained and isolated components
- A component can use any number of fragments, not just one
- A fragment can use other fragments
- Any object where a fragment has been spread will have a prop called `fragmentRefs`. This contains references for all fragments that have been spread on that object. You pass that `fragmentReferences` prop to the respective fragment's `use` hooks.

With that in mind, Let's jump in to [mutations](mutations).

## API Reference

`[%relay.fragment]` is expanded to a module containing the following functions:

### `use`

`SomeFragment.use` is a React hook that takes an object containing a fragment reference for that particular fragment, and returns the fragment data.

> `use` uses Relay's `useFragment` under the hood, which you can [read more about here](https://relay.dev/docs/en/experimental/api-reference#usefragment).

### `readInline`

`SomeFragment.readInline` is a function that takes an object containing a fragment reference for that particular fragment, and returns the fragment data. Can be used outside of React's render phase.

> `readInline` uses Relay's `readInlineData` under the hood.
