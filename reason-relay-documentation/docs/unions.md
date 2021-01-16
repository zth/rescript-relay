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
/* RoomOwner.res */
module Query = %relay(
  `
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
`
)

@react.component
let make = (~roomId) => {
  let queryData = Query.use(~variables={roomId: roomId}, ())

  switch queryData.roomOwner {
  | Some(roomOwner) =>
    <div>
      {React.string("Room is owned by ")}
      {switch roomOwner {
      | #User(user) => React.string("user " ++ (user.firstName ++ (" " ++ user.lastName)))
      | #Group(group) => React.string("group " ++ group.name)
      | #UnselectedUnionMember(typename) => React.string("Unselected member type: " ++ typename)
      }}
    </div>
  }
}

```

Let's break down what's going on here:

1. We make our union selection in the GraphQL query. Note that we select `__typename` even though we don't use it anywhere - ReasonRelay enforces this, you must select `__typename` for all unions. Don't worry, the compiler will scream at you if you forget it.
2. We fetch our query data, and we switch on `roomOwner` to make sure it's actually there in the data.
3. We then switch again, but this time on the polymorphic variant representing the union. This polymorphic variant will have each possible type of the union, and the fields selected on that type. It also adds `UnselectedUnionMember(string)` to every union, which will force you to handle _what happens if there's another member added to the union before you have time to update your app_. The `string` payload is the `__typename` of the retrieved member that wasn't selected. This is pretty neat way to ensure you gracefully handle your schema evolving.

## Wrapping up

And that's that! Keep the following in mind about unions and everything will be fine:

- Remember to select `__typename`
- Remember to handle `UnselectedUnionMember`
