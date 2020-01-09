---
id: unions
title: Unions
sidebar_label: Unions
---

#### Recommended background reading

- [Union Types in GraphQL](https://graphql.org/learn/schema/#union-types)

## Unions in ReasonRelay

Since ReasonML's type system is quite different to Flow/TypeScript, working with unions is different in ReasonRelay compared to regular Relay. In ReasonRelay, every union is _unwrapped to a polymorphic variant_.

Let's clarify this with an example. Imagine this GraphQL schema:

```graphql
type User {
  id: ID!
  firstName: String!
  lastName: String!
}

type Group {
  id: ID!
  name: String!
}

union Owner = User | Group

type Query {
  roomOwner(roomId: ID!): Owner
}
```

Here we have a union `Owner` that's either a `User` or a `Group`. There's also a root field called `roomOwner` which returns the `Owner` of a room. Let's look at how using that union looks in ReasonRelay:

```reason
/* RoomOwner.re */
module Query = [%relay.query {|
  query RoomOwnerQuery($roomId: ID!) {
    roomOwner(roomId: $roomId) {
      __typename

      ... on User {
        firstName
        lastName
      }

      ... on Group {
        fullName
      }
    }
  }
|}]

[@react.component]
let make = (~roomId) => {
  let queryData = Query.use(~variables={roomId: roomId}, ());

  switch (queryData.roomOwner) {
  | Some(roomOwner) =>
    <div>
      {React.string("Room is owned by ")}
      {switch (roomOwner) {
       | `User(user) =>
         React.string("user " ++ user.firstName ++ " " ++ user.lastName)
       | `Group(group) => React.string("group " ++ group.name)
       | `UnmappedUnionMember => React.string("-")
       }}
    </div>
  };
};
```

Let's break down what's going on here:

1. We make our union selection in the GraphQL query. Note that we select `__typename` even though we don't use it anywhere - ReasonRelay enforces this, you must select `__typename` for all unions. Don't worry, the compiler will scream at you if you forget it.
2. We fetch our query data, and we switch on `roomOwner` to make sure it's actually there in the data.
3. We then switch again, but this time on the polymorphic variant representing the union. This polymorphic variant will have each possible type of the union, and the fields selected on that type. It also adds `UnmappedUnionMember` to every union, which will force you to handle _what happens if there's another member added to the union before you have time to update your app_. This is pretty neat way to ensure you gracefully handle your schema evolving.

## Fragments on unions

Remember from the [using fragments](using-fragments) section that each fragment's data will need to be unwrapped before passed to its component, and that the function for unwrapping is available on the fragment module as `unwrapFragment_<propName>`?
Working with fragments in unions work the same way, but the function to unwrap will be located on a nested module _for that particular union_. Example:

```reason
/* RoomOwner.re */
module Query = [%relay.query {|
  query RoomOwnerQuery($roomId: ID!) {
    roomOwner(roomId: $roomId) {
      __typename

      ... on User {
        ...Avatar_user
      }

      ... on Group {
        fullName
      }
    }
  }
|}]

[@react.component]
let make = (~roomId) => {
  let queryData = Query.use(~variables={roomId: roomId}, ());

  switch (queryData.roomOwner) {
  | Some(roomOwner) =>
    <div>
      {React.string("Room is owned by ")}
      {switch (roomOwner) {
       | `User(user) =>
         <Avatar user={user->Query.Union_roomOwner.unwrapFragment_user} />
       | `Group(group) => React.string("group " ++ group.name)
       | `UnmappedUnionMember => React.string("-")
       }}
    </div>
  };
};
```

Notice how the function to unwrap the fragment is located on `Query.Union_roomOwner` and not directly on `Query` like we're used to.

The module for the union is always named `Union_<path_to_union>`. That's why it's called `Union_roomOwner` here. Let intellisense/autocomplete in your editor guide you!

## Wrapping up

And that's that! Keep the following in mind about unions and everything will be fine:

- Remember to select `__typename`
- Remember to handle `UnmappedUnionMember`
- Remember that functions to unwrap fragments in the union is available on a nested union module. The example above will have the union's assets available on `Query.Union_roomOwner`, and not directly on `Query`.
