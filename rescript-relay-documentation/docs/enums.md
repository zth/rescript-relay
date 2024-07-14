---
id: enums
title: Enums
sidebar_label: Enums
---

#### Recommended background reading

- [Enums in GraphQL](https://graphql.org/learn/schema/#enumeration-types)
- [Future proofing enums in Relay via Flow](https://github.com/facebook/relay/issues/2351)

## Enums in RescriptRelay

Enums are modelled as variants in RescriptRelay. Here's an example. Imagine the following GraphQL schema:

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
module TicketFragment = %relay(`
  fragment TicketRejectedStatusDisplayer_ticket on Ticket {
    status
  }
`)

@react.component
let make = (~ticket) => {
  let ticket = TicketFragment.use(ticket)

  <div>
    {switch ticket.status {
    | Rejected => React.string("Ticket is rejected")
    | Done | Progress | OnHold => React.string("Ticket is not rejected")
    | FutureAddedValue(_) => React.null
    }}
  </div>
}

```

Notice the catch all case `FutureAddedValue(_) => React.null` - this is where any future added enum value will end up until you have a chance to update and deploy code handling the new enum value. The way the enum type is shaped in ReScript ensures that we're enforced to add that catch all case. This will help you protect your app against runtime errors if there's a new value added to the enum before you have a chance to update your app.

## Enums coming from the server are unsafe

In GraphQL, making certain changes to your schema are considered _breaking_. For example, making a field in your schema nullable from being non-nullable is considered a breaking change, because client's consuming that schema won't be prepared for nullable values. However, while not officially in any spec, adding and removing enum and union members in your schema is commonly _not_ considered as a breaking change ([some more context here](https://github.com/facebook/relay/issues/2351)).

Because of that, enums coming from the server are considered _unsafe_ in the sense that the server could at any point add or remove members from the enum, before you have a chance to update your code. To tackle this, in RescriptRelay any enum in _responses_ from the server will enforce having a default, catch-all case, to handle the fact that unknown values can show up.

This is _good_, and a feature that simply isn't possible as of now in the Flow and TypeScript type systems.

However, things are different in _inputs_. While the enum shape might change on the sever before you've had a chance to deploy new code, unknown values can't get passed into your program. Therefore, enums in inputs are considered _exact_, and are emitted as `enum_TheEnumName_input` in the generated code. This enum type doesn't enforce catch all cases.

### Dealing with the unsafety of enums from the server

Now, this safety also means that the enum coming from the server isn't equivalent to the same enum when passed into for example variables. And this can be really annoying to work with, because it effectively means that the type system won't allow us to do this:

```rescript
let ticket = TicketFragment.use(ticket)

let (newStatus, setNewStatus) = React.useState(() => ticket.status)

...

// Uh-oh, we can't do this because we can't guarantee that `ticket.status` above,
// which is assigned to `newStatus`, is the values we expect it to be, since
// the server might've changed the enum members after we've deployed.
setTicketStatus(~variables={id: ticket.id, newStatus: newStatus})
```

Luckily, RescriptRelay gives you utils to deal with this situation. Whenever you want to move between the _unsafe_ enum coming directly from the server, and a _safe_ version of that enum that you know is correct, you can use `<enumName>_decode`. This will validate that the enum that came from the server is in fact in the shape you expect. The same example as above, but now ensuring that the enum in the state is actually what we want it to be:

```rescript
let ticket = TicketFragment.use(ticket)

let (newStatus, setNewStatus) = React.useState(() =>
  // This takes the enum from the server, and makes sure it's what we expect.
  // And if it isn't, which means `ticketStatus_decode` returned `None`, it
  // sets a default value instead.
  ticket.status
    ->TicketFragment.ticketStatus_decode
    ->Option.getOr(OnHold)
  )

// Yay, `newStatus` is now safe to use like we expect it to be!
```

#### Client extension enums are always considered safe

Any enum you add to your schema as a local schema extension (and therefore only exists on the client, not on the server) is considered safe, and won't have a catch all case emitted.

#### Opting out of safety

It is possible to opt out of this mechanism if you really really want to. You opt out by adding `@rescriptRelayAllowUnsafeEnum` to the field with the enum you want to treat as safe. Doing that will let you bail out of all safety checks, and always consider the enum value as safe (even if it's really not).

```rescript
module Fragment = %relay(`
  fragment SomeUserFragment_user on User  {
    firstName
    lastName
    onlineStatus @rescriptRelayAllowUnsafeEnum
  }
`)
```

### Mapping strings to your enum

In addition to the utils listed above, there's also a function available for taking a string and mapping it to your enum, if it's valid. An example:

```rescript
switch TicketFragment.ticketStatus_fromString(someString) {
| None => Console.log("Nope, this wasn't valid...")
| Some(validEnum) => Console.log(validEnum)
}
```

This can be really handy when working with URL parameters, storage, or any other place where you need to go back and forth between your enum and strings.

## Types for all enums in the schema

All enums in your schema will have types emitted into the global `RelaySchemaAssets_graphql.res` file. This is handy if you want to use your enums elsewhere in your application, without necessarily being in a specific Relay context where you've selected that particular enum.

## Wrapping up

Now you know all about enums in RescriptRelay!
