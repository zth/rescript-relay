---
id: enums
title: Enums
sidebar_label: Enums
---

#### Recommended background reading

- [Enums in GraphQL](https://graphql.org/learn/schema/#enumeration-types)

## Enums in RescriptRelay

Enums are modelled as polymorphic variants in RescriptRelay. Here's an example. Imagine the following GraphQL schema:

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

## Enums in inputs
Enums coming from the server are _unsafe_ in the sense that the server could at any point add or remove members from the enum, before you have a chance to update your code. To tackle this, any enum in _responses_ from the server will enforce having a default, catch-all case, to handle the fact that unknown values can show up.

However, things are different in _inputs_. While the enum shape might change on the sever before you've had a chance to deploy new code, unknown values can't get passed into your program. Therefore, enums in inputs are considered _exact_, and are emitted as `enum_TheEnumName_input` in the generated code.

### I need to use the generated enum elsewhere in my program
_Always_ prefer using `enum_TheEnumName_input` (the enum suffixed with `_input`).

## Wrapping up

Now you know all about enums in RescriptRelay!
