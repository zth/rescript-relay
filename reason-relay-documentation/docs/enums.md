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

```rescript
/* TicketRejectedStatusDisplayer.res */
module Fragment = %relay(
  `
  fragment TicketRejectedStatusDisplayer_ticket on Ticket {
    status
  }
`
)

@react.component
let make = (~ticket as ticketRef) => {
  let ticket = Fragment.use(ticketRef)

  <div>
    {switch ticket.status {
    | #Rejected => React.string("Ticket is rejected")
    | #Done | #Progress | #OnHold => React.string("Ticket is not rejected")
    | _ => React.null
    }}
  </div>
}

```

Notice the catch all case `_ => React.null` - the way the enum type is shaped in ReScript ensures that we're enforced to add that catch all case. This will help you protect your app against runtime errors if there's a new value added to the enum before you have a chance to update your app.

## Under the hood

ReasonRelay will take care of converting between strings (as received from the server) and Reason's polymorphic variants for you. If you ever find you need to convert from/to a string by hand, the module where you have an enum selected will automatically expose code for doing that type of conversion.

Adding to the code sample above, the `Fragment` module would expose that like this:

- `Fragment.wrap_enum_TicketStatus` for going _from enum to string_.
- `Fragment.unwrap_enum_TicketStatus` for going _from string to enum_.

## Wrapping up

Now you know all about enums in ReasonRelay!
