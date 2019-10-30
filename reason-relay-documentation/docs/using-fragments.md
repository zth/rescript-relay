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
let make = (~user as userRef) => {
  let user = UserFragment.use(userRef);

  <div>{React.string(user##firstName ++ " " ++ user##lastName)}</div>
}
```

Let's break down what's happening here:

1. We define a fragment on the GraphQL type `User` through `[%relay.fragment]`.
2. We define a React component that takes a `user` prop, which we rename to `userRef`. _The renaming is totally optional_ and just something that helps clarify that the prop has to do with a _fragment reference_. Fragment references are central to how Relay fragments work, and we'll talk about them in the section below.
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
    "userId": userId
  }, ());

  switch(queryData##userById |> Js.Nullable.toOption) {
    | Some(user) => <UserProfileHeader user />
    | None => React.null
  };
}
```

Let's break down what has changed:

1. In order for us to be able to render `<UserProfileHeader />` in `<UserProfile />`, we need to provide it with the data it needs from the `User` type. It defines what data it needs from `User` via the fragment `UserProfileHeader_user`, so we _spread that fragment_ in our query. This will ensure that the data demands on `User` for `<UserProfileHeader />` is fetched in the query.
2. When we get the data from `Query.use`, the object where we spread the `UserProfileHeader_user` fragment will include a _fragment reference_ for that particular fragment. Fragment references are how Relay carries the data for fragments, and each fragment `use` hook knows how to _take an object containing its own fragment reference and use it to get its own data_. This is means you always _pass the entire object containing your fragment reference_ to your fragment's `use` hook.
3. We make sure we actually got a user, and then we pass the full `userById` object (where we have spread `UserProfileHeader_user`) to `<UserProfileHeader />`. That component then passes that prop to the fragment's `use` hook, which exchanges it for the actual fragment data.

Phew! That's a lot to break down. It's really not that complicated to use though, just remember that _fragments needs a fragment reference to get data_, and that _fragment references are created by spreading the fragments in queries (or other fragments)_.

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
let make = (~user as userRef) => {
  let user = UserFragment.use(userRef);

  <div>
    <Avatar user />
    {React.string(user##firstName ++ " " ++ user##lastName)}
  </div>
}
```

See the difference? Let's break it down:

1. We want to render `<Avatar />`, and it needs data from `User`. So, we spread its data demands on the user type that we're already getting data for. That will create a fragment reference for `Avatar_user` on the `user` object we get back from `UserFragment.use`.
2. We then simply pass that object to `<Avatar />`, and `<Avatar />` uses that to get the data it needs from `User`.

We don't have to change anything anywhere else. `<UserProfile />`, who defines the query and fetches the data, does not need to know anything about this change. It just knows that it needs to get the data for `UserProfileHeader_user` - it's not concerned with how that data looks or if it includes more fragments. It just gets the data for `UserProfileHeader_user`, passes it along and minds its own business.

This is a core strength of Relay called _data masking_ - no data is available to anyone unless they explicitly ask for it. You can [read more about data masking in Relay here](https://relay.dev/docs/en/thinking-in-relay.html#data-masking).

## On to the next thing

That's a basic introduction to fragments. There are a few more concepts around fragments that are worth spending some time to grok. However, none of them are specific to using Relay with Reason, so you can read more about them in the [Relay documentation](https://relay.dev/docs/en/experimental/a-guided-tour-of-relay#rendering-data-basics) below.

Before we move on to the next thing, there's a few things that's worth keeping in mind about fragments:

- Use fragments as much as you can. They are optimized for performance and help promote well contained and isolated components
- A component can use any number of fragments, not just one
- A fragment can use other fragments

With that in mind, Let's jump in to [mutations](mutations).

## API Reference

`[%relay.fragment]` is expanded to a module containing the following functions:

### `use`

`SomeFragment.use` is a React hook that takes an object containing a fragment reference for that particular fragment, and returns the fragment data.

> `use` uses Relay's `useFragment` under the hood, which you can [read more about here](https://relay.dev/docs/en/experimental/api-reference#usefragment).
