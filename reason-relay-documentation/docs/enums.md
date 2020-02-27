---
id: enums
title: Enums
sidebar_label: Enums
---

#### Recommended background reading

- [Enums in GraphQL](https://graphql.org/learn/schema/#enumeration-types)

## Enums in ReasonRelay

Just like with [unions](unions), enums cannot be modelled the same way they are in Flow/TypeScript in ReasonML, because ReasonML does not have _string literal unions_. So, when working with enums in ReasonRelay, we _automatically unwrap them_ to polymorphic variants.

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
    {switch (ticket.status) {
     | `Rejected => React.string("Ticket is rejected")
     | `Done
     | `Progress
     | `OnHold => React.string("Ticket is not rejected")
     | `FutureAddedValue_(_) => React.null
     }}
  </div>;
};
```

Notice `FutureAddedValue_` - this will help you protect your app against runtime errors if there's a new value added to the enum before you have a chance to update your app. The enum will be unwrapped as `FutureAddedValue_(string)`, where the `string` is the unknown enum value as a regular string, whenever it encounters a value that it doesn't know about from your current `schema.graphql`.

## Under the hood

The ReasonRelay compiler will generate a file called `SchemaAssets.re` in your `artifactDirectory` everytime it starts. `SchemaAssets.re` will contain a module for each _enum_ in your schema, and that module will contain type information and code for _wrapping and unwrapping enums_ to polymorphic variants, so you can use them in ReasonML.

## Wrapping up

Now you know all about enums in ReasonRelay!
