---
id: enums
title: Enums
sidebar_label: Enums
---

#### Recommended background reading

- [Enums in GraphQL](https://graphql.org/learn/schema/#enumeration-types)

## Enums in ReasonRelay

Just like with [unions](unions), enums cannot be modelled the same way they are in Flow/TypeScript in ReasonML, because ReasonML does not have _string literal unions_. So, when working with enums in ReasonRelay, we _unwrap them_ to polymorphic variants.

The ReasonRelay compiler will generate a file called `SchemaAssets.re` in your `artifactDirectory` everytime it starts. `SchemaAssets.re` will contain a module for each _enum_ in your schema, and that module will contain type information and code for _wrapping and unwrapping your enum_ to polymorphic variants, so you can use them in ReasonML.

Here's an example. Imagine the following GraphQL schema:

```graphql
enum TicketStatus {
  Done
  Progress
  OnHold
  Rejected
}

type Ticket {
  id: ID!
  subject: String!
  status: TicketStatus!
}
```

Now, imagine we're writing a component that wants to show whether a particular ticket is rejected or not:

```reason
/* TicketRejectedStatusDisplayer.re */
module Fragment = [%relay.fragment
  {|
  fragment TicketRejectedStatusDisplayer_ticket on Ticket {
    status
  }
|}
];

[@react.component]
let make = (~ticket as ticketRef) => {
  let ticket = Fragment.use(ticketRef);

  <div>
    {switch (ticket##status |> SchemaAssets.Enum_TicketStatus.unwrap) {
     | `Rejected => React.string("Ticket is rejected")
     | `Done
     | `Progress
     | `OnHold => React.string("Ticket is not rejected")
     | `FUTURE_ADDED_VALUE__ => React.null
     }}
  </div>;
};
```

Let's break down what's happening:

1. Since we have an enum called `TicketStatus` in our schema, `SchemaAssets.re` will contain a module called `Enum_TicketStatus`. This module will contain a function called `unwrap`, which we can call on our enum to unwrap it into a polymorphic variant.
2. We then match on the polymorphic variants and display what we need. Notice `FUTURE_ADDED_VALUE__` - this helps you protect your app against runtime errors if there's a new value added to the enum before you have a chance to update your app. The enum will be unwrapped as `FUTURE_ADDED_VALUE__` whenever it encounters a value that it doesn't know about from your current `schema.graphql`.

### Using enums in inputs

Enums can also be used in inputs, whether it's an input for a mutation or as a variable for a query. When using enums that way in ReasonRelay, you'll need to _wrap_ your polymorphic variant back for the server to understand it.

Let's look at an example. Imagine this GraphQL schema and component displaying it's data:

```graphql
enum OnlineStatus {
  Online
  Offline
}

type User {
  id: ID!
  friendCount(status: OnlineStatus): Int!
}
```

```reason
/* UserFriendsDisplayer.re */
module Query = [%relay.query
  {|
  query UserFriendsDisplayerQuery($userId: ID!, $status: OnlineStatus!) {
    userById(id: $userId) {
      friendCount(status: $status)
    }
  }
|}
];

[@react.component]
let make = (~userId) => {
  let queryData =
    Query.use(
      ~variables={
        "userId": userId,
        "friendCount": SchemaAssets.Enum_OnlineStatus.wrap(`Online),
      },
      (),
    );

  switch (queryData##userById |> Js.Nullable.toOption) {
  | Some(user) =>
    <div>
      {React.string(string_of_int(user##friendCount) ++ " friends online.")}
    </div>
  | None => React.null
  };
};
```

Notice `SchemaAssets.Enum_OnlineStatus.wrap`? That's how you wrap an enum from a polymorphic variant so it can be sent to the server.

Now you know all about enums in ReasonRelay!
