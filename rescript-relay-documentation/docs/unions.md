---
id: unions
title: Unions
sidebar_label: Unions
---

#### Recommended background reading

- [Union Types in GraphQL](https://graphql.org/learn/schema/#union-types)

## Unions in RescriptRelay

Since ReScripts type system is quite different to Flow/TypeScript, working with unions is different in RescriptRelay compared to regular Relay. In RescriptRelay, every union is _unwrapped to a variant_.

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

Here we have a union `Owner` that's either a `User` or a `Group`. There's also a root field called `roomOwner` which returns the `Owner` of a room. Let's look at how using that union looks in RescriptRelay:

```rescript
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
  let queryData = Query.use(~variables={roomId: roomId})

  switch queryData.roomOwner {
  | Some(roomOwner) =>
    <div>
      {React.string("Room is owned by ")}
      {switch roomOwner {
      | User({firstName, lastName}) =>
        React.string("user " ++ firstName ++ " " ++ lastName)
      | Group({name}) => React.string("group " ++ name)
      | UnselectedUnionMember(typename) =>
        React.string("Unselected member type: " ++ typename)
      }}
    </div>
  }
}

```

Let's break down what's going on here:

1. We make our union selection in the GraphQL query. Note that we select `__typename` even though we don't use it anywhere - RescriptRelay enforces this, you must select `__typename` for all unions. Don't worry, the compiler will scream at you if you forget it.
2. We fetch our query data, and we switch on `roomOwner` to make sure it's actually there in the data.
3. We then switch again, but this time on the variant representing the union. This polymorphic variant will have each possible type of the union, and the fields selected on that type. It also adds `UnselectedUnionMember(string)` to every union, which will force you to handle _what happens if there's another member added to the union before you have time to update your app_. The `string` payload is the `__typename` of the retrieved member that wasn't selected. This is pretty neat way to ensure you gracefully handle your schema evolving.

## Exhaustiveness Checking with `@exhaustive`

RescriptRelay provides an `@exhaustive` directive that helps ensure you've selected all available union members in your GraphQL queries. This directive can be applied to fields or fragment definitions and will trigger exhaustiveness checks at compile time.
This is useful when you there are unions in your schema where you'll want to be alerted at compile time that the server added new possible return values. This makes unions work just like enums in this regard.

### Usage

The `@exhaustive` directive is defined as:

```graphql
@exhaustive(ignore: [String!], disabled: Boolean) on FIELD | FRAGMENT_DEFINITION
```

Here's how to use it with our previous example:

```rescript
/* RoomOwner.res */
module Query = %relay(
  `
  query RoomOwnerQuery($roomId: ID!) {
    roomOwner(roomId: $roomId) @exhaustive {
      __typename

      ... on User {
        firstName
        lastName
      }

      ... on Group {
        name
      }
    }
  }
`
)
```

When you use `@exhaustive`, RescriptRelay will check that you've included fragments for all possible union members. If you're missing any, you'll get a compile-time error telling you which union members you haven't selected.

### Parameters

- **`ignore: [String!]`** - An array of union member type names to ignore during exhaustiveness checking. Use this when you intentionally don't want to handle certain union members.

```rescript
/* Ignore the Group type in exhaustiveness checking */
roomOwner(roomId: $roomId) @exhaustive(ignore: ["Group"]) {
  __typename

  ... on User {
    firstName
    lastName
  }
}
```

- **`disabled: Boolean`** - Set to `true` to completely disable exhaustiveness checking for this field while keeping the directive for documentation purposes.

```rescript
/* Temporarily disable exhaustiveness checking */
roomOwner(roomId: $roomId) @exhaustive(disabled: true) {
  __typename

  ... on User {
    firstName
    lastName
  }
}
```

### Auto-enabling for Mutations

You can also configure RescriptRelay to automatically apply exhaustiveness checking to mutation fields that return unions. Add `autoExhaustiveMutations: true` to your Relay configuration to enable this behavior for any top-level mutation field that returns a union type.

### Project-wide Exhaustive Types

If there are unions or interfaces you always want to handle exhaustively, list them in `autoExhaustiveTypes` in your `relay.config.js`:

```js
module.exports = {
  // ...
  autoExhaustiveTypes: ["UserNameRenderer", "NameRenderable"],
};
```

Any field or fragment returning those types will be treated as if it had `@exhaustive` applied. When you need to opt out for a specific selection, add `@nonExhaustive`:

```graphql
fragment UserName on User {
  nameRenderer @nonExhaustive {
    ... on PlainUserNameRenderer { __typename }
  }
}
```

`@nonExhaustive` also disables automatic checks on mutations when `autoExhaustiveMutations` is enabled.

## Wrapping up

And that's that! Keep the following in mind about unions and everything will be fine:

- Remember to select `__typename`
- Remember to handle `UnselectedUnionMember`
- Consider using `@exhaustive` to ensure you handle all union members
