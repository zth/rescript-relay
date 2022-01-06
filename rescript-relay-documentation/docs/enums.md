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
module Fragment = %relay(`
  fragment TicketRejectedStatusDisplayer_ticket on Ticket {
    status
  }
`)

@react.component
let make = (~ticket) => {
  let ticket = Fragment.use(ticket)

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

## Enums coming from the server are unsafe

Enums coming from the server are _unsafe_ in the sense that the server could at any point add or remove members from the enum, before you have a chance to update your code. To tackle this, any enum in _responses_ from the server will enforce having a default, catch-all case, to handle the fact that unknown values can show up.

However, things are different in _inputs_. While the enum shape might change on the sever before you've had a chance to deploy new code, unknown values can't get passed into your program. Therefore, enums in inputs are considered _exact_, and are emitted as `enum_TheEnumName_input` in the generated code.

### Dealing with the unsafety of enums from the server

Now, this safety also means that the same enum coming from the server isn't equivalent to the same enum when passed into for example variables. And this can be really annoying to work with, because it effectively means that the type system won't allow us to do this:

```reason
// `user` here has a field `role`, which is the enum `UserRole`
let user = UserFragment.use(user)

let (newRole, setNewRole) = React.useState(() => user.role)

...

// Uh-oh, we can't do this because we can't guarantee that `user.role` above,
// which is assigned to `newRole`, is the values we expect it to be, since
// the server might've changed the enum members after we've deployed.
setUserRole(~variables={id: user.id, newRole: newRole}, ()))
```

Luckily, RescriptRelay gives you utils to deal with this situation. Whenever you want to move between the _unsafe_ enum coming directly from the server, and a _safe_ version of that enum that you know is correct, you can use `<enumName>_decode`. The same example as above, but now ensuring that the enum in the state is actually what we want it to be:

```reason
let user = UserFragment.use(user)

let (newRole, setNewRole) = React.useState(() =>
  // This takes the enum from the server, and makes sure it's what we expect.
  // And if it isn't, which means `onlineStatus_decode` returned `None`, it
  // sets a default value instead.
  user.role
    ->UserFragment.onlineStatus_decode
    ->Belt.Option.getWithDefault(#RegularUser)
  )

// Yay, `newRole` is now safe to use like we expect it to be!
```

### Mapping strings to your enum

In addition to the utils listed above, there's also a function available for taking a string and mapping it to your enum, if it's valid. An example:

```reason
switch UserFragment.onlineStatus_fromString(someString) {
  | None => Js.log("Nope, this wasn't valid...")
  | Some(validEnum) => Js.log(validEnum)
}
```

### I need to use the generated enum elsewhere in my program

_Always_ prefer using `enum_TheEnumName_input` (the enum suffixed with `_input`).

## Wrapping up

Now you know all about enums in RescriptRelay!
